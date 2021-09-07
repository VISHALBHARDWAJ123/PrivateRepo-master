//import 'dart:html';

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/SplashScreen/GuestxxResponsexx/GuestResponsexx.dart';
import 'package:untitled2/AppPages/SplashScreen/TokenResponse/TokenxxResponsexx.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';

import '../LoginScreen/LoginScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String name = "MyAssets/logo.png";
  var _guestCustomerID;
  var _guestGUID;

  Future initilaize() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initilaize().then((value) {
      _guestCustomerID = ConstantsVar.prefs.getString('guestCustomerID');
      print('init');
      print('$_guestCustomerID');
      if (_guestCustomerID == null || _guestCustomerID == '') {
        print('guestCustomerID is null');
        ApiCalls.getApiTokken(context).then((value) {
          TokenResponse myResponse = TokenResponse.fromJson(value);
          _guestCustomerID = myResponse.cutomer.customerId;
          _guestGUID = myResponse.cutomer.customerGuid;
          ConstantsVar.prefs.setString('guestCustomerID', '$_guestCustomerID');
          ConstantsVar.prefs.setString('guestGUID', _guestGUID);
          Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                builder: (context) => MyApp(),
              ));
        }
            // },
            );
      } else {
        Future.delayed(
            Duration(seconds: 2),
            () => Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                  builder: (context) => MyApp(),
                )));
      }
    });

    // // } else {
    // }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: FlutterSizer(
        builder: (context, orientation, screenType) {
          return Scaffold(
            body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: EdgeInsets.all(0.5.h),
                    alignment: Alignment.topCenter,
                    child: Image.asset(name),
                  ),
                  SpinKitCircle(
                    itemBuilder: (context, index) {
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future getCustomerId() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
    if (ConstantsVar.prefs.getString('userId') != null) {
      ConstantsVar.customerID = ConstantsVar.prefs.getString('userId')!;
    }

    return ConstantsVar.customerID;
  }

  checkCreds() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
    var email = ConstantsVar.prefs.getString('email');
    var passWord = ConstantsVar.prefs.getString('passWord');
    print('Email : $email\nPassword :$passWord ');
    email == null && passWord == null
        ? Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return LoginScreen();
              },
            ),
          )
        : Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return MyApp();
              },
            ),
          );
  }

  Future getGuestCustomer() async {
    Fluttertoast.showToast(msg: 'Guest Customer');
    final guestUri = Uri.parse('http://www.theone.com/apis/AddGuestCustomer');
    try {
      var response = await http.get(guestUri);

      GuestCustomerResponse result =
          GuestCustomerResponse.fromJson(jsonDecode(response.body));

      _guestCustomerID = result.responseData.customerId.toString();
      var guestGuId = result.responseData.customerGuid;
      print(_guestCustomerID);
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }



}
