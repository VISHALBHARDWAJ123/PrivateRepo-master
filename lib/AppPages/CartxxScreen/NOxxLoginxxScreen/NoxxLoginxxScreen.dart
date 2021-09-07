import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/LoginScreen/LoginScreen.dart';

import '../ConstantVariables.dart';

class CartLoginNotice extends StatefulWidget {
  const CartLoginNotice({Key? key}) : super(key: key);

  @override
  _CartLoginNoticeState createState() => _CartLoginNoticeState();
}

class _CartLoginNoticeState extends State<CartLoginNotice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
          leading: InkWell(
            onTap: () => Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(builder: (context) => MyHomePage()),
                (route) => false),
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          toolbarHeight: 18.w,
          backgroundColor: ConstantsVar.appColor,
          centerTitle: true,
          title: InkWell(
            onTap: () => Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(builder: (context) => MyHomePage()),
                (route) => false),
            child: Image.asset(
              'MyAssets/logo.png',
              width: 15.w,
              height: 15.w,
            ),
          )),
      body: Container(
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     colors: [
        //       ConstantsVar.appColor.withOpacity(.8),
        //       Colors.white60,
        //     ],
        //     begin: Alignment(.5, -1),
        //     end: Alignment(-1, .5),
        //   ),
        // ),
        child: Center(
          child: Container(
            width: 100.w,
            height: 50.w,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'MyAssets/logo.png',
                    width: 35.w,
                    height: 35.w,
                  ),
                ),
                RichText(
                  text: TextSpan(
                      text: 'Not Login!',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      children: <TextSpan>[
                        TextSpan(
                            text: ' Sign In/ Sign Up',
                            style: TextStyle(
                                color: Colors.blueAccent, fontSize: 18),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) => LoginScreen()));
                              })
                      ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
