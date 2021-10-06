import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:untitled2/utils/HeartIcon.dart';

class ConstantsVar {
  static String baseUri = 'https://www.theone.com/apis/';

  static double width = MediaQueryData
      .fromWindow(window)
      .size
      .width;
  static double height = MediaQueryData
      .fromWindow(window)
      .size
      .height;
  static String customerID = prefs.getString('guestCustomerID')!;
  static bool isCart = true;
  static late SharedPreferences prefs;
  static bool isVisible = false;

  static Connectivity connectivity = Connectivity();
  static late StreamSubscription<ConnectivityResult> subscription;

  static String orderSummaryResponse = '';

  static int selectedIndex = 0;

  static String stringShipping =
      'Pick up your items at the store or our Local Warehouse. Our Customer Service will confirm your pick up date as soon as possible.';

  static showSnackbar(BuildContext context, String value, int time) {
    final _scaffold = ScaffoldMessenger.of(context);
    final _snackbarContent = SnackBar(
      content: Text(value),
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: time),
    );
    _scaffold.showSnackBar(_snackbarContent);
  }

  static late int productID;

  static String? apiTokken = prefs.getString('apiTokken');

  static const Color appColor = Color.fromARGB(255, 164, 0, 0);

  // static const String OtpCode = '1234';

  static double textSize = width * .06;
  static double textFieldSize = width * .05;

  static List<BottomNavigationBarItem> btmItem = [
    BottomNavigationBarItem(
        icon: InkWell(
          onTap: () async {},
          child: Icon(
            Icons.notifications,
            color: appColor,
          ),
        ),
        label: ''),
    BottomNavigationBarItem(
        icon: InkWell(
          onTap: () async {},
          child: Icon(
            HeartIcon.heart,
            color: appColor,
          ),
        ),
        label: ''),
    BottomNavigationBarItem(
        icon: InkWell(
          onTap: () async {},
          child: Icon(
            HeartIcon.user,
            color: appColor,
          ),
        ),
        label: ''),
    BottomNavigationBarItem(
        icon: InkWell(
          onTap: () async {},
          child: Icon(
            HeartIcon.logout,
            color: appColor,
          ),
        ),
        label: ''),
  ];

  static const String pass_Pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  static const String email_Pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  static Future checkValidation(String email, String pass,
      BuildContext context) async {
    if (RegExp(pass_Pattern).hasMatch(pass) &&
        RegExp(email_Pattern).hasMatch(email)) {
      showSnackbar(context, 'Pattern Matches', 4);
    } else {
      showSnackbar(context, 'Pattern Missmatches', 4);
      isVisible = false;
    }
  }

  static String stripHtmlIfNeeded(String text) {
    return text.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '');
  }

  static void excecptionMessage(Exception e) {
    if (e is FormatException) {
      Fluttertoast.showToast(msg: 'Url mismatch.');
    } else if (e is SocketException) {
      Fluttertoast.showToast(msg: 'Please check your internet.');
    } else if (e is TimeoutException) {
      Fluttertoast.showToast(msg: 'Timeout.');
    } else if (e is NoSuchMethodError) {
      Fluttertoast.showToast(msg: 'Data does\'nt exist.');
    } else if (e is DeferredLoadException) {
      Fluttertoast.showToast(msg: 'Failed to load library.');
    } else if (e is IntegerDivisionByZeroException) {
      Fluttertoast.showToast(msg: 'Number can\'t be divided by Zero.');
    }
  }
}
