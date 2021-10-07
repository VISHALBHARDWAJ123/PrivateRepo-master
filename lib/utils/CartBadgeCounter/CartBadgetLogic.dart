import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

// import 'package:untitled2/AppPages/CartxxScreen/ConstantVariables.dart';
import 'package:untitled2/AppPages/MyOrders/Response/OrderResponse.dart';
import 'package:untitled2/utils/utils/build_config.dart';

class cartCounter extends ChangeNotifier with DiagnosticableTreeMixin {
  int _bagdgeNumber = 0;
  String _productID = '';
  String _categoryId = '';
  String _title = '';

  int get badgeNumber => _bagdgeNumber;

  String get productID => _productID;

  String get categoryID => _categoryId;

  String get title => _title;

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
}
