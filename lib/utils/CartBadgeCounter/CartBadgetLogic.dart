import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/AppPages/AppWishlist/WishlistResponse.dart';

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

  void getSearchCategory() async {
    _isVisible = true;
    final uri = Uri.parse(BuildConfig.base_url + 'apis/GetCategoryPage');
    _isVisible = true;
    _searchCategoryList = await ApiCalls.getSearchCategory();
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


}
