import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/AppPages/CartxxScreen/ConstantVariables.dart';

class cartCounter extends ChangeNotifier with DiagnosticableTreeMixin {
  int _bagdgeNumber = 0;

  int get badgeNumber => _bagdgeNumber;

  void changeCounter(int cartCounter) {
    _bagdgeNumber = 0;
    _bagdgeNumber = _bagdgeNumber + cartCounter;
    notifyListeners();
  }
}
