import 'dart:convert';
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
import 'package:untitled2/AppPages/OtP/OTPScreen.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/Widgets/widgets/AppBar.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';
import 'package:untitled2/utils/utils/build_config.dart';
import 'package:untitled2/utils/utils/colors.dart';
import 'package:untitled2/utils/utils/general_functions.dart';

class RegstrationPage extends StatefulWidget {
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

  // TextEditingController otpController = TextEditingController();
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

  @override
  _RegstrationPageState createState() => _RegstrationPageState();
}

class _RegstrationPageState extends State<RegstrationPage>
    with AutomaticKeepAliveClientMixin {
  var reason;

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
            descriptions: 'Registration and Login Successfully Complete.',
            text: 'Okay',
            img: 'MyAssets/logo.png',
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    initSharedPrefs();
    super.initState();
  }

  Future register() async {
    String dataBody = ConstantsVar.prefs.getString('regBody')!;
    print(dataBody);

    String urL = BuildConfig.base_url + 'Customer/CustomerRegister?';
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

        ApiCalls.login(context, widget.eController.text.toString(),
                widget.cpController.text.toString())
            .then((value) {
          context.loaderOverlay.hide();
          showSucessDialog();
        });
      } else {
        context.loaderOverlay.hide();

        setState(() => reason = result['Message']);
        showErrorDialog();
        print(result);

        // Fluttertoast.showToast(msg: result['Message']);
      }
    } on Exception catch (e) {
      context.loaderOverlay.hide();
      Fluttertoast.showToast(msg: e.toString());
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        appBar: new AppBar(
            toolbarHeight: 18.w,
            centerTitle: true,
            title: Image.asset(
              'MyAssets/logo.png',
              width: 15.w,
              height: 15.w,
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
                        child: RegisterForm(
                          eErrorMsg: widget.eErrorMsg,
                          mErrorMsg: widget.mErrorMsg,
                          pErrorMsg: widget.pErrorMsg,
                          lErrorMsg: widget.lErrorMsg,
                          fController: widget.fController,
                          cpController: widget.cpController,
                          mController: widget.mController,
                          lController: widget.lController,
                          pController: widget.pController,
                          eController: widget.eController,
                          fErrorMsg: widget.fErrorMsg,
                          cpErrorMsg: widget.cpErrorMsg,
                          controllerAddress: widget.addressController,
                          dayController: widget.dayController,
                          monthController: widget.monthController,
                          yearController: widget.yearController,
                        ),
                      ),
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
                                    child: Text(
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
                                setState(() {
                                  widget.first_name = widget.fController.text;
                                  widget.last_name = widget.lController.text;
                                  widget.email = widget.eController.text;
                                  widget.mobile_number =
                                      widget.mController.text;
                                  widget.passWord = widget.pController.text;
                                  widget.confPassword =
                                      widget.cpController.text;
                                  fieldValidation();
                                });
                                registrationValidation(
                                        widget.first_name,
                                        widget.last_name,
                                        widget.email,
                                        widget.mobile_number,
                                        widget.passWord,
                                        widget.confPassword)
                                    .then((value) {});
                              },
                              color: ConstantsVar.appColor,
                              shape: RoundedRectangleBorder(),
                              child: SizedBox(
                                height: 50,
                                width: MediaQuery.of(context).size.width / 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Center(
                                    child: Text(
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

  Future registrationValidation(
      firstName, lastName, email, mobileNumber, passWord, confPassword) async {
    if (firstName.toString().length != 0 &&
        lastName.toString().length != 0 &&
        email.toString().length != 0 &&
        mobileNumber.toString().length != 0 &&
        passWord.toString().length != 0 &&
        confPassword.toString().length != 0) {
      String phnNumbe = widget.mController.text.toString();
      var phnNumber;
      setState(() {
        phnNumber = phnNumbe;
      });
      Map<String, dynamic> regBody = {
        'Email': widget.eController.text,
        'Username': '',
        'Password': widget.pController.text,
        'ConfirmPassword': widget.cpController.text,
        'Gender': '',
        'FirstName': widget.fController.text,
        'LastName': widget.lController.text,
        'DayofBirthDay': '',
        'DayofBirthMonth': '',
        'DayofBirthYear': '',
        'StreetAddress': widget.addressController.text,
        'StreetAddress2': '',
        'City': '',
        'CountryId': '79',
        'AvailableCountries': null,
        'StateProvinceId': 12,
        'AvailableStates': null,
        'Phone': '+971' + phnNumber,
        'Newsletter': false,
      };
      String jsonString = jsonEncode(regBody);
      ConstantsVar.prefs.setString('regBody', jsonString).then(
            (val) => register(),
          );
    } else {
      Fluttertoast.showToast(
          msg: 'Please provide all details correct',
          gravity: ToastGravity.SNACKBAR,
          toastLength: Toast.LENGTH_LONG);
    }
  }

  void fieldValidation() {
    if (widget.first_name.toString().length == 0) {
      widget.fErrorMsg = 'Please provide first name';
    }
    if (widget.last_name.toString().length == 0) {
      widget.lErrorMsg = 'Please provide last name';
    }
    if (widget.email.toString().length == 0) {
      widget.eErrorMsg = 'Please provide email';
    }
    if (widget.mobile_number.toString().length == 0) {
      widget.fErrorMsg = 'Please provide mobile number ';
    }
    if (widget.passWord.toString().length == 0) {
      widget.fErrorMsg = 'Please provide password ';
    }
    if (widget.confPassword.toString().length == 0) {
      widget.fErrorMsg = 'Please provide Confrimation password ';
    }

    if (widget.confPassword.toString().length == 0 &&
        widget.passWord.toString().length == 0 &&
        widget.email.toString().length == 0 &&
        widget.mobile_number.toString().length == 0 &&
        widget.last_name.toString().length == 0 &&
        widget.first_name.toString().length == 0) {
      widget.fErrorMsg = 'Please provide first name';
      widget.lErrorMsg = 'Please provide last name';
      widget.eErrorMsg = 'Please provide Email';
      widget.mErrorMsg = 'Please provide Moblie number';
      widget.pErrorMsg = 'Please provide password ';
      widget.lErrorMsg = 'Please provide Confirmation password';
    }
  }

  void initSharedPrefs() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class RegisterForm extends StatefulWidget {
  TextEditingController fController;
  TextEditingController lController;
  TextEditingController mController;
  TextEditingController eController;
  TextEditingController pController;
  TextEditingController cpController;
  TextEditingController controllerAddress,
      dayController,
      monthController,
      yearController;

  String fErrorMsg;
  String lErrorMsg;
  String eErrorMsg;
  String mErrorMsg;
  String pErrorMsg;
  String cpErrorMsg;

  RegisterForm({
    required this.dayController,
    required this.monthController,
    required this.yearController,
    required this.fController,
    required this.lController,
    required this.mController,
    required this.eController,
    required this.pController,
    required this.cpController,
    required this.fErrorMsg,
    required this.lErrorMsg,
    required this.eErrorMsg,
    required this.mErrorMsg,
    required this.pErrorMsg,
    required this.cpErrorMsg,
    required this.controllerAddress,
  });

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm>
    with AutomaticKeepAliveClientMixin {
  FocusNode myFocusNode = new FocusNode();

  bool passError = true, cpError = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              elevation: 8.0,
              child: Container(
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: widget.fController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter First Name';
                    }
                    return null;
                  },
                  cursorColor: Colors.black,
                  style: TextStyle(color: Colors.black, fontSize: 14),
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
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: widget.lController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  cursorColor: Colors.black,
                  style: TextStyle(color: Colors.black, fontSize: 14),
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
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  controller: widget.eController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  cursorColor: Colors.black,
                  style: TextStyle(color: Colors.black, fontSize: 14),
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
            addVerticalSpace(14),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  elevation: 8.0,
                  child: Container(
                    width: 88.w,
                    child: TextFormField(
                      maxLength: 10,
                      textInputAction: TextInputAction.next,
                      validator: (mobInput) {
                        mobInput = widget.mController.text;
                        if (mobInput.length == 0 ||
                            mobInput.length < 9 ||
                            mobInput.length > 9) {
                          return 'Please provide 9 digit Phone Number';
                        } else {
                          return '';
                        }
                      },
                      keyboardType: TextInputType.phone,
                      controller: widget.mController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      cursorColor: Colors.black,
                      style: TextStyle(color: Colors.black, fontSize: 14),
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
              ],
            ),
            addVerticalSpace(14),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              elevation: 8.0,
              child: Container(
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  obscureText: passError,
                  controller: widget.pController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  cursorColor: Colors.black,
                  style: TextStyle(color: Colors.black, fontSize: 14),
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
                          checkedWidget: Center(
                            child: Icon(
                              Icons.remove_red_eye_outlined,
                              size: 16,
                            ),
                          ),
                          uncheckedWidget: Center(
                            child: Icon(
                              Icons.remove_red_eye,
                              color: ConstantsVar.appColor,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.password_rounded,
                        color: ConstantsVar.appColor,
                      ),
                      labelStyle: TextStyle(fontSize: 5.w, color: Colors.grey),
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextFormField(
                      textInputAction: TextInputAction.done,
                      obscureText: cpError,
                      validator: (input) => input == widget.pController.text
                          ? null
                          : 'Password Mismatch!',
                      controller: widget.cpController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      cursorColor: Colors.black,
                      style: TextStyle(color: Colors.black, fontSize: 14),
                      decoration: InputDecoration(
                          suffix: ClipOval(
                            child: RoundCheckBox(
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
                                  Icons.remove_red_eye_outlined,
                                  size: 16,
                                ),
                              ),
                              uncheckedWidget: Center(
                                child: Icon(
                                  Icons.remove_red_eye,
                                  color: ConstantsVar.appColor,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.password_rounded,
                            color: ConstantsVar.appColor,
                          ),
                          labelStyle:
                              TextStyle(fontSize: 5.w, color: Colors.grey),
                          labelText: 'Confirm Password',
                          border: InputBorder.none)),
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              elevation: 8.0,
              child: Container(
                child: TextFormField(
                    textInputAction: TextInputAction.done,
                    maxLines: 3,
                    controller: widget.controllerAddress,
                    cursorColor: Colors.black,
                    style: TextStyle(color: Colors.black, fontSize: 14),
                    decoration: InputDecoration(
                        counterText: '',
                        prefixIcon: Icon(
                          Icons.home,
                          color: ConstantsVar.appColor,
                        ),
                        labelStyle:
                            TextStyle(fontSize: 5.w, color: Colors.grey),
                        labelText: 'Address',
                        border: InputBorder.none)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Card editBoxStyle(String title, Icon icon, TextEditingController controller) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 8.0,
      child: Container(
        child: TextField(
            controller: controller,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
                hintText: title, prefixIcon: icon, border: InputBorder.none)),
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

String? validatePassword(String value, String message) {
  if ((value.length == 0)) {
    return message;
  }
  return null;
}

extension PasswordValidator on String {
  bool isValidPass() {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    return RegExp(pattern).hasMatch(this);
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}
