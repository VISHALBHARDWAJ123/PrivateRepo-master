import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/AppPages/CartxxScreen/ConstantVariables.dart';
import 'package:untitled2/AppPages/ChangePassword/ChangePassword.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/LoginScreen/LoginScreen.dart';
import 'package:untitled2/AppPages/MyAddresses/MyAddresses.dart';
import 'package:untitled2/AppPages/MyOrders/MyOrders.dart';
import 'package:untitled2/AppPages/Registration/RegistrationPage.dart';
import 'package:untitled2/utils/HeartIcon.dart';

class MyAccount extends StatelessWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      child: Scaffold(
        appBar: new AppBar(
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
                      child: Text(
                        'my account'.toUpperCase(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 8.5.w,
                          fontWeight: FontWeight.bold,
                        ),
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
                                              'MyAssets/imagebackground.png',
                                            ))),
                                    height: 40.h,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Text(
                                          'You are not logged in with THE One Account.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 5.w,
                                              color: Colors.white),
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
                                                  child: Text(
                                                    'Login',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              onTap: () => Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                  builder: (context) =>
                                                      LoginScreen(),
                                                ),
                                              ),
                                            ),
                                            AppButton(
                                              color: Colors.black,
                                              child: Container(
                                                width: 30.w,
                                                child: Center(
                                                  child: Text(
                                                    'Register',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              onTap: () => Navigator.push(
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

                              Navigator.push(context,CupertinoPageRoute(builder: (context) =>MyAddresses()));

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
                                    child: Text(
                                      'my Addresses'.toUpperCase(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 5.w,
                                        fontWeight: FontWeight.bold,
                                      ),
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
                                              'MyAssets/imagebackground.png',
                                            ))),
                                    height: 40.h,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Text(
                                          'You are not logged in with THE One Account.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 5.w,
                                              color: Colors.white),
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
                                                  child: Text(
                                                    'Login',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              onTap: () => Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                  builder: (context) =>
                                                      LoginScreen(),
                                                ),
                                              ),
                                            ),
                                            AppButton(
                                              color: Colors.black,
                                              child: Container(
                                                width: 30.w,
                                                child: Center(
                                                  child: Text(
                                                    'Register',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              onTap: () => Navigator.push(
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
                                    builder: (context) => MyOrders(),
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
                                    child: Text(
                                      'my orders'.toUpperCase(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 5.w,
                                        fontWeight: FontWeight.bold,
                                      ),
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
                                              'MyAssets/imagebackground.png',
                                            ))),
                                    height: 40.h,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Text(
                                          'You are not logged in with THE One Account.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 5.w,
                                              color: Colors.white),
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
                                                  child: Text(
                                                    'Login',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              onTap: () => Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                  builder: (context) =>
                                                      LoginScreen(),
                                                ),
                                              ),
                                            ),
                                            AppButton(
                                              color: Colors.black,
                                              child: Container(
                                                width: 30.w,
                                                child: Center(
                                                  child: Text(
                                                    'Register',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              onTap: () => Navigator.push(
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
                                    child: Text(
                                      'change password'.toUpperCase(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 5.w,
                                        fontWeight: FontWeight.bold,
                                      ),
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
            )),
      ),
    );
  }
}
