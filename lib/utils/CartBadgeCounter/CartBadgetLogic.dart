import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/AppPages/AppWishlist/ShareResponse.dart';
import 'package:untitled2/AppPages/AppWishlist/WishlistResponse.dart';
import 'package:untitled2/AppPages/CustomLoader/CustomDialog/CustomDialog.dart';

// import 'package:untitled2/AppPages/CartxxScreen/ConstantVariables.dart';
import 'package:untitled2/AppPages/MyOrders/Response/OrderResponse.dart';
import 'package:untitled2/AppPages/SearchPage/SearchCategoryResponse/SearchCategoryResponse.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';
import 'package:untitled2/utils/utils/build_config.dart';

class cartCounter extends ChangeNotifier with DiagnosticableTreeMixin {
  int _bagdgeNumber = 0;
  String _productID = '';
  String _categoryId = '';
  String _title = '';
  List<ResponseDatum> _searchCategoryList = [];
  List<WishlistItem> _wishlistItems = [];
  bool _isVisible = true;
  SharedResposnse? _shareWishlist;

  SharedResposnse get shareWishlist => _shareWishlist!;

  int get badgeNumber => _bagdgeNumber;

  List<WishlistItem> get wishlistItems => _wishlistItems;

  String get productID => _productID;

  String get categoryID => _categoryId;

  String get title => _title;

  bool get isVisible => _isVisible;

  List<ResponseDatum> get searchCategoryList => _searchCategoryList;

  void changeCounter(int cartCounter) {
    _bagdgeNumber = 0;
    _bagdgeNumber = _bagdgeNumber + cartCounter;
    notifyListeners();
  }

  void getProductID(String productID) {
    _productID = productID;
    notifyListeners();
  }

  void getCategoryID(String categoryID) {
    _categoryId = categoryID;
    notifyListeners();
  }

  void getTitle(String title) {
    _title = title;
    notifyListeners();
  }

  void getSearchCategory({required String customerId}) async {
    print('Search Screen CustomerId for categories:- $customerId');
    _isVisible = true;
    final uri = Uri.parse(BuildConfig.base_url + 'apis/GetCategoryPage');
    _isVisible = true;
    _searchCategoryList = await ApiCalls.getSearchCategory(customerId: '');
    _isVisible = false;
    notifyListeners();
  }

  void getWishlist(
      {required String apiToken, required String customerId}) async {
    _isVisible = true;
    _wishlistItems =
        await ApiCalls.getWishlist(apiToken: apiToken, customerId: customerId);
    _isVisible = false;
    notifyListeners();
  }

  void shareMyWishlist(
      {required String apiToken,
      required String customerId,
      required String message,
      required String customerEmail,
      required String friendEmail,
      required BuildContext ctx}) async {
    CustomProgressDialog _progressDialog = CustomProgressDialog(
      ctx,
      loadingWidget: SpinKitRipple(
        color: Colors.red,
        size: 30,
      ),
    );
    _progressDialog.show();
    var response = await ApiCalls.shareWishlist(
        customerEmail: customerEmail,
        friendEmail: friendEmail,
        apiToken: apiToken,
        customerId: customerId,
        message: message);
    print(response);
    if (response.toString() == 'Nothing Here') {
      Fluttertoast.showToast(
        msg: 'Something Went Wrong. Please try again!',
        toastLength: Toast.LENGTH_LONG,
      );
      _progressDialog.dismiss();
    } else {
      jsonDecode(response)['status'].toString() != 'Failed'
          ? okay(ctx: ctx)
          : showDialog(
              context: ctx,
              builder: (ctx) => CustomDialogBox(
                descriptions: 'Sharing Failed!\n' +
                    jsonDecode(response)['Message'].toString(),
                text: 'Not Go',
                img: 'MyAssets/logo.png',
                isOkay: false,
              ),
            );

      _progressDialog.dismiss();
    }
    notifyListeners();
  }

  void deleteWishlist(
      {required String apiToken,
      required String customerId,
      required BuildContext ctx}) async {
    CustomProgressDialog _progressDialog = CustomProgressDialog(
      ctx,
      loadingWidget: SpinKitRipple(
        color: Colors.red,
        size: 30,
      ),
    );
    _progressDialog.show();
    var response = await ApiCalls.deleteWishlist(
      apiToken: apiToken,
      customerId: customerId,
    );
    print(response);
    if (response.toString() == 'Nothing Here') {
      Fluttertoast.showToast(
        msg: 'Something Went Wrong. Please try again!',
        toastLength: Toast.LENGTH_LONG,
      );
      _progressDialog.dismiss();
    } else {
      jsonDecode(response)['status'].toString() != 'Failed'
          ? _resetWishlist(apiToken: apiToken, customerId: customerId)
          : showDialog(
              context: ctx,
              builder: (ctx) => CustomDialogBox(
                descriptions: 'Can\'t delete Wishlist!\n' +
                    jsonDecode(response)['Message'].toString(),
                text: 'Not Go',
                img: 'MyAssets/logo.png',
                isOkay: false,
              ),
            );

      _progressDialog.dismiss();
    }
    notifyListeners();
  }

  _resetWishlist({required String customerId, required String apiToken}) {
    Fluttertoast.showToast(
        msg: 'Wishlist Deleted', toastLength: Toast.LENGTH_LONG);
    getWishlist(customerId: customerId, apiToken: apiToken);
  }

 void okay({required BuildContext ctx}) {
   Fluttertoast.showToast(msg: 'Wishlist Shared!');
   Navigator.pop(ctx);
 }
}
