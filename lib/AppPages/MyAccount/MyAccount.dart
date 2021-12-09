import 'package:auto_size_text/auto_size_text.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;

// import 'package:untitled2/AppPages/CartxxScreen/ConstantVariables.dart';
import 'package:untitled2/AppPages/ChangePassword/ChangePassword.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/LoginScreen/LoginScreen.dart';
import 'package:untitled2/AppPages/MyAddresses/MyAddresses.dart';
import 'package:untitled2/AppPages/MyOrders/MyOrders.dart';
import 'package:untitled2/AppPages/Registration/RegistrationPage.dart';
import 'package:untitled2/AppPages/ReturnScreen/OrderReturnStatus/OrderReturnScreen.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/utils/HeartIcon.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  bool _willPop = true;

  @override
  Widget build(BuildContext context) {
    Future<bool> _willgoBack() async {
      Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(
            builder: (context) => MyHomePage(
              pageIndex: 4,
            ),
          ),
          (route) => false);
      setState(() {
        _willPop = true;
      });
      return _willPop;
    }

    return WillPopScope(
      onWillPop: _willPop ? _willgoBack : () async => false,
      child: SafeArea(
        top: true,
        bottom: true,
        maintainBottomViewPadding: true,
        child: Scaffold(
          appBar: new AppBar(
              leading: Platform.isAndroid
                  ? InkWell(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => MyHomePage(
                                pageIndex: 4,
                              ),
                            ),
                            (route) => false);
                      },
                      child: Icon(Icons.arrow_back))
                  : InkWell(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => MyHomePage(
                                pageIndex: 4,
                              ),
                            ),
                            (route) => false);
                      },
                      child: Icon(Icons.arrow_back_ios)),
              backgroundColor: ConstantsVar.appColor,
              centerTitle: true,
              toolbarHeight: 18.w,
              title: InkWell(
                onTap: () {
                  Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(
                    builder: (context) {
                      return MyApp();
                    },
                  ), (route) => false);
                },
                child: Image.asset(
                  'MyAssets/logo.png',
                  width: 15.w,
                  height: 15.w,
                ),
              )),
          body: Container(
            width: 100.w,
            height: 100.h,
            child: Column(
              children: [
                Container(
                  width: 100.w,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: AutoSizeText(
                        'my account'.toUpperCase(),
                        style: TextStyle(shadows: <Shadow>[
                          Shadow(
                            offset: Offset(1.0, 1.2),
                            blurRadius: 3.0,
                            color: Colors.grey.shade300,
                          ),
                          Shadow(
                            offset: Offset(1.0, 1.2),
                            blurRadius: 8.0,
                            color: Colors.grey.shade300,
                          ),
                        ], fontSize: 5.w, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      DelayedDisplay(
                        delay: Duration(
                          milliseconds: 70,
                        ),
                        child: InkWell(
                          onTap: () async {
                            ConstantsVar.prefs =
                                await SharedPreferences.getInstance();
                            var customerId =
                                ConstantsVar.prefs.getString('userId');

                            if (customerId == null || customerId == '') {
                              showModalBottomSheet<void>(
                                // context and builder are
                                // required properties in this widget
                                context: context,
                                builder: (BuildContext context) {
                                  // we set up a container inside which
                                  // we create center column and display text
                                  return Container(
                                    width: 100.w,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                              'MyAssets/banner.jpg',
                                            ))),
                                    height: 40.h,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: AutoSizeText(
                                            'You are not logged in with THE One account.',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(shadows: <Shadow>[
                                              Shadow(
                                                offset: Offset(1.0, 1.2),
                                                blurRadius: 3.0,
                                                color: Colors.grey.shade300,
                                              ),
                                              Shadow(
                                                offset: Offset(1.0, 1.2),
                                                blurRadius: 8.0,
                                                color: Colors.grey.shade300,
                                              ),
                                            ], fontSize: 5.w, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            AppButton(
                                              color: Colors.black,
                                              child: Container(
                                                width: 30.w,
                                                child: Center(
                                                  child: AutoSizeText(
                                                    'Login',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              onTap: () =>
                                                  Navigator.pushReplacement(
                                                context,
                                                CupertinoPageRoute(
                                                  builder: (context) =>
                                                      LoginScreen(
                                                    screenKey: 'My Account',
                                                  ),
                                                ),
                                              ),
                                            ),
                                            AppButton(
                                              color: Colors.black,
                                              child: Container(
                                                width: 30.w,
                                                child: Center(
                                                  child: AutoSizeText(
                                                    'Register',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              onTap: () =>
                                                  Navigator.pushReplacement(
                                                context,
                                                CupertinoPageRoute(
                                                  builder: (context) =>
                                                      RegstrationPage(),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            } else {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => MyAddresses()));

                              // Fluttertoast.showToast(msg: 'In Progress');
                            }
                          },
                          // Navigator.push(
                          //     context,
                          //     CupertinoPageRoute(
                          //         builder: (context) => CartScreen2())),
                          child: Card(
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 6.w,
                                horizontal: 8.w,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Card(
                                    child: Icon(
                                      HeartIcon.address,
                                      color: ConstantsVar.appColor,
                                      size: 34,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Container(
                                    // color: Colors.white,
                                    child: AutoSizeText(
                                      'my Addresses'.toUpperCase(),
                                      style: TextStyle(shadows: <Shadow>[
                                        Shadow(
                                          offset: Offset(1.0, 1.2),
                                          blurRadius: 3.0,
                                          color: Colors.grey.shade300,
                                        ),
                                        Shadow(
                                          offset: Offset(1.0, 1.2),
                                          blurRadius: 8.0,
                                          color: Colors.grey.shade300,
                                        ),
                                      ], fontSize: 5.w, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      DelayedDisplay(
                        delay: Duration(
                          milliseconds: 70,
                        ),
                        child: InkWell(
                          onTap: () async {
                            ConstantsVar.prefs =
                                await SharedPreferences.getInstance();
                            var customerId =
                                ConstantsVar.prefs.getString('userId');

                            if (customerId == null || customerId == '') {
                              showModalBottomSheet<void>(
                                // context and builder are
                                // required properties in this widget
                                context: context,
                                builder: (BuildContext context) {
                                  // we set up a container inside which
                                  // we create center column and display text
                                  return Container(
                                    width: 100.w,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                              'MyAssets/banner.jpg',
                                            ))),
                                    height: 40.h,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        AutoSizeText(
                                          'You are not logged in with THE One account.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(shadows: <Shadow>[
                                            Shadow(
                                              offset: Offset(1.0, 1.2),
                                              blurRadius: 3.0,
                                              color: Colors.grey.shade300,
                                            ),
                                            Shadow(
                                              offset: Offset(1.0, 1.2),
                                              blurRadius: 8.0,
                                              color: Colors.grey.shade300,
                                            ),
                                          ], fontSize: 5.w, fontWeight: FontWeight.bold),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            AppButton(
                                              color: Colors.black,
                                              child: Container(
                                                width: 30.w,
                                                child: Center(
                                                  child: AutoSizeText(
                                                    'Login',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              onTap: () =>
                                                  Navigator.pushReplacement(
                                                context,
                                                CupertinoPageRoute(
                                                  builder: (context) =>
                                                      LoginScreen(
                                                    screenKey: 'My Account',
                                                  ),
                                                ),
                                              ),
                                            ),
                                            AppButton(
                                              color: Colors.black,
                                              child: Container(
                                                width: 30.w,
                                                child: Center(
                                                  child: AutoSizeText(
                                                    'Register',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              onTap: () =>
                                                  Navigator.pushReplacement(
                                                context,
                                                CupertinoPageRoute(
                                                  builder: (context) =>
                                                      RegstrationPage(),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            } else {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => MyOrders(
                                      isFromWeb: false,
                                    ),
                                  ));
                            }
                          },
                          child: Card(
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 6.w,
                                horizontal: 8.w,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Card(
                                    child: Icon(
                                      HeartIcon.order,
                                      color: ConstantsVar.appColor,
                                      size: 34,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Container(
                                    // color: Colors.white,
                                    child: AutoSizeText(
                                      'my orders'.toUpperCase(),
                                      style: TextStyle(shadows: <Shadow>[
                                        Shadow(
                                          offset: Offset(1.0, 1.2),
                                          blurRadius: 3.0,
                                          color: Colors.grey.shade300,
                                        ),
                                        Shadow(
                                          offset: Offset(1.0, 1.2),
                                          blurRadius: 8.0,
                                          color: Colors.grey.shade300,
                                        ),
                                      ], fontSize: 5.w, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      DelayedDisplay(
                        delay: Duration(
                          milliseconds: 70,
                        ),
                        child: InkWell(
                          // Fluttertoast.showToast(msg:'In Progress'),

                          onTap: () async {
                            ConstantsVar.prefs =
                                await SharedPreferences.getInstance();
                            var customerId =
                                ConstantsVar.prefs.getString('userId');

                            if (customerId == null || customerId == '') {
                              showModalBottomSheet<void>(
                                // context and builder are
                                // required properties in this widget
                                context: context,
                                builder: (BuildContext context) {
                                  // we set up a container inside which
                                  // we create center column and display text
                                  return Container(
                                    width: 100.w,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                              'MyAssets/banner.jpg',
                                            ))),
                                    height: 40.h,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        AutoSizeText(
                                          'You are not logged in with THE One account.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(shadows: <Shadow>[
                                            Shadow(
                                              offset: Offset(1.0, 1.2),
                                              blurRadius: 3.0,
                                              color: Colors.grey.shade300,
                                            ),
                                            Shadow(
                                              offset: Offset(1.0, 1.2),
                                              blurRadius: 8.0,
                                              color: Colors.grey.shade300,
                                            ),
                                          ], fontSize: 5.w, fontWeight: FontWeight.bold),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            AppButton(
                                              color: Colors.black,
                                              child: Container(
                                                width: 30.w,
                                                child: Center(
                                                  child: AutoSizeText(
                                                    'Login',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              onTap: () =>
                                                  Navigator.pushReplacement(
                                                context,
                                                CupertinoPageRoute(
                                                  builder: (context) =>
                                                      LoginScreen(
                                                    screenKey: 'My Account',
                                                  ),
                                                ),
                                              ),
                                            ),
                                            AppButton(
                                              color: Colors.black,
                                              child: Container(
                                                width: 30.w,
                                                child: Center(
                                                  child: AutoSizeText(
                                                    'Register',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              onTap: () =>
                                                  Navigator.pushReplacement(
                                                context,
                                                CupertinoPageRoute(
                                                  builder: (context) =>
                                                      RegstrationPage(),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            } else {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => ChangePassword(),
                                  ));
                            }
                          },
                          child: Card(
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 6.w,
                                horizontal: 8.w,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Card(
                                    child: Icon(
                                      Icons.password,
                                      color: ConstantsVar.appColor,
                                      size: 34,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Container(
                                    // color: Colors.white,
                                    child: AutoSizeText(
                                      'change password'.toUpperCase(),
                                      style: TextStyle(shadows: <Shadow>[
                                        Shadow(
                                          offset: Offset(1.0, 1.2),
                                          blurRadius: 3.0,
                                          color: Colors.grey.shade300,
                                        ),
                                        Shadow(
                                          offset: Offset(1.0, 1.2),
                                          blurRadius: 8.0,
                                          color: Colors.grey.shade300,
                                        ),
                                      ], fontSize: 5.w, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      DelayedDisplay(
                        delay: Duration(
                          milliseconds: 70,
                        ),
                        child: InkWell(
                          // Fluttertoast.showToast(msg:'In Progress'),

                          onTap: () async {
                            ConstantsVar.prefs =
                                await SharedPreferences.getInstance();
                            var customerId =
                                ConstantsVar.prefs.getString('userId');

                            if (customerId == null || customerId == '') {
                              showModalBottomSheet<void>(
                                // context and builder are
                                // required properties in this widget
                                context: context,
                                builder: (BuildContext context) {
                                  // we set up a container inside which
                                  // we create center column and display text
                                  return Container(
                                    width: 100.w,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                              'MyAssets/banner.jpg',
                                            ))),
                                    height: 40.h,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        AutoSizeText(
                                          'You are not logged in with THE One account.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(shadows: <Shadow>[
                                            Shadow(
                                              offset: Offset(1.0, 1.2),
                                              blurRadius: 3.0,
                                              color: Colors.grey.shade300,
                                            ),
                                            Shadow(
                                              offset: Offset(1.0, 1.2),
                                              blurRadius: 8.0,
                                              color: Colors.grey.shade300,
                                            ),
                                          ], fontSize: 5.w, fontWeight: FontWeight.bold),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            AppButton(
                                              color: Colors.black,
                                              child: Container(
                                                width: 30.w,
                                                child: Center(
                                                  child: AutoSizeText(
                                                    'Login',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              onTap: () =>
                                                  Navigator.pushReplacement(
                                                context,
                                                CupertinoPageRoute(
                                                  builder: (context) =>
                                                      LoginScreen(
                                                    screenKey: 'My Account',
                                                  ),
                                                ),
                                              ),
                                            ),
                                            AppButton(
                                              color: Colors.black,
                                              child: Container(
                                                width: 30.w,
                                                child: Center(
                                                  child: AutoSizeText(
                                                    'Register',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              onTap: () =>
                                                  Navigator.pushReplacement(
                                                context,
                                                CupertinoPageRoute(
                                                  builder: (context) =>
                                                      RegstrationPage(),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            } else {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) =>
                                      OrderReturnDetailScreen(),
                                ),
                              );
                            }
                          },
                          child: Card(
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 6.w,
                                horizontal: 8.w,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Card(
                                    child: Icon(
                                      HeartIcon.order,
                                      color: ConstantsVar.appColor,
                                      size: 34,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Container(
                                    // color: Colors.white,
                                    child: AutoSizeText(
                                      'Return Request(s)'.toUpperCase(),
                                      style: TextStyle(shadows: <Shadow>[
                                        Shadow(
                                          offset: Offset(1.0, 1.2),
                                          blurRadius: 3.0,
                                          color: Colors.grey.shade300,
                                        ),
                                        Shadow(
                                          offset: Offset(1.0, 1.2),
                                          blurRadius: 8.0,
                                          color: Colors.grey.shade300,
                                        ),
                                      ], fontSize: 5.w, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
