import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/AppPages/CustomLoader/CustomDialog/CustomDialog.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/OtP/NewxxOTPxxScreen.dart';
import 'package:untitled2/AppPages/OtP/OTPScreen.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/Widgets/widgets/AppBar.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';
import 'package:untitled2/utils/utils/build_config.dart';
import 'package:untitled2/utils/utils/colors.dart';
import 'package:untitled2/utils/utils/general_functions.dart';

class RegstrationPage extends StatefulWidget {
  @override
  _RegstrationPageState createState() => _RegstrationPageState();
}

class _RegstrationPageState extends State<RegstrationPage>
    with AutomaticKeepAliveClientMixin, InputValidationMixin {
  TextEditingController fController = TextEditingController();
  TextEditingController lController = TextEditingController();
  TextEditingController eController = TextEditingController();
  TextEditingController mController = TextEditingController();
  TextEditingController pController = TextEditingController();
  TextEditingController cpController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController dayController = TextEditingController();
  TextEditingController monthController = TextEditingController();
  TextEditingController yearController = TextEditingController();

  var first_name;
  var last_name;
  var email;
  var mobile_number;
  var passWord;
  var confPassword;
  var fErrorMsg = '';
  var lErrorMsg = '';
  var eErrorMsg = '';
  var mErrorMsg = '';
  var pErrorMsg = '';
  var cpErrorMsg = '';

  var reason;
  GlobalKey<FormState> formGlobalKey = GlobalKey<FormState>();

  void showErrorDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return CustomDialogBox1(
            descriptions: 'Registration failed',
            text: 'Okay',
            img: 'MyAssets/logo.png',
            reason: reason,
          );
        });
  }

  void showSucessDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return CustomDialogBox(
            descriptions: 'Registration and Login Successfully Completed.',
            text: 'Okay',
            img: 'MyAssets/logo.png',
            isOkay: true,
          );
        });
  }

  @override
  void initState() {
    initSharedPrefs();
    super.initState();
  }

  bool passError = true, cpError = true;

  Future register() async {
    String dataBody = ConstantsVar.prefs.getString('regBody')!;
    print(dataBody);

    String urL = BuildConfig.base_url + 'Customer/CustomerRegister';
    context.loaderOverlay.show(
        widget: SpinKitRipple(
      size: 90,
      color: Colors.red,
    ));
    final body = {
      'apiToken': ConstantsVar.apiTokken,
      'CustomerGuid': ConstantsVar.prefs.getString('guestGUID'),
      'data': dataBody
    };
    final url = Uri.parse(urL);

    try {
      var response = await post(url, body: body);
      var result = jsonDecode(response.body);
      print(result);
      String status = result['status'];
      if (status.contains('Sucess')) {
        ApiCalls.login(context, eController.text.toString(),
                cpController.text.toString(),'')
            .then((value) {
          context.loaderOverlay.hide();
          showSucessDialog();
        });
      } else {
        context.loaderOverlay.hide();

        setState(() => reason = result['Message']);
        showErrorDialog();
        print(result);
      }
    } on Exception catch (e) {
      context.loaderOverlay.hide();
      ConstantsVar.excecptionMessage(e);
      print(e.toString());
    }
  }

  FocusNode myFocusNode = new FocusNode();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        appBar: new AppBar(
            backgroundColor: ConstantsVar.appColor,
            toolbarHeight: 18.w,
            centerTitle: true,
            title: InkWell(
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
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                AppBarLogo('REGISTRATION', context),
                Flexible(
                  child: ListView(
                    children: [
                      Center(
                          child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Form(
                          key: formGlobalKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0)),
                                elevation: 8.0,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
                                  child: TextFormField(
                                    maxLength: 100,
                                    textInputAction: TextInputAction.next,
                                    controller: fController,
                                    validator: (firstName) {
                                      if (isFirstName(firstName!))
                                        return null;
                                      else
                                        return 'Enter a valid First Name';
                                    },
                                    cursorColor: Colors.black,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                    decoration: editBoxDecoration(
                                        'First Name',
                                        Icon(
                                          Icons.account_circle_outlined,
                                          color: AppColor.PrimaryAccentColor,
                                        ),
                                        ''),
                                  ),
                                ),
                              ),
                              addVerticalSpace(14),
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0)),
                                elevation: 8.0,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
                                  child: TextFormField(
                                    maxLength: 100,
                                    validator: (lastName) {
                                      if (isLastName(lastName!))
                                        return null;
                                      else
                                        return 'Enter your Last Name';
                                    },
                                    // textInputAction: TextInputAction.next,
                                    controller: lController,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    cursorColor: Colors.black,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                    decoration: editBoxDecoration(
                                        'Last Name',
                                        Icon(
                                          Icons.account_circle_outlined,
                                          color: AppColor.PrimaryAccentColor,
                                        ),
                                        ''),
                                  ),
                                ),
                              ),
                              addVerticalSpace(14),
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0)),
                                elevation: 8.0,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
                                  child: TextFormField(
                                    validator: (email) {
                                      if (isEmailValid(email!))
                                        return null;
                                      else
                                        return 'Enter a valid email address';
                                    },
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.emailAddress,
                                    controller: eController,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    cursorColor: Colors.black,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                    decoration: editBoxDecoration(
                                        'Email Address',
                                        Icon(
                                          Icons.email_outlined,
                                          color: AppColor.PrimaryAccentColor,
                                        ),
                                        ''),
                                  ),
                                ),
                              ),
                              addVerticalSpace(14),
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0)),
                                elevation: 8.0,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
                                  width: 88.w,
                                  child: TextFormField(
                                    maxLength: BuildConfig.phnVal,
                                    textInputAction: TextInputAction.next,
                                    validator: (mobInput) {
                                      if (isPhoneNumber(mobInput!))
                                        return 'Please Enter ${BuildConfig.phnVal} Digit Number';
                                      else
                                        return null;
                                    },
                                    keyboardType: TextInputType.phone,
                                    controller: mController,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    cursorColor: Colors.black,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                    decoration: editBoxDecoration(
                                        'Mobile',
                                        Icon(
                                          Icons.phone_android_outlined,
                                          color: AppColor.PrimaryAccentColor,
                                        ),
                                        '+971'),
                                  ),
                                ),
                              ),
                              addVerticalSpace(14),
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0)),
                                elevation: 8.0,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
                                  child: TextFormField(
                                      validator: (val) {
                                        if (isAddress(val!.trim()))
                                          return 'Enter your address';
                                        else
                                          return null;
                                      },
                                      textInputAction: TextInputAction.done,
                                      maxLines: 3,
                                      controller: addressController,
                                      cursorColor: Colors.black,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
                                      decoration: InputDecoration(
                                          counterText: '',
                                          prefixIcon: Icon(
                                            Icons.home,
                                            color: ConstantsVar.appColor,
                                          ),
                                          labelStyle: TextStyle(
                                              fontSize: 5.w,
                                              color: Colors.grey),
                                          labelText: 'Address',
                                          border: InputBorder.none)),
                                ),
                              ),
                              addVerticalSpace(14),
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0)),
                                elevation: 8.0,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
                                  child: TextFormField(
                                    enableInteractiveSelection: false,
                                    validator: (password) {
                                      if (isPasswordValid(password!))
                                        return 'Minimum 6 Characters. ';
                                      else
                                        return null;
                                    },
                                    textInputAction: TextInputAction.next,
                                    obscureText: passError,
                                    controller: pController,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    cursorColor: Colors.black,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                    decoration: InputDecoration(
                                        suffix: ClipOval(
                                          child: RoundCheckBox(
                                            uncheckedColor: Colors.white,
                                            checkedColor: Colors.white,
                                            size: 20,
                                            onTap: (selected) {
                                              setState(() {
                                                print('Tera kaam  bngya');
                                                passError
                                                    ? passError = selected!
                                                    : passError = selected!;
                                              });
                                            },
                                            isChecked: passError,
                                            borderColor: Colors.white,
                                            checkedWidget: Center(
                                              child: Icon(
                                                Icons.visibility,
                                                size: 20,

                                              ),
                                            ),
                                            uncheckedWidget: Center(
                                              child: Icon(
                                                Icons.visibility_off,
                                                color: ConstantsVar.appColor,
                                                size: 20,

                                              ),
                                            ),
                                          ),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.password_rounded,
                                          color: ConstantsVar.appColor,
                                        ),
                                        labelStyle: TextStyle(
                                            fontSize: 5.w, color: Colors.grey),
                                        labelText: 'Password',
                                        border: InputBorder.none),
                                  ),
                                ),
                              ),
                              addVerticalSpace(14),
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0)),
                                elevation: 8.0,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: TextFormField(
                                        enableInteractiveSelection: false,
                                        validator: (password) {
                                          if (isPasswordMatch(
                                            pController.text.toString(),
                                            cpController.text.toString(),
                                          ))
                                            return null;
                                          else
                                            return 'Password Mismatch!';
                                        },
                                        textInputAction: TextInputAction.done,
                                        obscureText: cpError,
                                        controller: cpController,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        cursorColor: Colors.black,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 14),
                                        decoration: InputDecoration(
                                            suffix: ClipOval(
                                              child: RoundCheckBox(
                                                borderColor: Colors.white,
                                                checkedColor: Colors.white,
                                                uncheckedColor: Colors.white,
                                                size: 20,
                                                onTap: (selected) {
                                                  setState(() {
                                                    print('Tera kaam  bngya');
                                                    cpError
                                                        ? cpError = selected!
                                                        : cpError = selected!;
                                                  });
                                                },
                                                isChecked: cpError,
                                                checkedWidget: Center(
                                                  child: Icon(
                                                    Icons
                                                        .visibility,
                                                    size: 20,
                                                  ),
                                                ),
                                                uncheckedWidget: Center(
                                                  child: Icon(
                                                    Icons.visibility_off,
                                                    color:
                                                        ConstantsVar.appColor,
                                                    size: 20,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            prefixIcon: Icon(
                                              Icons.password_rounded,
                                              color: ConstantsVar.appColor,
                                            ),
                                            labelStyle: TextStyle(
                                                fontSize: 5.w,
                                                color: Colors.grey),
                                            labelText: 'Confirm Password',
                                            border: InputBorder.none)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: RaisedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              color: ConstantsVar.appColor,
                              shape: RoundedRectangleBorder(),
                              child: SizedBox(
                                height: 50,
                                width: MediaQuery.of(context).size.width / 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Center(
                                    child: AutoSizeText(
                                      "CANCEL",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0),
                                    ),
                                  ),
                                ),
                              )),
                        ),
                        Expanded(
                          child: RaisedButton(
                              onPressed: () {
                                if (formGlobalKey.currentState!.validate()) {
                                  // use the information provided
                                  formGlobalKey.currentState!.save();

                                  String phnNumbe = mController.text.toString();
                                  var phnNumber;
                                  setState(() {
                                    phnNumber = phnNumbe;
                                  });
                                  Map<String, dynamic> regBody = {
                                    'Email': eController.text,
                                    'Username': '',
                                    'Password': pController.text,
                                    'ConfirmPassword': cpController.text,
                                    'Gender': "M",
                                    'FirstName': fController.text,
                                    'LastName': lController.text,
                                    'DayofBirthDay': 10,
                                    'DayofBirthMonth': 12,
                                    'DayofBirthYear': 2000,
                                    'StreetAddress': addressController.text,
                                    'StreetAddress2': 'xzx',
                                    'City': 'xz',
                                    'CountryId': '79',
                                    'AvailableCountries': null,
                                    'StateProvinceId': 12,
                                    'AvailableStates': null,
                                    'Phone':
                                        BuildConfig.uaeCountryCode + phnNumber,
                                    'Newsletter': false,
                                  };
                                  print(pController.text);
                                  String jsonString = jsonEncode(regBody);
                                  ConstantsVar.prefs
                                      .setString('regBody', jsonString)
                                      .then(
                                        (val) => Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) =>
                                                VerificationScreen2(
                                              phoneNumber: phnNumbe,
                                              email: eController.text,
                                              password: cpController.text,
                                            )
                                            // OTP_Screen(
                                            // title: 'OTP SCREEN',
                                            // mainBtnTitle:
                                            //     'Verify otp'.toUpperCase(),
                                            // phoneNumber: phnNumbe,
                                            // email:
                                            //     eController.text.toString(),
                                            // password: cpController.text)
                                            ,
                                          ),
                                        ),
                                      );
                                } else {
                                  Fluttertoast.showToast(
                                      msg: 'Please provide all details');
                                }
                              },
                              color: ConstantsVar.appColor,
                              shape: RoundedRectangleBorder(),
                              child: SizedBox(
                                height: 50,
                                width: MediaQuery.of(context).size.width / 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Center(
                                    child: AutoSizeText(
                                      "REGISTER",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0),
                                    ),
                                  ),
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
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
      prefixIcon: icon,
      labelStyle: TextStyle(
          fontSize: 5.w,
          color:
              myFocusNode.hasFocus ? AppColor.PrimaryAccentColor : Colors.grey),
      labelText: name,
      border: InputBorder.none,
      counterText: '',
    );
  }

  void initSharedPrefs() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
  }

  @override
  bool get wantKeepAlive => true;
}

mixin InputValidationMixin {
  bool isDiscountCoupont(String coupon, String) =>
      coupon.trim() != '' || coupon.trim().length != 0;

  bool isGiftCoupont(String coupon, String) =>
      coupon.trim() != '' || coupon.trim().length != 0;

  bool isPasswordValid(String password) =>
      password.length < 6 || password.length == 0;

  bool isPasswordMatch(String password, String confirmPass) =>
      password == confirmPass;

  bool isFirstName(String firstName) => firstName.trim().length != 0;

  bool isLastName(String lastName) => lastName.trim().length != 0;

  bool isPhoneNumber(String phnNumber) =>
      phnNumber.trim().length != BuildConfig.phnVal;

  bool isAddress(String addressString) => addressString.trim().length >= 5;

  bool isEmailValid(String email) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return regex.hasMatch(email);
  }

  bool oldPassword(String pass) => pass.trim().length != 0;
}
