import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/AppPages/CartxxScreen/ConstantVariables.dart';

class cartCounter extends ChangeNotifier with DiagnosticableTreeMixin{
  int bagdgeNumber=0;
  int get badgeNumber=>badgeNumber;

   void changeCounter(){
     bagdgeNumber++;

    ConstantsVar.prefs.setInt('badgeNumber', badgeNumber);
     notifyListeners();
   }
   void clearCounter(){
     ConstantsVar.prefs.setInt('badgeNumber',0);
     notifyListeners();
   }
}