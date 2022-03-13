import 'dart:convert';

import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/AppPages/AppWishlist/AddToWishlistResponse.dart';
import 'package:untitled2/AppPages/AppWishlist/RemoveItemWishListReposnse.dart';
import 'package:untitled2/AppPages/AppWishlist/WishlistResponse.dart';
import 'package:untitled2/AppPages/CustomLoader/CustomDialog/CustomDialog.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/LoginScreen/LoginxResponse.dart';
import 'package:untitled2/AppPages/MyAccount/MyAccount.dart';
import 'package:untitled2/AppPages/MyAddresses/MyAddresses.dart';
import 'package:untitled2/AppPages/SearchPage/SearchCategoryResponse/SearchCategoryResponse.dart';
import 'package:untitled2/AppPages/ShippingxxxScreen/BillingxxScreen/ShippingAddress.dart';
import 'package:untitled2/AppPages/StreamClass/NewPeoductPage/AddToCartResponse/AddToCartResponse.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/utils/ApiCalls/CategoryModel.dart';
import 'package:untitled2/utils/CartBadgeCounter/CartBadgetLogic.dart';
import 'package:untitled2/utils/utils/ApiParams.dart';
import 'package:untitled2/utils/utils/build_config.dart';
import 'package:url_launcher/url_launcher.dart';

class ApiCalls {
  static var customerGuid = ConstantsVar.prefs.getString('guestGUID');
  static final String cookie = '.Nop.Customer=' + customerGuid!;
  static final header = {'Cookie': cookie.trim()};

  /*Product List*/
  static Future getCategoryById(String id, BuildContext context, int pageIndex,
      {required String customerId}) async {
    print('Testing Api');

    print('Products List Customer Id:- ' + customerId);

    final baseUrl = Uri.parse(BuildConfig.base_url +
        'apis/GetProductsByCategoryId?CategoryId=$id&pageindex=$pageIndex&pagesize=16&CustId=$customerId');

    print('Product List Api>>>>' + baseUrl.toString());

    try {
      var response = await http.get(baseUrl, headers: header);

      print(jsonDecode(response.body)['ResponseData']);
      print(jsonEncode(response.headers));
      return jsonDecode(response.body);
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      context.loaderOverlay.hide();
    }
  }

  /*Get Api Token*/
  static Future getApiTokken(BuildContext context) async {
    print('I am being beaten');
    final body = {'email': 'apitest@gmail.com', 'password': '12345'};

    final uri = Uri.parse(BuildConfig.base_url + 'token/GetToken?');
    try {
      var response = await http.post(
        uri,
        body: body,
        // headers:header
      );
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        var apiTokken = responseData['tokenId'];
        print(apiTokken);
        ConstantsVar.prefs = await SharedPreferences.getInstance();
        ConstantsVar.prefs.setString('apiTokken', apiTokken);

        print(responseData);
        return responseData;
      } else {
        Fluttertoast.showToast(
            msg: 'Something went wrong. Please try again or reinstall the app',
            toastLength: Toast.LENGTH_LONG);
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }

  /*Login*/
  static Future login(
    BuildContext context,
    String email,
    String password,
    String screenName,
  ) async {
    CustomProgressDialog _dialog = CustomProgressDialog(context,
        dismissable: false,
        loadingWidget: SpinKitRipple(
          color: Colors.red,
          size: 40,
        ));
    _dialog.show();
    print(password);
    print('CustomerId:>>>' + ConstantsVar.prefs.getString('guestCustomerID')!);
    ConstantsVar.prefs = await SharedPreferences.getInstance();
    var guestUId = ConstantsVar.prefs.getString('guestGUID');
    ConstantsVar.prefs.setString('sepGuid', guestUId!);
    ConstantsVar.isVisible = true;
    final uri = Uri.parse(BuildConfig.base_url + 'AppCustomer/LogIn');
    print(uri);
    print(guestUId);
    final body = {
      'apiToken': ConstantsVar.apiTokken,
      'email': email,
      'UserName': '',
      "CustId": ConstantsVar.prefs.getString('guestCustomerID'),
      'Password': password,
      'Guid': guestUId
    };
    try {
      var response = await http.post(
        uri,
        body: body,
        headers: header,
      );
      if (response.statusCode == 200) {
        _dialog.dismiss();
        var responseData = jsonDecode(response.body);
        print(responseData);

        if (responseData
                .toString()
                .contains('The credentials provided are incorrect') ||
            responseData.toString().contains('No customer account found')) {
          print('Wrong account');
          Fluttertoast.showToast(
            msg: loginFailedMessage,
            gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_LONG,
          );
          context.loaderOverlay.hide();
          return false;
        } else if (responseData.toString().contains('Account is not active')) {
          Fluttertoast.showToast(
              msg: 'Account is not active yet.',
              toastLength: Toast.LENGTH_LONG);

          return false;
        } else if (responseData.toString().contains('Customer is deleted')) {
          Fluttertoast.showToast(
              msg: customerDeleteMessage, toastLength: Toast.LENGTH_LONG);
        } else {
          Fluttertoast.showToast(
            msg: successfullyLoginMessage,
            gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_LONG,
          );
          LoginResponse myResponse = LoginResponse.fromJson(responseData);
          var userName = myResponse.data.userName.toString();
          var email = myResponse.data.email.toString();
          var userId = myResponse.data.id.toString();
          var gUId = myResponse.data.guid.toString();
          var phnNumber = myResponse.data.phone;
          print('$userName $userId $email $gUId');

          ConstantsVar.prefs.setString('userName', '$userName');
          ConstantsVar.prefs.setString('userId', '$userId');
          ConstantsVar.prefs.setString('email', '$email');
          ConstantsVar.prefs.setString('guestCustomerID', userId);
          ConstantsVar.prefs.setString('userId', userId);
          ConstantsVar.prefs.setString('guestGUID', gUId);
          ConstantsVar.prefs
              .setString('phone', phnNumber == null ? '' : phnNumber);

          print(ConstantsVar.prefs.getString('guestCustomerID'));

          print('Success ');

          readCounter(customerGuid: gUId).then(
              (value) => context.read<cartCounter>().changeCounter(value));

          switch (screenName) {
            case 'Cart Screen':
              Navigator.pushAndRemoveUntil(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => MyHomePage(
                            pageIndex: 3,
                          )),
                  (route) => false);
              break;

            case 'Menu Page':
              Navigator.pushAndRemoveUntil(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => MyHomePage(
                      pageIndex: 4,
                    ),
                  ),
                  (route) => false);
              break;
            case 'My Account':
              Navigator.pushReplacement(context,
                  CupertinoPageRoute(builder: (context) => MyAccount()));
              break;
            case 'Product Screen':
              Navigator.pop(context, true);

              break;
            case 'Product List':
              Navigator.pop(context, true);

              break;
            case 'Cart Screen2':
              Navigator.pop(context, true);
              break;
            case 'Wishlist':
              Navigator.pop(context, true);
              break;
            default:
              Navigator.pushAndRemoveUntil(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => MyHomePage(pageIndex: 0)),
                  (route) => false);
              break;
          }

          return true;
        }

        // Fluttertoast.showToast(msg: responseData.toString().substring(0, 20));
        _dialog.dismiss();
      } else {
        _dialog.dismiss();
        ConstantsVar.showSnackbar(context, 'Unable to login', 5);
        return false;
      }
    } on Exception catch (e) {
      _dialog.dismiss();
      ConstantsVar.excecptionMessage(e);
      return false;
    }
  }

  /*Forgot Password*/
  static Future forgotPass(
    BuildContext context,
    String email,
  ) async {
    String message = '';
    final uri = Uri.parse(BuildConfig.base_url +
        'AppCustomer/ForgotPassword?apiToken=${ConstantsVar.apiTokken}&EMail=$email&CustId=${ConstantsVar.prefs.getString('userId') ?? ConstantsVar.prefs.getString('guestCustomerID')}');
    print(uri);
    try {
      var response = await http.get(uri, headers: header);
      print('${jsonDecode(response.body)}');
      message = jsonDecode(response.body)['Result'];
      return message;
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      message = e.toString();
      return message;
    }
  }

  /*Get Categories*/
  static Future getCategory(BuildContext context,
      {required String customerId}) async {
    print('Category Customer Id:- $customerId');
    final uri = Uri.parse(
        BuildConfig.base_url + 'apis/GetCategoryPage?CustId=$customerId');
    try {
      var response = await http.get(uri, headers: header);
      dynamic result = jsonDecode(response.body);
      print(result);
      return result;
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }

  /*Show Product Details*/
  static Future getProductData(String productId, BuildContext ctx,
      [String? customerid]) async {
    final url = BuildConfig.base_url +
        'apis/GetProductModelById?id=$productId&customerid=$customerid';
    print(url);

    try {
      final response = await http.get(Uri.parse(url), headers: header);

      print(jsonEncode(response.headers));

      return jsonDecode(response.body);
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }

  /*Add To Cart*/
  static Future addToCart(
      String customerId,
      String productId,
      BuildContext context,
      String attributeId,
      String name,
      String recipName,
      String email,
      String recipEmail,
      String message,
      {required String productName,
      required String productImage}) async {
    final uri = Uri.parse(BuildConfig.base_url +
        'apis/AddToCart?apiToken=${ConstantsVar.apiTokken}&customerid=$customerId&productid=$productId&itemquantity=1&' +
        'selectedAttributeId=$attributeId&recipientName=$recipName&recipientEmail=$recipEmail&senderName=$name&senderEmail=$email&giftCardMessage=$message');
    print(uri);
    try {
      dynamic response = await http.post(uri, headers: header);

      var result1 = jsonDecode(response.body);
      print(result1);
      print('Image Url>>>>>>>>>>>>' +
          productImage +
          '\n' +
          'Product Name>>>>>>>>> $productName');
      AddToCartResponse resp = AddToCartResponse.fromJson(result1);
      print(resp.warning);
      if (resp.warning != null) {
        // if (Theme.of(context).platform == TargetPlatform.android) {
        showDialog(
          context: context,
          builder: (context) => CustomDialogBox1(
            descriptions: '${resp.warning.join('\n')}',
            text: 'Okay',
            img: 'MyAssets/logo.png',
            reason: '',
          ),
        );
      } else {
        Fluttertoast.showToast(
          msg: addToCartMessage,
          toastLength: Toast.LENGTH_LONG,
        );
        // AwesomeNotifications().createNotification(
        //   content: NotificationContent(
        //       id: int.parse(productId),
        //       channelKey: 'Add to Cart Notification',
        //       title: 'Item is added to Cart Successfully',
        //       body: '$productName is added successfully.',
        //       bigPicture: '$productImage',
        //       notificationLayout: NotificationLayout.BigPicture,
        //       displayOnForeground: true),
        // );
        // Constan
        // context.read<cartCounter>()
        print('noting');
      }

      if (resp.error == null) {
      } else {
        showDialog(
          context: context,
          builder: (context) => CustomDialogBox1(
            descriptions: '${resp.error.toString()}',
            text: 'Okay',
            img: 'MyAssets/logo.png',
            reason: '',
          ),
        );
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }

  /*Show Cart*/
  static Future showCart(String customerId) async {
    //
    final uri = Uri.parse(BuildConfig.base_url +
        'AppCustomer/Cart?apiToken=${ConstantsVar.apiTokken}&CustomerId=$customerId');
    print(uri);
    try {
      var response = await http.get(uri, headers: header);

      var result = jsonDecode(response.body);
      ConstantsVar.isCart = false;
      print(result);
      return result;
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);

      ConstantsVar.isCart = true;
    }
  }

  /// Delete cart item id */
  static Future deleteCartItem(
      String customerId, int itemID, BuildContext ctx) async {
    CustomProgressDialog progressDialog = CustomProgressDialog(ctx,
        loadingWidget: SpinKitRipple(
          color: Colors.red,
          size: 40,
        ),
        dismissable: false);
    progressDialog.show();
    final queryParameters = {
      'apiToken': ConstantsVar.apiTokken,
      'CustomerId': customerId,
      'shoppingCartItemId': itemID.toString(),
    };
    // final uri = Uri.parse(BuildConfig.base_url + BuildConfig.remove_cart_item_url, queryParameters);
    final uri = Uri.https(BuildConfig.base_url_for_apis,
        BuildConfig.remove_cart_item_url, queryParameters);
    print('remove_cart_url>>>> $uri');
    try {
      var response = await http.get(uri, headers: header);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        progressDialog.dismiss();
        return result;
      } else {
        progressDialog.dismiss();
        Fluttertoast.showToast(
          msg: 'Something went wrong. Please try again',
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }

  /// Apply coupon code on the cart //
  static Future<String> applyCoupon(String apiToken, String customerId,
      String coupon, RefreshController refresh) async {
    ConstantsVar.prefs.setString('discount', coupon);
    String success = '';
    final uri = Uri.parse(BuildConfig.base_url + BuildConfig.apply_coupon_url);

    final body = {
      ApiParams.PARAM_API_TOKEN: apiToken,
      ApiParams.PARAM_CUSTOMER_ID: customerId,
      ApiParams.PARAM_DISCOUNT_COUPON: coupon,
    };

    try {
      var response = await http.post(uri, body: body, headers: header);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        print('coupon result>>>> $result');

        Map<String, dynamic> map = json.decode(response.body);

        if (map['status'] == 'Success') {
          List<dynamic> data = map["Message"];
          print(data[0]);

          if (data[0] ==
              'The coupon code you entered couldn\'t be applied to your order') {
            // Means coupon is not applied
            success = 'false';
          } else {
            refresh.requestRefresh(needMove: true);
            success = 'true';
          }
          Fluttertoast.showToast(
            msg: data[0],
            toastLength: Toast.LENGTH_LONG,
          );
        } else {
          List<dynamic> data = map["Message"];
          print(data[0]);
          Fluttertoast.showToast(
            msg: data[0],
            toastLength: Toast.LENGTH_LONG,
          );
        }
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
    return success;
  }

  /// Remove coupon code on the cart //
  static Future<String> removeCoupon(BuildContext context, String apiToken,
      String customerId, String coupon, RefreshController refresh) async {
    String success = '';
    final uri = Uri.parse(BuildConfig.base_url + BuildConfig.remove_coupon_url);

    final body = {
      ApiParams.PARAM_API_TOKEN: apiToken,
      ApiParams.PARAM_CUSTOMER_ID: customerId,
      ApiParams.PARAM_DISCOUNT_COUPON: coupon,
    };
    print(body);
    try {
      var response = await http.post(uri, body: body, headers: header);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        print('coupon result>>>> $result');

        Map<String, dynamic> map = json.decode(response.body);
        String couponStats = map['status'];
        String data = map["Message"];
        print(data);

        if (couponStats.contains('Failed')) {
          print(couponStats);
        } else {
          ConstantsVar.prefs.setString('discount', '');
          refresh.requestRefresh(needMove: true);
        }
        success = 'true';
        Fluttertoast.showToast(
          msg: data,
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
    return success;
  }

  /// Adding gift card number //
  static Future<String> applyGiftCard(
      String apiToken, String customerId, String giftcard) async {
    String success = '';
    final uri = Uri.parse(BuildConfig.base_url + BuildConfig.gift_card_url);

    final body = {
      ApiParams.PARAM_API_TOKEN: apiToken,
      ApiParams.PARAM_CUSTOMER_ID: customerId,
      ApiParams.PARAM_GIFT_COUPON: giftcard,
    };

    try {
      var response = await http.post(uri, body: body, headers: header);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        print('gift card result>>>> $result');

        Map<String, dynamic> map = json.decode(response.body);

        if (map['status'] == 'Failed') {
          success = 'false';
        } else {
          success = 'true';
        }

        Fluttertoast.showToast(
          msg: map['Message'],
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
    return success;
  }

  /// Remove gift card
  static Future<String> removeGiftCoupon(String apiToken, String customerId,
      String giftcard, RefreshController refreshController) async {
    String success = '';
    final uri =
        Uri.parse(BuildConfig.base_url + BuildConfig.remove_gift_card_url);

    final body = {
      ApiParams.PARAM_API_TOKEN: apiToken,
      ApiParams.PARAM_CUSTOMER_ID: customerId,
      ApiParams.PARAM_GIFT_COUPON: giftcard,
    };

    try {
      var response = await http.post(uri, body: body, headers: header);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        print('remove gift card result>>>> $result');

        Map<String, dynamic> map = json.decode(response.body);

        if (map['status'] == 'Failed') {
          success = 'false';
        } else {
          success = 'true';
          refreshController.requestRefresh(needMove: true);
        }

        Fluttertoast.showToast(
          msg: map['Message'],
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
    return success;
  }

  ///Get all addresses api
  static Future allAddresses(
      String apiToken, String customerId, BuildContext ctx) async {
    // bool apiresult = false;

    final uri = Uri.parse(BuildConfig.base_url +
        'apis/GetCustomerAddressList?apiToken=$apiToken&customerid=$customerId');

    print('address url>>> $uri');
    try {
      var response = await http.get(uri, headers: header);
      if (response.statusCode == 200) {
        // var result = jsonDecode(response.body);
        Map<String, dynamic> result = json.decode(response.body);
        // apiresult = true;
        print('addresses>>> $result');
        return result;
      } else {
        // apiresult = false;
        Fluttertoast.showToast(
          msg: 'Something went wrong. Please try again.',
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);

      ctx.loaderOverlay.hide();
    }
  }

  /// Select billing address api
  static Future selectBillingAddress(
      String apiToken, String customerId, String addressId) async {
    final queryParameters = {
      ApiParams.PARAM_API_TOKEN: apiToken,
      ApiParams.PARAM_CUSTOMER_ID: customerId,
      ApiParams.PARAM_ADDRESS_ID: addressId
    };

    final uri = Uri.https(BuildConfig.base_url_for_apis,
        BuildConfig.select_billing_address, queryParameters);

    print('select address url>>> $uri');
    try {
      var response = await http.get(uri, headers: header);
      if (response.statusCode == 200) {
        Map<String, dynamic> result = json.decode(response.body);
        print('selectbillingaddress>>> $result');
        return result;
      } else {
        Fluttertoast.showToast(
          msg: 'Something went wrong. Please try again',
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }

  /// get shipping addresses
  static Future getShippingAddresses(String apiToken, String customerId) async {
    final queryParameters = {
      ApiParams.PARAM_API_TOKEN: apiToken,
      ApiParams.PARAM_CUSTOMER_ID: customerId,
    };

    final uri = Uri.https(BuildConfig.base_url_for_apis,
        BuildConfig.get_shipping_address_url, queryParameters);

    print('shipping>>> $uri');
    try {
      var response = await http.get(uri, headers: header);
      if (response.statusCode == 200) {
        Map<String, dynamic> result = json.decode(response.body);
        print('shippingaddress>>> $result');
        return result;
      } else {
        Fluttertoast.showToast(
          msg: 'Something went wrong. Please try again.',
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }

  ///Select shipping address
  static Future selectShippingAddress(
      String apiToken, String customerid, String addressId) async {
    final queryParameters = {
      ApiParams.PARAM_API_TOKEN: apiToken,
      ApiParams.PARAM_CUSTOMER_ID: customerid,
      ApiParams.PARAM_ADDRESS_ID: addressId,
    };

    final uri = Uri.https(BuildConfig.base_url_for_apis,
        BuildConfig.select_shipping_address_url, queryParameters);

    print('selectshipping>>> $uri');
    try {
      var response = await http.get(uri, headers: header);
      if (response.statusCode == 200) {
        Map<String, dynamic> result = json.decode(response.body);
        print('selectshippingaddress>>> $result');
        return result;
      } else {
        Fluttertoast.showToast(
          msg: 'Something went wrong. Please try again',
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }

  /// Order summary api
  static Future showOrderSummary(String apiToken, String customerId) async {
    final queryParameters = {
      ApiParams.PARAM_API_TOKEN: apiToken,
      "CustomerId": customerId,
    };

    final uri = Uri.https(BuildConfig.base_url_for_apis,
        BuildConfig.show_order_summary_url, queryParameters);

    print('Order Summary>>> $uri');
    try {
      var response = await http.get(uri, headers: header);
      if (response.statusCode == 200) {
        Map<String, dynamic> result = json.decode(response.body);
        print('Order Summary result>>> $result');
        return result;
      } else {
        Fluttertoast.showToast(
          msg: 'Something went wrong. Please try again.',
        );
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }

  ///Update cart url
  static Future updateCart(
      String customerId, String quantity, int itemId, BuildContext ctx) async {
    final uri = Uri.parse(BuildConfig.base_url +
        'apis/UpdateCart?ShoppingCartItemIds=$itemId&Qty=$quantity&CustomerId=$customerId');
    // String success = 'false';

    try {
      var response = await http.post(uri, headers: header);
      var result = jsonDecode(response.body);
      print('update cart result>>>> $result');
      ctx.loaderOverlay.hide();
      // Fluttertoast.showToast(msg: result);
    } on Exception catch (e) {
      ctx.loaderOverlay.hide();
      ConstantsVar.excecptionMessage(e);
    }
  }

  static Future<bool> onWillPop() {
    DateTime currentBackPressTime = DateTime.now();
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: 'Press again to exit');
      return Future.value(false);
    }
    return Future.value(true);
  }

  static launchUrl(String myUrl) async {
    if (await canLaunch(myUrl)) {
      await launch(
        myUrl, forceWebView: false,
        forceSafariVC: false,
        // forceWebView: true,
      );
      await launch(
        myUrl,
        // forceSafariVC: true,
        forceWebView: false,
        forceSafariVC: false,
      );
    } else {
      Fluttertoast.showToast(msg: 'Cannot launch this $myUrl');
    }
  }

/*Add New Address*/
  static Future addNewAddress(BuildContext context, String uriName,
      String apiToken, String customerId, String snippingModel) async {
    final body = {
      ApiParams.PARAM_API_TOKEN: apiToken,
      ApiParams.PARAM_CUSTOMER_ID: customerId,
      'data': snippingModel,
    };

    final uri =
        Uri.parse(BuildConfig.base_url + 'AppCustomer/AddCustomerAddress?');
    print(uri);
    try {
      var response = await http.post(uri, body: body, headers: header);
      print(jsonDecode(response.body));

      //It means adding address is from my account screen
      Navigator.pushReplacement(
          context, CupertinoPageRoute(builder: (context) => MyAddresses()));
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }

  /*Add and select new billing address*/
  static Future addBillingORShippingAddress(
      BuildContext context,
      String uriName,
      String apiToken,
      String customerId,
      String snippingModel) async {
    final body = {
      ApiParams.PARAM_API_TOKEN: apiToken,
      ApiParams.PARAM_CUSTOMER_ID: customerId,
      ApiParams.PARAM_SHIPPING: snippingModel,
    };

    final uri =
        Uri.parse(BuildConfig.base_url + 'apis/AddSelectNewBillingAddress?');
    print(uri);
    try {
      var response = await http.post(uri, body: body, headers: header);
      print(jsonDecode(response.body));
      if (uriName == 'MyAccountAddAddress') {
        //It means adding address is from my account screen
        Navigator.pushReplacement(
            context, CupertinoPageRoute(builder: (context) => MyAddresses()));
      } else {
        // Add adding from billing screen
        Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
                builder: (context) => ShippingAddress(
                    // tokken: apiToken,
                    // customerId: customerId,
                    )));
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }

  /*Add and select new shipping address*/
  static Future addAndSelectShippingAddress(
      String apiToken, String customerId, String id2) async {
    final uri = Uri.parse(
        BuildConfig.base_url + BuildConfig.add_select_shipping_address_url);
    final snippingModel = jsonEncode({
      'address': {},
      'PickUpInStore': true,
      'pickupPointId': id2,
    });
    final body = {
      ApiParams.PARAM_API_TOKEN: apiToken,
      ApiParams.PARAM_CUSTOMER_ID: customerId,
      'ShippingAddressModel': snippingModel,
    };
    try {
      var resp = await http.post(
        uri,
        body: body,
        headers: header,
      );
      print(jsonDecode(resp.body));
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }

  /*For Badge Count*/

  static Future readCounter({required String customerGuid}) async {
    int count = 0;
    // print(header);
    final uri = Uri.parse(BuildConfig.base_url +
        'apis/CartCount?cutomerGuid=$customerGuid&CustId=${ConstantsVar.prefs.getString('guestCustomerID')}');
    // var response = await http.get(uri, headers: header);

    print('Read Count header>>>>>>>>>>>>>>>>>>>>' + jsonEncode(header));

    print('Read Count Api>>>>>>>>>>>>>>>>>>>>>>>' + uri.toString());
    try {
      var response = await http.get(uri, headers: header);

      // print(cookie);
      dynamic result = jsonDecode(response.body);
      print('Auto Generated Read Count header>>>>>>>>>>>>>>>>>>>>' +
          jsonEncode(response.headers));
      print(result);
      if (result['ResponseData'] != null &&
          result['status'].contains('success')) {
        count = int.parse(result['ResponseData']);

        return count;
      } else {
        count = 0;
        return count;
      }
    } on Exception catch (e) {
      count = 0;
      ConstantsVar.excecptionMessage(e);
      return count;
    }
    // return count;
  }

  /* Edit and save address */
  static Future editAndSaveAddress(
    BuildContext context,
    String apiToken,
    String customerId,
    String addressId,
    String data,
    bool isEditAddress,
  ) async {
    context.loaderOverlay.show(
      widget: SpinKitRipple(
        color: Colors.red,
        size: 90,
      ),
    );
    final body = {
      ApiParams.PARAM_API_TOKEN: apiToken,
      ApiParams.PARAM_CUSTOMER_ID2: customerId,
      ApiParams.PARAM_ADDRESS_ID: addressId,
      ApiParams.PARAM_DATA: data
    };

    final uri =
        Uri.parse(BuildConfig.base_url + BuildConfig.edit_address + "?");
    print(uri);
    try {
      context.loaderOverlay.hide();
      var response = await http.post(uri, body: body, headers: header);
      print(jsonDecode(response.body));
      if (isEditAddress == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MyAddresses(),
          ),
        );
      } else {
        Navigator.pop(context);
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      context.loaderOverlay.hide();
    }
  }

  /* Delete address from my account */
  static Future deleteAddress(BuildContext context, String apiToken,
      String customerId, String addressId) async {
    // Fluttertoast.showToast(msg: customerId);
    final body = {
      ApiParams.PARAM_API_TOKEN: apiToken,
      ApiParams.PARAM_CUSTOMER_ID: customerId,
      ApiParams.PARAM_ADDRESS_ID2: addressId,
    };
    CustomProgressDialog progressDialog = CustomProgressDialog(context,
        loadingWidget: SpinKitRipple(
          color: Colors.red,
          size: 40,
        ),
        dismissable: false);
    progressDialog.show();
    final uri = Uri.parse(BuildConfig.base_url + BuildConfig.delete_address);
    print(uri);
    try {
      var response = await http.post(uri, body: body, headers: header);
      progressDialog.dismiss();

      print(jsonDecode(response.body));
      Fluttertoast.showToast(msg: 'Address deleted.');
    } on Exception catch (e) {
      progressDialog.dismiss();

      ConstantsVar.excecptionMessage(e);
    }
  }

/*Show Billing Address*/
  static Future getBillingAddress(
      String apiToken, String customerId, BuildContext ctx) async {
    final queryParameters = {
      ApiParams.PARAM_API_TOKEN: apiToken,
      ApiParams.PARAM_CUSTOMER_ID: customerId,
    };

    final uri = Uri.https(BuildConfig.base_url_for_apis,
        BuildConfig.billing_address, queryParameters);

    print('address url>>> $uri');
    try {
      var response = await http.get(uri, headers: header);
      if (response.statusCode == 200) {
        // var result = jsonDecode(response.body);
        Map<String, dynamic> result = json.decode(response.body);
        // apiresult = true;
        print('addresses>>> $result');
        return result;
      } else {
        // apiresult = false;
        Fluttertoast.showToast(
          msg: 'Something went wrong. Please try again.',
        );
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);

      ctx.loaderOverlay.hide();
    }
  }

  /*Subscribe Product*/
  static Future subscribeProdcut(
      {required String productId,
      required String customerId,
      required String apiToken}) async {
    final uri = Uri.parse(
        BuildConfig.base_url + 'apis/SubscribeBackInStockNotification?');
    var response = await http.post(uri, body: {
      'apiToken': apiToken,
      'customerid': customerId,
      'productId': productId,
    });
    try {
      var jsonResult = jsonDecode(response.body);
      String _status = jsonResult['Status'].toString();
      String _message = jsonResult['Message'].toString();
      print(response.body);
      if (_status.contains('Failed')) {
        if (_message.contains('No Customer Found with Id: $customerId')) {
          Fluttertoast.showToast(
            msg: 'Customer Id does not exist.',
            toastLength: Toast.LENGTH_LONG,
          );
          _message = 'Notify Me\!';
          return _message;
        } else if (_message
            .contains('No product found with the specified id')) {
          Fluttertoast.showToast(
              msg: 'No product available with this product id: $productId',
              toastLength: Toast.LENGTH_LONG);
          _message = 'Notify Me\!';
          return _message;
        } else if (_message.contains('Invalid API token: $apiToken')) {
          Fluttertoast.showToast(
              msg:
                  'Api Token has been expired. Please log out or reinstall the app.',
              toastLength: Toast.LENGTH_LONG);
          _message = 'Notify Me\!';
          return _message;
        } else if (_message
            .contains('Only registered customers can use this feature')) {
          Fluttertoast.showToast(
              msg: 'Only registered customers can use this feature.',
              toastLength: Toast.LENGTH_LONG);
          _message = 'Notify Me\!';
          return _message;
        }
        _message = 'Notify Me\!';
        return _message;
      } else {
        if (_message.contains('Subscribed')) {
          Fluttertoast.showToast(
                  msg: subscribeMessage, toastLength: Toast.LENGTH_LONG)
              .then((value) async => await FacebookAppEvents().logSubscribe(
                    orderId: productId,
                    currency: CurrencyCode.AED.name,
                    price: 0.0,
                  ));

          _message = 'Unsubscribe';
          return _message;
        } else {
          Fluttertoast.showToast(
              msg: notifyMessage, toastLength: Toast.LENGTH_LONG);
          _message = 'Notify Me\!';
          return _message;
        }
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }

  /*Search Categories*/
  static Future<List<ResponseDatum>> getSearchCategory(
      {required String customerId}) async {
    List<ResponseDatum> _searchCategoryList = [];
    final uri = Uri.parse(BuildConfig.base_url +
        'apis/GetSearchScreenCategories?CustId=${ConstantsVar.prefs.getString('guestCustomerID')}');
    print(uri);
    try {
      var response = await http.get(uri, headers: header);
      // List<dynamic> result = ;
      SearchCategoryResponse _mList =
          SearchCategoryResponse.fromJson(json.decode(response.body));

      _searchCategoryList = _mList.responseData;

      return _searchCategoryList;
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      _searchCategoryList = [];
      return _searchCategoryList;
    }
  }

  /*Add To Wishlist*/
  static Future<bool> addToWishlist({
    required String apiToken,
    required String customerId,
    required String productId,
    required String imageUrl,
    required String productName,
    required BuildContext context,
    required String senderName,
    required String receiverName,
    required String senderEmail,
    required String receiverEmail,
    required String msg,
    required String attributeId,
  }) async {
    print('Api Token>>>>>>>>>>>$apiToken');
    print('Customer Id>>>>>>>>>>>$customerId');
    final url = Uri.parse(BuildConfig.base_url +
        'apis/AddToWishlist?apiToken=$apiToken&customerid=$customerId&productid=$productId&itemquantity=1&recipientName=$receiverName&recipientEmail=$receiverEmail&senderName=$senderName&senderEmail=$senderEmail&giftCardMessage=$msg&selectedAttributeId=$attributeId');
    print('Url>>>>>>>>${url.toString()}');

    try {
      var response = await http.get(url, headers: header);
      print('Add to Wishlist>>>>>>>>>>>>>>>>>' + response.body);
      if (jsonDecode(response.body)['status'].toString().contains('Failed')) {
        Fluttertoast.showToast(
          msg: List<String>.from(jsonDecode(response.body)['warnings'])
              .toList()
              .join("\n"),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
        );

        return false;
      } else {
        AddToWishlist result =
            AddToWishlist.fromJson(jsonDecode(response.body));

        if ((result.result != '' || result.result != null) &&
            result.result !=
                'There was an error adding the product to your wishlist.') {
          Fluttertoast.showToast(
            msg: 'Product Wishlisted.',
            toastLength: Toast.LENGTH_LONG,
          );

          return true;
        } else {
          Fluttertoast.showToast(
            msg: result.warning[0],
            toastLength: Toast.LENGTH_LONG,
          );

          return false;
        }
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      return false;
    }
  }

  /*Show Wishlist*/
  static Future<List<WishlistItem>> getWishlist(
      {required String apiToken, required String customerId}) async {
    List<WishlistItem> items = [];

    final url = Uri.parse(BuildConfig.base_url +
        'AppCustomer/Wishlist?apiToken=$apiToken&CustId=$customerId');
    late WishlistResponse response;
    try {
      var jsonResponse = await http.get(url, headers: header);
      print(jsonResponse.body);
      if (jsonDecode(jsonResponse.body)['status'].toString() == 'Success') {
        try {
          response = WishlistResponse.fromJson(jsonDecode(jsonResponse.body));
        } on Exception catch (e) {
          items = [];
          return items;
          // TODO
        }
        if (response.status != 'Success') {
          items = [];
          return items;
        } else {
          items = response.responseData!.items;
          return items;
        }
      } else {
        items = [];
        return items;
      }
    } on Exception catch (e) {
      items = [];
      ConstantsVar.excecptionMessage(e);
      return items;
    }
  }

  /*Remove Product from Wishlist*/
  static Future<bool> removeFromWishlist(
      {required String apiToken,
      required String customerId,
      required String productId,
      required String productName,
      required String imageUrl,
      required BuildContext context}) async {
    final url = Uri.parse(BuildConfig.base_url +
        'AppCustomer/RemoveItemWishlist?apiToken=$apiToken&CustId=$customerId&productid=$productId');
    try {
      var jsonResponse = await http.get(url, headers: header);
      if (jsonDecode(jsonResponse.body)['status'].toString() == 'Success') {
        RemoveItemWishlistResponse _response =
            RemoveItemWishlistResponse.fromJson(jsonDecode(jsonResponse.body));
        if (_response.status.contains('Success')) {
          Fluttertoast.showToast(
            msg: 'Product Removed from Wishlist successfully.',
            toastLength: Toast.LENGTH_LONG,
          );

          return false;
        } else {
          Fluttertoast.showToast(
            msg: _response.message.toString(),
            toastLength: Toast.LENGTH_LONG,
          );

          return true;
        }
      } else {
        Fluttertoast.showToast(
          msg: List<String>.from(jsonDecode(jsonResponse.body)['warnings'])
              .toList()
              .join("\n"),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
        );

        return false;
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      return true;
    }
  }

  /*Save Recently View Product */
  static void saveRecentProduct({required String productId}) {
    List<String> productIDs = ConstantsVar.prefs
        .getStringList('RecentProducts')!
        .toList(growable: true);

    print('ProductIDS>>>>>>>>>>>>>>>>>' + productIDs.join(','));
    if ((productIDs.length == 0 || productIDs == null)) {
      productIDs.add(productId);
      ConstantsVar.prefs.setStringList('RecentProducts', productIDs);
    } else if (!productIDs.contains(productId)) {
      if (productIDs.length <= 10 && !productIDs.contains(productId)) {
        if (productIDs.length == 10 && !productIDs.contains(productId)) {
          justRotate(productId: productId, someArray: productIDs);
        } else {
          productIDs.insert(0, productId);
          ConstantsVar.prefs.setStringList('RecentProducts', productIDs);
          print('New Joined Id>>>>' + productId);
          print('New Joined Id>>>>' + productIDs.join(','));
          print(productIDs.length.toString());
        }
      }

      print(productIDs.length.toString());
    } else {
      productIDs.remove(productId);
      productIDs.insert(0, productId);
      ConstantsVar.prefs.setStringList('RecentProducts', productIDs);
    }
  }

  /*Logic for rotating recently viewed products*/
  static void justRotate({
    required List<String> someArray,
    required String productId,
  }) {
    for (int i = (someArray.length - 1); i > 0; i--) {
      someArray[i] = someArray[i - 1];
    }

    someArray[0] = productId;
    for (String element in someArray) {
      print('PrODUCTID>>>>>>' + element);
    }
    ConstantsVar.prefs.setStringList('RecentProducts', someArray);
  }

  /*Share Wishlist*/
  static Future<String> shareWishlist({
    required String customerEmail,
    required String friendEmail,
    required String apiToken,
    required String customerId,
    required String message,
  }) async {
    String result = '';
    final url = Uri.parse(BuildConfig.base_url + 'AppCustomer/ShareWishlist?');
    try {
      var response = await http.post(url,
          body: {
            'apiToken': apiToken,
            'customerid': customerId,
            'personalMessage': message,
            'customerEmail': customerEmail,
            'friendsEmail': friendEmail,
          },
          headers: header);
      result = response.body;
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      result = 'Nothing Here';
    }
    return result;
  }

  /*Delete Wishlist*/
  static Future<String> deleteWishlist({
    required String apiToken,
    required String customerId,
  }) async {
    String result = '';
    final url = Uri.parse(BuildConfig.base_url + 'AppCustomer/DeleteWishlist');
    try {
      var response = await http.post(url,
          body: {
            'apiToken': apiToken,
            'customerid': customerId,
          },
          headers: header);
      result = response.body;
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      result = 'Nothing Here';
    }
    return result;
  }
}
