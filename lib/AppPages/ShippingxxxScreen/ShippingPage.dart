import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/Registration/RegistrationPage.dart';
import 'package:untitled2/AppPages/ShippingxxMethodxx/ShippingxxMethodxx.dart';
import 'package:untitled2/AppPages/ShippingxxxScreen/BillingxxScreen/ShippingAddress.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/utils/utils/build_config.dart';
import 'package:untitled2/utils/utils/colors.dart';

class ShippingDetails extends StatefulWidget {
  ShippingDetails({Key? key, required this.customerId, required this.tokken})
      : super(key: key);
  String customerId;
  final tokken;

  @override
  _ShippingDetailsState createState() => _ShippingDetailsState();
}

class _ShippingDetailsState extends State<ShippingDetails>
    with InputValidationMixin {
  late TextEditingController textController1;
  late TextEditingController textController2;
  late TextEditingController textController3;
  late TextEditingController textController4;
  late TextEditingController textController5;
  late TextEditingController textController6;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  FocusNode myFocusNode = new FocusNode();

  var countryController = TextEditingController();

  var textControllerLast = TextEditingController();

  var controllerAddress = TextEditingController();

  var eController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textController1 = TextEditingController();
    textController2 = TextEditingController();
    textController3 = TextEditingController();
    textController4 = TextEditingController();
    textController5 = TextEditingController();
    textController6 = TextEditingController();
    initSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Scaffold(
        appBar: new AppBar(
            toolbarHeight: 18.w,
            centerTitle: true,
            title: GestureDetector(
              onTap: () => Navigator.pushAndRemoveUntil(
                  context,
                  CupertinoPageRoute(builder: (context) => MyApp()),
                  (route) => false),
              child: Image.asset(
                'MyAssets/logo.png',
                width: 15.w,
                height: 15.w,
              ),
            )),
        resizeToAvoidBottomInset: true,
        key: scaffoldKey,
        body: WillPopScope(
          onWillPop: _willGoBack,
          child: SafeArea(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Color(0xFFEEEEEE),
              ),
              child: Column(
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
                          'shipping ADDRESS'.toUpperCase(),
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 6.5.w,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                            padding: const EdgeInsets.all(4.0),
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
                                fontSize: 4.w,
                              ),
                              maxLines: 1,
                              validator: (val) {
                                if (isFirstName(val!))
                                  return null;
                                else
                                  return 'Please Enter Your First Name';
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
                            padding: const EdgeInsets.all(4.0),
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
                                  ''),
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 4.w,
                              ),
                              maxLines: 1,
                              validator: (val) {
                                if (isLastName(val!))
                                  return null;
                                else
                                  return 'Please Enter Your Last Name';
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
                              padding: const EdgeInsets.all(4.0),
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                maxLength: 9,
                                onChanged: (_) => setState(() {}),
                                controller: textController2,
                                obscureText: false,
                                decoration: editBoxDecoration(
                                    'phone number'.toUpperCase(),
                                    Icon(Icons.phone,
                                        color: AppColor.PrimaryAccentColor),
                                    ''),
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 4.w,
                                ),
                                keyboardType: TextInputType.number,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Please Enter Your Phone Number';
                                  }
                                  if (val.length < 9) {
                                    return 'Please Enter Your Number Correctly';
                                  }
                                  if (val.length > 9) {
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
                          elevation: 4.0,
                          child: Container(
                            padding: EdgeInsets.only(right: 12.0),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.emailAddress,
                                  controller: eController,
                                  validator: (val) {
                                    if (isEmailValid(val!)) {
                                      return null;
                                    }

                                    return 'Enter your email address';
                                  },
                                  cursorColor: Colors.black,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 4.w),
                                  decoration: editBoxDecoration(
                                      'Email Address'.toUpperCase(),
                                      Icon(
                                        Icons.email_outlined,
                                        color: AppColor.PrimaryAccentColor,
                                      ),
                                      '')),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          elevation: 4.0,
                          child: Container(
                            padding: EdgeInsets.only(right: 12.0),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.emailAddress,
                                controller: controllerAddress,
                                validator: (val) {
                                  if (isAddress(val!))
                                    return null;
                                  else
                                    return 'Enter your Address';
                                },
                                cursorColor: Colors.black,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 4.w),
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
                            padding: const EdgeInsets.all(4.0),
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
                              ),
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 4.w,
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
                      AppButton(
                        color: ConstantsVar.appColor,
                        width: 50.w,
                        onTap: () => Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => ShippingAddress())),
                        child: Text(
                          'CANCEL',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Work Sans',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      AppButton(
                        color: ConstantsVar.appColor,
                        width: 50.w,
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            context.loaderOverlay.show(
                                widget: SpinKitRipple(
                              color: Colors.red,
                              size: 90,
                            ));
                            print('Tap appear on Add Shipping Address');
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
                              'PhoneNumber': '971${textController2.text}',
                              'FaxNumber': '',
                              'Country': 'UAE',
                            };
                            print(widget.tokken);
                            Map<String, dynamic> shipBody = {
                              'address': body,
                              'PickUpInStore': false,
                              'pickupPointId': null
                            };

                            addShippingAddress(jsonEncode(shipBody))
                                .then((value) {
                              print(value);
                              context.loaderOverlay.hide();
                              String paymentUrl = BuildConfig.base_url +
                                  'customer/CreateCustomerOrder?apiToken=${ConstantsVar.apiTokken.toString()}&CustomerId=${widget.customerId.toString()}&PaymentMethod=Payments.CyberSource';
                              Navigator.pushReplacement(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => ShippingMethod(
                                    paymentUrl: paymentUrl,
                                    customerId: widget.customerId,
                                  ),
                                ),
                              );
                            });
                          } else {
                            Fluttertoast.showToast(
                                msg: 'Please provide correct details');
                          }
                        },
                        child: Center(
                          child: Text(
                            'CONTINUE',
                            style: TextStyle(
                              fontFamily: 'Work Sans',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
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
      ),
    );
  }

  InputDecoration editBoxDecoration(String name, Icon icon, String prefixText) {
    return new InputDecoration(
      counterText: '',
      prefixText: prefixText,
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

  Future<void> initSharedPrefs() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
    widget.customerId = ConstantsVar.prefs.getString('guestCustomerID')!;
  }

  Future addShippingAddress(String encodedResponse) async {
    final uri = Uri.parse(BuildConfig.base_url +
        'apis/AddSelectNewShippingAddress?apiToken=${widget.tokken}&customerid=${widget.customerId}&ShippingAddressModel=$encodedResponse');
    try {
      var response = await http.post(uri);
      print('Response>>>>>>>' + response.body);
      return json.decode(response.body);
    } on Exception catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  Future<bool> _willGoBack() async {
    Navigator.pushReplacement(
        context, CupertinoPageRoute(builder: (context) => ShippingAddress()));
    return true;
  }
}
