import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/AppPages/CartxxScreen/ConstantVariables.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';
import 'package:untitled2/utils/utils/colors.dart';

import 'BillingxxScreen/BillingScreen.dart';
import 'BillingxxScreen/ShippingAddress.dart';

class AddressScreen extends StatefulWidget {
  AddressScreen({Key? key, required this.uri, required this.isShippingAddress})
      : super(key: key);
  String uri;
  bool isShippingAddress;

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  var eController = TextEditingController();
  var apiToken;
  late TextEditingController textController1;
  late TextEditingController textController2;
  late TextEditingController textController3;
  late TextEditingController textController4;
  late TextEditingController textController5;
  late TextEditingController textController6;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool checkBoxVal = false;
  FocusNode myFocusNode = new FocusNode();

  var countryController = TextEditingController();

  var textControllerLast = TextEditingController();

  var controllerAddress = TextEditingController();
  var guestId;

  @override
  void initState() {
    super.initState();
    getGuestId();
    textController1 = TextEditingController();
    textController2 = TextEditingController();
    textController3 = TextEditingController();
    textController4 = TextEditingController();
    textController5 = TextEditingController();
    textController6 = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: new AppBar(
            toolbarHeight: 18.w,
            centerTitle: true,
            title: InkWell(
              onTap: () => Navigator.pushAndRemoveUntil(
                  context,
                  CupertinoPageRoute(
                      builder: (BuildContext context) => MyHomePage()),
                  (route) => false),
              child: Image.asset(
                'MyAssets/logo.png',
                width: 15.w,
                height: 15.w,
              ),
            )),
        // resizeToAvoidBottomInset: false,
        key: scaffoldKey,
        body: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Color(0xFFEEEEEE),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color(0xFFEEEEEE),
                  ),
                  child: Align(
                    alignment: Alignment(0.05, 0),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        'Billing ADDRESS'.toUpperCase(),
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 6.w,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    scrollDirection: Axis.vertical,
                    children: [
                      Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        color: Colors.white,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            onChanged: (_) => setState(() {}),
                            controller: textController1,
                            obscureText: false,
                            decoration: editBoxDecoration(
                                'FIRST NAME'.toUpperCase(),
                                Icon(
                                  Icons.person_outline,
                                  color: AppColor.PrimaryAccentColor,
                                ),
                                ''),
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18.dp,
                            ),
                            maxLines: 1,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Please Provide Your Name';
                              }

                              return null;
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        color: Colors.white,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            onChanged: (_) => setState(() {}),
                            controller: textControllerLast,
                            obscureText: false,
                            decoration: editBoxDecoration(
                              'last Name'.toUpperCase(),
                              Icon(
                                Icons.person_outline,
                                color: Colors.red,
                              ),
                              '',
                            ),
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18.dp,
                            ),
                            maxLines: 1,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Please Provide Your Last Name';
                              }

                              return null;
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        color: Colors.white,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              maxLength: 9,
                              onChanged: (_) => setState(() {}),
                              controller: textController2,
                              obscureText: false,
                              decoration: editBoxDecoration(
                                  'number'.toUpperCase(),
                                  Icon(Icons.phone,
                                      color: AppColor.PrimaryAccentColor),
                                  '+971'),
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18.dp,
                              ),
                              keyboardType: TextInputType.number,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Please Enter Your Number';
                                }
                                if (val.length < 9) {
                                  return 'Please Enter Your Number Correctly';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        elevation: 8.0,
                        child: Container(
                          padding: EdgeInsets.only(right: 12.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              controller: eController,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Please Provide Your Email Address';
                                }

                                return null;
                              },
                              cursorColor: Colors.black,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                              decoration: editBoxDecoration(
                                  'Email Address'.toUpperCase(),
                                  Icon(
                                    Icons.email_outlined,
                                    color: AppColor.PrimaryAccentColor,
                                  ),
                                  ''),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        elevation: 8.0,
                        child: Container(
                          padding: EdgeInsets.only(right: 12.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              controller: controllerAddress,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Please Provide Your Address';
                                }

                                return null;
                              },
                              cursorColor: Colors.black,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                              maxLines: 3,
                              decoration: editBoxDecoration(
                                  'Address'.toUpperCase(),
                                  Icon(
                                    Icons.home_outlined,
                                    color: AppColor.PrimaryAccentColor,
                                  ),
                                  ''),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        color: Colors.white,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            onChanged: (_) => setState(() {}),
                            controller: textController6,
                            obscureText: false,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.location_city_outlined,
                                color: AppColor.PrimaryAccentColor,
                              ),
                              labelText: 'CITY'.toUpperCase(),
                              labelStyle: TextStyle(
                                color: Colors.grey,
                              ),

                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18.dp,
                            ),
                            maxLines: 1,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Please Provide Your City';
                              }

                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        decoration: BoxDecoration(
                          color: ConstantsVar.appColor,
                        ),
                        child: Align(
                          alignment: Alignment(0, 0),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text(
                              'CANCEL',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Work Sans',
                                  fontSize: 18.dp,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (textController1.text.isEmpty ||
                            textController2.text.isEmpty ||
                            textControllerLast.text.isEmpty ||
                            eController.text.isEmpty ||
                            controllerAddress.text.isEmpty ||
                            textController6.text.isEmpty) {
                          Fluttertoast.showToast(
                              msg: 'Please enter your details');
                        } else {
                          Map<String, dynamic> body = {
                            'FirstName': '${textController1.text}',
                            'LastName': textControllerLast.text,
                            'Email': eController.text,
                            'Company': '',
                            'CountryId': '79',
                            'StateProvinceId': '',
                            'City': '${textController6.text}',
                            'Address1': controllerAddress.text,
                            'Address2': '',
                            'ZipPostalCode': '',
                            'PhoneNumber': '+971${textController2.text}',
                            'FaxNumber': '',
                            'Country': 'UAE',
                          };
                          ConstantsVar.prefs.setString('addressJsonString',jsonEncode(body));
                          ApiCalls.addBillingORShippingAddress(context,'${apiToken}',
                                  guestId, jsonEncode(body));

                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        decoration: BoxDecoration(
                          color: ConstantsVar.appColor,
                        ),
                        child: Align(
                          alignment: Alignment(0, 0),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text(
                              'ADD ADDRESS',
                              style: TextStyle(
                                fontFamily: 'Work Sans',
                                fontWeight: FontWeight.bold,
                                fontSize: 18.dp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration editBoxDecoration(String name, Icon icon, String prefixText) {
    return new InputDecoration(
      prefixText: prefixText,
      counterText: '',
      prefixIcon: icon,
      // alignLabelWithHint: true,
      labelStyle: TextStyle(
          fontSize: myFocusNode.hasFocus ? 20 : 16.0,
          //I believe the size difference here is 6.0 to account padding
          color:
              myFocusNode.hasFocus ? AppColor.PrimaryAccentColor : Colors.grey),
      labelText: name,

      border: InputBorder.none,
    );
  }

  void getGuestId() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
    guestId = ConstantsVar.prefs.getString('guestCustomerID');
    apiToken = ConstantsVar.prefs.getString('apiTokken');
  }
}
