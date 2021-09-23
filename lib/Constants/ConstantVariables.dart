import 'dart:async';
import 'dart:ui';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:untitled2/PojoClass/GridViewModel.dart';
import 'package:untitled2/utils/ApiCalls/ModelClass.dart';
import 'package:untitled2/utils/HeartIcon.dart';

class ConstantsVar {
  static String baseUri = 'https://www.theone.com/apis/';

  static double width = MediaQueryData.fromWindow(window).size.width;
  static double height = MediaQueryData.fromWindow(window).size.height;
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

  static List<String> images = [
    'asset1.jpg',
    'asset2.jpg',
    'asset3.jpg',
    'asset4.jpg',
    'asset5.jpg',
  ];

  static String netImage1 =
      'https://images.unsplash.com/photo-1523275335684-37898b6baf30?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=689&q=80';
  static String netImage2 =
      'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=750&q=80';
  static String netImage3 =
      'https://images.unsplash.com/photo-1491553895911-0055eca6402d?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80';
  static String netImage4 =
      'https://images.unsplash.com/photo-1572635196237-14b3f281503f?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80';
  static String netImage5 =
      'https://images.unsplash.com/photo-1586495777744-4413f21062fa?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=358&q=80';
  static String netImage6 =
      'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=750&q=80';
  static String netImages7 =
      'https://images.unsplash.com/photo-1550581190-9c1c48d21d6c?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=698&q=80';
  static String netImages8 =
      'https://images.unsplash.com/photo-1551029118-d3c293a67c0e?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=828&q=80';
  static String netImages9 =
      'https://images.unsplash.com/photo-1584100936595-c0654b55a2e2?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=377&q=80';
  static List<String> netImages = [
    netImage1,
    netImage2,
    netImage3,
    netImage4,
    netImage5,
    netImage6
  ];
  static List<String> similarimages = [
    netImages7,
    netImages8,
    netImages9,
  ];

  static ModelClass model1 = ModelClass(
      'MyAssets/livinghall.jpg', 'LIVING HALL FURNITURE', '1500 left');

  static ModelClass model3 =
      ModelClass('MyAssets/bedroom.jpg', 'BEDROOM FURNITURE', '1500 left');

  static ModelClass model2 = ModelClass(
      'MyAssets/dininghall.jpg', 'DINING HALL FURNITURE', '1500 left');

  static List<ModelClass> myList = [model1, model2, model3];

  static GridViewModel myModel = GridViewModel(
      'MyAssets/asset1.jpg', '10-40% off', 'Dryer', 'Smart DZ Dryer');
  static GridViewModel myModel1 = GridViewModel(
      'MyAssets/asset2.jpg', '10-40% off', 'Watches', 'Smart DZ Watch');
  static GridViewModel myModel2 =
      GridViewModel('MyAssets/asset3.jpg', '10-40% off', 'Shoes', 'Puma FLIA');

  static List<GridViewModel> mList1 = [myModel, myModel1, myModel2];

  static const String pass_Pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  static const String email_Pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  static Future checkValidation(
      String email, String pass, BuildContext context) async {
    if (RegExp(pass_Pattern).hasMatch(pass) &&
        RegExp(email_Pattern).hasMatch(email)) {
      showSnackbar(context, 'Pattern Matches', 4);
      // apiTokken = await ApiCalls.getApiTokken(context);
      // print(apiTokken);
    } else {
      showSnackbar(context, 'Pattern Missmatches', 4);
      isVisible = false;
    }
  }

  static String stripHtmlIfNeeded(String text) {
    return text.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '');
  }



//This is for Cart badge
// static int? badgeNumber = prefs.getInt('badgeNumber');

}
