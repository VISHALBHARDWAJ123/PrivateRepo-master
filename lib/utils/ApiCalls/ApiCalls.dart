import 'dart:convert';

import 'package:flutter/foundation.dart' show TargetPlatform;

// import 'dart:io';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/AppPages/CustomLoader/CustomDialog/CustomDialog.dart';
import 'package:untitled2/AppPages/ShippingxxxScreen/BillingxxScreen/ShippingAddress.dart';
import 'package:untitled2/AppPages/ShippingxxxScreen/ShippingPage.dart';
import 'package:untitled2/AppPages/StreamClass/NewPeoductPage/AddToCartResponse/AddToCartResponse.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/utils/CartBadgeCounter/CartBadgetLogic.dart';
import 'package:untitled2/utils/utils/ApiParams.dart';
import 'package:untitled2/utils/utils/build_config.dart';
import 'package:url_launcher/url_launcher.dart';

class ApiCalls {
  static Future getCategoryById(String id, BuildContext context,
      int pageIndex) async {
    print('Testing Api');
    final baseUrl = Uri.parse(BuildConfig.base_url +
        'apis/GetProductsByCategoryId?CategoryId=$id&pageindex=$pageIndex&pagesize=16');

    print(baseUrl);
    try {
      ConstantsVar.isVisible = true;
      var response = await http.get(baseUrl);

      print(jsonDecode(response.body)['ResponseData']);
      return jsonDecode(response.body);
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      context.loaderOverlay.hide();
    }
  }

  static Future getApiTokken(BuildContext context) async {
    final body = {'email': 'apitest@gmail.com', 'password': '12345'};

    final uri = Uri.parse(BuildConfig.base_url + 'token/GetToken?');
    try {
      var response = await http.post(uri, body: body);
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        var apiTokken = responseData['tokenId'];
        ConstantsVar.prefs = await SharedPreferences.getInstance();
        ConstantsVar.prefs.setString('apiTokken', apiTokken);

        print(responseData);
        return responseData;
      } else {
        Fluttertoast.showToast(msg: 'Something went wrong');
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  static Future login(BuildContext context,
      String email,
      String password,) async {
    print(password);

    context.loaderOverlay.show(
        widget: SpinKitRipple(
          color: Colors.red,
          size: 90,
        ));
    ConstantsVar.prefs = await SharedPreferences.getInstance();
    var guestUId = ConstantsVar.prefs.getString('guestGUID');
    ConstantsVar.isVisible = true;
    final uri = Uri.parse(BuildConfig.base_url + 'Customer/LogIn');
    print(uri);
    final body = {
      'apiToken': ConstantsVar.apiTokken,
      'email': email,
      'UserName': '',
      'Password': password,
      'Guid': guestUId
    };
    try {
      var response = await http.post(uri, body: body);
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        print(responseData);

        if (responseData
            .toString()
            .contains('The credentials provided are incorrect') ||
            responseData.toString().contains('No customer account found')) {
          print('Wrong account');
          Fluttertoast.showToast(
            msg: 'Wrong Details',
            gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_LONG,
          );
          context.loaderOverlay.hide();
        } else if (responseData.toString().contains('Account is not active')) {
          Fluttertoast.showToast(msg: 'Account is not active yet.');
          context.loaderOverlay.hide();
        } else {
          Fluttertoast.showToast(
            msg: 'Successfully Login',
            gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_LONG,
          );

          context.loaderOverlay.hide();
          print('Success ');
        }

        // Fluttertoast.showToast(msg: responseData.toString().substring(0, 20));
        var userName = responseData['data']['Value']['UserName'];
        var email = responseData['data']['Value']['Email'];
        var userId = '${responseData['data']['Value']['Id']}';
        print('$userName $userId $email');

        ConstantsVar.prefs.setString('userName', '$userName');
        ConstantsVar.prefs.setString('userId', '$userId');
        ConstantsVar.prefs.setString('email', '$email');
        ConstantsVar.prefs.setString('guestCustomerID', userId);
        print(ConstantsVar.prefs.getString('guestCustomerID'));
        ConstantsVar.prefs.commit();
        return responseData;
      } else {
        context.loaderOverlay.hide();
        ConstantsVar.showSnackbar(context, 'Unable to login', 5);
      }
    } on Exception catch (e) {
      context.loaderOverlay.hide();
      ConstantsVar.showSnackbar(context, e.toString(), 5);
    }
  }

  static Future forgotPass(BuildContext context,
      String email,) async {
    bool? boolean;
    final uri = Uri.parse(BuildConfig.base_url +
        'customer/ForgotPassword?apiToken=${ConstantsVar
            .apiTokken}&email=$email');

    try {
      var response = await http.get(uri);
      print('${jsonDecode(response.body)}');
    } on Exception catch (e) {
      boolean = false;
      ConstantsVar.showSnackbar(context, e.toString(), 5);
      return boolean;
    }
  }

  // static Future homeScreenProduct(BuildContext context) async {
  //   final uri = Uri.parse(BuildConfig.base_url +
  //       'apis/GetHomeScreenProducts?apiToken=${ConstantsVar.apiTokken}');
  //   try {
  //     var response = await http
  //         .get(uri, headers: {HttpHeaders.cookieHeader: guestCustomerId!});
  //     switch (response.statusCode) {
  //       case 200:
  //         var result = jsonDecode(response.body);
  //         List<dynamic> products = result;
  //
  //         Map<String, dynamic> map = Map<String, dynamic>.from(products[0]);
  //         print(map);
  //         return result;
  //       case 400:
  //         ConstantsVar.showSnackbar(context, 'Bad request', 5);
  //         break;
  //       case 401:
  //         ConstantsVar.showSnackbar(context, 'Unauthorized access', 5);
  //         break;
  //       default:
  //         ConstantsVar.showSnackbar(context, 'Something went wrong', 5);
  //     }
  //   } on Exception catch (e) {
  //     ConstantsVar.showSnackbar(context, e.toString(), 5);
  //   }
  // }

  static Future getCategory(BuildContext context) async {
    final uri = Uri.parse('https://www.theone.com/apis/GetCategoryPage');
    try {
      var response = await http.get(uri);
      dynamic result = jsonDecode(response.body);
      print(result);
      return result;
    } on Exception catch (e) {
      ConstantsVar.showSnackbar(context, e.toString(), 5);
    }
  }

  static Future getHomeScreenCategory() async {
    final uri = Uri.parse(BuildConfig.base_url +
        'apis/GetTopLevelCategories'
            '?apiToken=${ConstantsVar.apiTokken}');
    try {
      var response = await http.get(uri);
      switch (response.statusCode) {
        case 200:
          var result = jsonDecode(response.body);
          print(result);
          return result;
        case 400:
          return Fluttertoast.showToast(msg: 'Bad Request to the server');
        case 401:
          break;
        default:
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  static Future getProductData(String productId) async {
    final url = BuildConfig.base_url + 'apis/GetProductModelById?id=$productId';
    print(url);
    try {
      final response = await http.get(Uri.parse(url));

      print(jsonDecode(response.body));
      return jsonDecode(response.body);
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  static Future addToCart(String customerId, String productId,
      BuildContext context) async {
    final uri = Uri.parse(BuildConfig.base_url +
        'apis/AddToCart?apiToken=${ConstantsVar
            .apiTokken}&customerid=$customerId&productid=$productId&itemquantity=1');
    try {
      dynamic response = await http.post(uri);

      var result1 = jsonDecode(response.body);
      print(result1);
      AddToCartResponse resp = AddToCartResponse.fromJson(result1);
      print(resp.warning);
      if (resp.warning != null) {
        // if (Theme.of(context).platform == TargetPlatform.android) {
        showDialog(
          context: context,
          builder: (context) =>
              CustomDialogBox1(
                descriptions: '${resp.warning.first}',
                text: 'Okay',
                img: 'MyAssets/logo.png',
                reason: '',
              ),
        );
      } else {
        // Constan
        // context.read<cartCounter>()
        print('noting');
      }

      if (resp.error == null) {} else {
        showDialog(
          context: context,
          builder: (context) =>
              CustomDialogBox1(
                descriptions: '${resp.error.toString()}',
                text: 'Okay',
                img: 'MyAssets/logo.png',
                reason: '',
              ),
        );
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  static Future showCart(String customerId) async {
    //
    final uri = Uri.parse(BuildConfig.base_url +
        'customer/Cart?apiToken=${ConstantsVar
            .apiTokken}&CustomerId=$customerId');
    print(uri);
    try {
      var response = await http.get(uri);

      var result = jsonDecode(response.body);
      ConstantsVar.isCart = false;
      print(result);
      return result;
      // } else {
      //
      //     msg: 'Something went wrong',
      //   );
      // }
    } on Exception catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
      ConstantsVar.isCart = true;
    }
  }

  /// Delete cart item id */
  static Future deleteCartItem(String customerId, int itemID,
      BuildContext ctx) async {
    ctx.loaderOverlay.show(
        widget: SpinKitRipple(
          color: Colors.red,
          size: 90,
        ));
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
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        ctx.loaderOverlay.hide();
        return result;
      } else {
        ctx.loaderOverlay.hide();
        Fluttertoast.showToast(
          msg: 'Something went wrong',
        );
      }
    } on Exception catch (e) {
      ctx.loaderOverlay.hide();
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  static Stream<dynamic> cartFun(String customerId) {
    return Stream.periodic(
      Duration(minutes: 1),
    ).asyncMap((event) => showCart(customerId));
  }

  /// Apply coupon code on the cart //
  static Future<String> applyCoupon(String apiToken, String customerId,
      String coupon, RefreshController refresh) async {
    String success = '';
    final uri = Uri.parse(BuildConfig.base_url + BuildConfig.apply_coupon_url);

    final body = {
      ApiParams.PARAM_API_TOKEN: apiToken,
      ApiParams.PARAM_CUSTOMER_ID: customerId,
      ApiParams.PARAM_DISCOUNT_COUPON: coupon,
    };

    try {
      var response = await http.post(uri, body: body);
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
          Fluttertoast.showToast(msg: data[0]);
        } else {
          List<dynamic> data = map["Message"];
          print(data[0]);
          Fluttertoast.showToast(msg: data[0]);
        }
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: e.toString());
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

    try {
      var response = await http.post(uri, body: body);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        print('coupon result>>>> $result');

        Map<String, dynamic> map = json.decode(response.body);

        String data = map["Message"];
        print(data);

        success = 'true';
        Fluttertoast.showToast(msg: data);
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
    return success;
  }

  /// Adding gift card number //
  static Future<String> applyGiftCard(String apiToken, String customerId,
      String giftcard) async {
    String success = '';
    final uri = Uri.parse(BuildConfig.base_url + BuildConfig.gift_card_url);

    final body = {
      ApiParams.PARAM_API_TOKEN: apiToken,
      ApiParams.PARAM_CUSTOMER_ID: customerId,
      ApiParams.PARAM_GIFT_COUPON: giftcard,
    };

    try {
      var response = await http.post(uri, body: body);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        print('gift card result>>>> $result');

        Map<String, dynamic> map = json.decode(response.body);

        if (map['status'] == 'Failed') {
          success = 'false';
        } else {
          success = 'true';
        }

        Fluttertoast.showToast(msg: map['Message']);
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: e.toString());
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
      var response = await http.post(uri, body: body);
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

        Fluttertoast.showToast(msg: map['Message']);
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
    return success;
  }

  ///Get all addresses api
  static Future allAddresses(String apiToken, String customerId,
      BuildContext ctx) async {
    // bool apiresult = false;
    final queryParameters = {
      ApiParams.PARAM_API_TOKEN: apiToken,
      ApiParams.PARAM_CUSTOMER_ID: customerId,
    };

    final uri = Uri.https(BuildConfig.base_url_for_apis,
        BuildConfig.all_address_url, queryParameters);

    print('address url>>> $uri');
    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        // var result = jsonDecode(response.body);
        Map<String, dynamic> result = json.decode(response.body);
        // apiresult = true;
        print('addresses>>> $result');
        return result;
      } else {
        // apiresult = false;
        Fluttertoast.showToast(
          msg: 'Something went wrong',
        );
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
      ctx.loaderOverlay.hide();
    }
  }

  /// Select billing address api
  static Future selectBillingAddress(String apiToken, String customerId,
      String addressId) async {
    final queryParameters = {
      ApiParams.PARAM_API_TOKEN: apiToken,
      ApiParams.PARAM_CUSTOMER_ID: customerId,
      ApiParams.PARAM_ADDRESS_ID: addressId
    };

    final uri = Uri.https(BuildConfig.base_url_for_apis,
        BuildConfig.select_billing_address, queryParameters);

    print('select address url>>> $uri');
    try {
      var response =
      await http.get(uri, headers: {HttpHeaders.cookieHeader: customerId});
      if (response.statusCode == 200) {
        Map<String, dynamic> result = json.decode(response.body);
        print('selectbillingaddress>>> $result');
        return result;
      } else {
        Fluttertoast.showToast(
          msg: 'Something went wrong',
        );
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
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
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        Map<String, dynamic> result = json.decode(response.body);
        print('shippingaddress>>> $result');
        return result;
      } else {
        Fluttertoast.showToast(
          msg: 'Something went wrong',
        );
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  ///Select shipping address
  static Future selectShippingAddress(String apiToken, String customerid,
      String addressId) async {
    final queryParameters = {
      ApiParams.PARAM_API_TOKEN: apiToken,
      ApiParams.PARAM_CUSTOMER_ID: customerid,
      ApiParams.PARAM_ADDRESS_ID: addressId,
    };

    final uri = Uri.https(BuildConfig.base_url_for_apis,
        BuildConfig.select_shipping_address_url, queryParameters);

    print('selectshipping>>> $uri');
    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        Map<String, dynamic> result = json.decode(response.body);
        print('selectshippingaddress>>> $result');
        return result;
      } else {
        Fluttertoast.showToast(
          msg: 'Something went wrong',
        );
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
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
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        Map<String, dynamic> result = json.decode(response.body);
        print('Order Summary result>>> $result');
        return result;
      } else {
        Fluttertoast.showToast(
          msg: 'Something went wrong',
        );
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  ///Update cart url
  static Future updateCart(String customerId, String quantity, int itemId,
      BuildContext ctx) async {
    ctx.loaderOverlay.show(
        widget: SpinKitRipple(
          size: 90,
          color: Colors.red,
        ));
    final uri = Uri.parse(
        BuildConfig.base_url+'apis/UpdateCart?ShoppingCartItemIds=$itemId&Qty=$quantity&CustomerId=$customerId');
    // String success = 'false';

    try {
      var response = await http.post(uri);
      var result = jsonDecode(response.body);
      print('update cart result>>>> $result');
      ctx.loaderOverlay.hide();
      // Fluttertoast.showToast(msg: result);
    } on Exception catch (e) {
      ctx.loaderOverlay.hide();
      Fluttertoast.showToast(msg: e.toString());
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
        myUrl,
        // forceWebView: true,
      );
      await launch(
        myUrl,
        // forceSafariVC: true,
        forceWebView: true,
        enableDomStorage: true,
      );
    } else {
      Fluttertoast.showToast(msg: 'Cannot launch this $myUrl');
    }
  }

  static Future addBillingORShippingAddress(BuildContext context,
      String apiToken, String customerId, String snippingModel) async {
    final body = {
      ApiParams.PARAM_API_TOKEN: apiToken,
      ApiParams.PARAM_CUSTOMER_ID: customerId,
      ApiParams.PARAM_SHIPPING: snippingModel,
    };

    final uri =
    Uri.parse(BuildConfig.base_url + 'apis/AddSelectNewBillingAddress?');
    print(uri);
    try {
      var response = await http.post(uri, body: body);
      print(jsonDecode(response.body));
      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) =>
                  ShippingAddress(
                    // tokken: apiToken,
                    // customerId: customerId,
                  )));
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  static Future addAndSelectShippingAddress(String apiToken, String customerId,
      String id2) async {
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
      var resp = await http.post(uri, body: body);
      print(jsonDecode(resp.body));
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

// static addandselectShippingAddress(String s, id, String id2) {}

// For BadgeCounter
  static Future readCounter({required String customerGuid}) async {
    final uri = Uri.parse(
        'https://www.theone.com/apis/CartCount?cutomerGuid=$customerGuid');
    try {
      var response = await http.get(uri);
      dynamic result = jsonDecode(response.body);
      print(response.body);
      if (result['ResponseData'] != null &&
          result['status'].contains('success')){

        return result['ResponseData'];
      }else{
        return 0;
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
