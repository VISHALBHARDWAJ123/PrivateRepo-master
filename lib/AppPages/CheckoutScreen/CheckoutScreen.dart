import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/utils/HeartIcon.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool isVal = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        body: Container(
          width: 100.w,
          height: 100.h,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                height: 8.h,
                color: ConstantsVar.appColor,
                width: 100.w,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 7.w,
                          color: Colors.white,
                        ),
                      ),
                      Align(
                        alignment: Alignment(0, 0),
                        child: Image.asset(
                          'MyAssets/logo.png',
                          width: 15.w,
                          height: 6.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Align(
                        alignment: Alignment(1, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              HeartIcon.user,
                              size: 7.w,
                              color: Colors.white,
                            ),
                            Icon(
                              Icons.shopping_bag_rounded,
                              size: 7.w,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: 100.w,
                height: 10.h,
                child: Align(
                  alignment: Alignment(0, 0),
                  child: Padding(
                    padding: EdgeInsets.all(1.9.w),
                    child: Text(
                      'checkout'.toUpperCase(),
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w900,
                        fontSize: 30.dp,
                      ),
                    ),
                  ),
                ),
              ),
              Divider(
                height: 2,
                thickness: 2,
              ),
              Container(
                width: 100.w,
                height: 55.h,
                color: Color(0xFFEEEEEE),
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Payment Mode'.toUpperCase(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 26.dp,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            'Payment',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 26.dp,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Shipping'.toUpperCase(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 26.dp,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            'AED incl VAL',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 26.dp,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Payment'.toUpperCase(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 26.dp,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            'Payment',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 26.dp,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 2,
                thickness: 2,
              ),
              Container(
                width: 100.w,
                color: Colors.white,
                height: 19.h,
                child: Padding(
                  padding: EdgeInsets.all(2.8.h),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Checkbox(
                        value: isVal,
                        onChanged: (val) {
                          setState(
                            () {
                              isVal = val!;
                            },
                          );
                        },
                      ),
                      Flexible(
                        child: Align(
                          alignment: Alignment(0, 0),
                          child: AutoSizeText(
                            'I agree with the terms of the sevices and I adhere to them unconditionally(read)',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18.dp),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0, -1),
                child: Container(
                  width: 100.w,
                  color: Color(0xFFEEEEEE),
                  height: 7.5.h,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        color: Colors.blue,
                        width: 50.w,
                        child: Align(
                          alignment: Alignment(0, 0),
                          child: Align(
                            alignment: Alignment(0, 0),
                            child: Padding(
                              padding: EdgeInsets.all(1.5.w),
                              child: Text(
                                'cancel'.toUpperCase(),
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 22.dp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.redAccent,
                        width: 50.w,
                        child: Align(
                          alignment: Alignment(0, 0),
                          child: Align(
                            alignment: Alignment(0, 0),
                            child: Padding(
                              padding: EdgeInsets.all(1.5.w),
                              child: Text(
                                'place order'.toUpperCase(),
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 22.dp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
