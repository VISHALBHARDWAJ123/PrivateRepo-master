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

  static List<String> suggestionList = [
    "Lighting",
    "Dining & Kitchen",
    "Living Room Furniture",
    "Bedroom",
    "MARKETPLACE",
    "Sofas",
    "Chairs",
    "Stools & Poufs",
    "Display Units",
    "Coffee & Side Tables",
    "Dining Tables",
    "Dining Chairs",
    "Dining Storage",
    "Beds",
    "Bedside Tables",
    "Mattresses",
    "Bedroom Storage",
    "Mirrors",
    "Desks",
    "Desk Accessories",
    "Floor Lamps",
    "Table Lamps",
    "Wall Lamps",
    "Ceiling Lamps",
    "Rugs",
    "Framed Wall Art",
    "Photo Accessories",
    "Clocks & Wall Decor",
    "Decor",
    "Cushions & Throws",
    "Tableware",
    "Glassware",
    "Dining Accessories",
    "Kitchen",
    "Flowers",
    "Pots & Planters",
    "Vases",
    "Flowers & Plants",
    "Candles",
    "Candles & Fragrances",
    "Candle Accessories",
    "Quilts, Pillows & Inners",
    "Bed Linen",
    "Bedspreads",
    "Bedroom Accessories",
    "Bath Accessories",
    "Trinkets",
    "Dining Room Furniture",
    "Bedroom Furniture",
    "Dining Room Furniture",
    "FUSION by THE One",
    "Living Room Furniture",
    "Sofas FUSION",
    "Stools & Poufs FUSION",
    "Display Units FUSION",
    "Cabinets FUSION",
    "Coffee & Side Tables FUSION",
    "Chairs FUSION",
    "Living Room Accessories",
    "Rugs FUSION",
    "Wall Art FUSION",
    "Photo Accessories FUSION",
    "Clocks & Wall Decor FUSION",
    "Home Decor FUSION",
    "Throws & Cushions FUSION",
    "Curtains & Accessories FUSION",
    "Quilts, Pillows & Inners FUSION",
    "Dining Room Furniture",
    "Dining Tables FUSION",
    "Dining Chair FUSION",
    "Dining Ware",
    "Bar & Dining Accessories FUSION",
    "Flowers & Plants FUSION",
    "Vases FUSION",
    "Flower Accessories FUSION",
    "Candle Accessories FUSION",
    "Bedroom Furniture",
    "Beds FUSION",
    "Bedside Tables FUSION",
    "Mattresses Fusion",
    "BEDROOM Storage FUSION",
    "Dressing Tables FUSION",
    "Mirrors FUSION",
    "Bedroom Accessories  - Fusion",
    "Bedspreads FUSION",
    "Bedroom  Accessories FUSION",
    "Bath Accessories FUSION",
    "Desk Accessories FUSION",
    "LIGHTING",
    "Floor Lamps FUSION",
    "Table Lamps FUSION",
    "Wall Lamps FUSION",
    "Ceiling Lamps FUSION",
    "MARKETPLACE FUSION",
    "Music FUSION",
    "Trinkets FUSION",
    "Dining Storage FUSION",
    "BAZAAR",
    "HOMES DESIGNED WITH LOVE - MR.MOUDZ",
    "HOMES DESIGNED WITH LOVE - FARHANA BODI",
    "HOW-TO |  LIVING ROOM",
    "SHOP | SOFA SERIES | WINN",
    "SHOP | SOFA SERIES | LOUIE",
    "SHOP | SOFA SERIES | KINGSTON",
    "HOW-TO |  DINING",
    "HOW-TO |  BEDROOM",
    "Fusion",
    "SOFA STORIES SHOP | KARL",
    "SOFA STORIES SHOP | VIK",
    "SOFA STORIES SHOP | SPOD",
    "SOFA STORIES SHOP | FERA",
    "SOFA STORIES SHOP | KIBO",
    "SOFA STORIES SHOP | OREGON",
    "SOFA STORIES SHOP | SAN",
    "Our Collections",
    "ACCESSORIES",
    "THE One Furniture",
    "Candles",
    "SOFA STORIES SHOP |  LOUIE",
    "On The Wall",
    "Recommended Products",
    "WOW",
    "Home Decor",
    "Cushions",
    "Throws",
    "Bathroom",
    "Modular Sofas",
    "SPRING 2020 Living",
    "Mattresses Qatar",
    "RAMADAN COLLECTION",
    "Chaise Lounge Sofa",
    "2 Seater Sofa Couch",
    "U Sofa Couch",
    "3 Seater Sofa Couch",
    "Corner Sofa",
    "Microfiber Couch",
    "Autumn Winter Collection 2021 UAE",
    "THE One Spring Collection 2021 Kuwait",
    "THE One  Spring Collection 2021 Bahrain",
    "Autumn Collection -  Studio 3",
    "Christmas Gift Ideas",
    "Service Charges",
    "Service Charges BAH",
    "Service Charges KWT",
    "GIFT SHOP",
    "3 Seater Sofas",
    "Natural Neutrals",
    "Lavender Hues",
    "Blush Green",
    "2 Seater Sofas",
    "Marketplace",
    "DIWALI"
  ];






}
