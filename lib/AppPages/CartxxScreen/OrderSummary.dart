// import 'package:connectivity/connectivity.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';

class OrderSummary extends StatefulWidget {
  _OrderSummaryState createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {
  bool connectionStatus = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //This customer id we have already in splash screen. No need to intialise
    //prefrences here

    ConstantsVar.subscription = ConstantsVar.connectivity.onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        ConstantsVar.showSnackbar(context, ' Internet connection found.', 5);
        setState(() {
          connectionStatus = true;
        });
      } else {
        ConstantsVar.showSnackbar(context,
            'No Internet connection found. Please check your connection', 5);
        setState(() {
          connectionStatus = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (connectionStatus == true) {
      return Container();
    } else {
      return Scaffold();
    }
  }
}
