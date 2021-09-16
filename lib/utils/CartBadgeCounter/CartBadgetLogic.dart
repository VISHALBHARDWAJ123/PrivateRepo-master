import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/AppPages/CartxxScreen/ConstantVariables.dart';
import 'package:untitled2/AppPages/MyOrders/Response/OrderResponse.dart';
import 'package:untitled2/utils/utils/build_config.dart';

class cartCounter extends ChangeNotifier with DiagnosticableTreeMixin {
  int _bagdgeNumber = 0;

  int get badgeNumber => _bagdgeNumber;

  Customerorders? respone;

  Customerorders? get resp => respone;

  Future getOrder(String apiToken, String customerId) async {
    final uri = Uri.parse(BuildConfig.base_url +
        'apis/GetCustomerOrderList?apiToken=$apiToken&customerid=$customerId');
    var response = await get(uri);
    try {
      var result = jsonDecode(response.body);
      respone = Customerorders.fromJson(result);
      notifyListeners();
      // print(myOrders);

    } on Exception catch (e) {
      print(e.toString);
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  void changeCounter(int cartCounter) {
    _bagdgeNumber = 0;
    _bagdgeNumber = _bagdgeNumber + cartCounter;
    notifyListeners();
  }
}
