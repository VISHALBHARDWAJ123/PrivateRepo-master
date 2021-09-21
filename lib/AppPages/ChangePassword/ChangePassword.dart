import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

import 'package:untitled2/AppPages/CartxxScreen/ConstantVariables.dart';
import 'package:untitled2/AppPages/CustomLoader/CustomDialog/CustomDialog.dart';
import 'package:untitled2/AppPages/Registration/RegistrationPage.dart';
import 'package:untitled2/AppPages/Registration/register_page.dart';
import 'package:untitled2/utils/utils/build_config.dart';
import 'package:untitled2/utils/utils/colors.dart';

class Demo3Page extends StatefulWidget {
  @override
  State<Demo3Page> createState() => _Demo3PageState();
}

class _Demo3PageState extends State<Demo3Page> with InputValidationMixin {
  FocusNode myFocusNode = new FocusNode();

  GlobalKey<FormState> myGlobalKey = new GlobalKey<FormState>();

  TextEditingController pController = TextEditingController();
  TextEditingController cpController = TextEditingController();
  TextEditingController oldpController = TextEditingController();

  bool passError = true;

  bool cpError = true;

  bool oldpassError = true;

  var _apiToken;

  var _customerId;

  void initSharedPrefs() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();

    setState(() {
      _customerId = ConstantsVar.prefs.getString('userId');
      _apiToken = ConstantsVar.prefs.getString('apiTokken');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    initSharedPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      child: Scaffold(
        // backgroundColor: Page.background,
        appBar: AppBar(
          backgroundColor: ConstantsVar.appColor,
        ),

        body: GestureDetector(
          // close keyboard on outside input tap
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },

          child: Builder(
            builder: (context) => Form(
              key: myGlobalKey,
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.all(10),
                      children: <Widget>[
                        // header text
                        Container(
                          child: Center(
                            child: Text(
                              'Reset Password'.toUpperCase(),
                              style: TextStyle(
                                fontSize: 6.5.w,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        //Old password input
                        Padding(
                          padding: EdgeInsets.only(top: 48.0),
                          child: Card(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: TextFormField(
                                enableInteractiveSelection: false,
                                validator: (password) {
                                  if (oldPassword(password!))
                                    return null;
                                  else
                                    return 'Please enter your password';
                                },
                                textInputAction: TextInputAction.next,
                                obscureText: oldpassError,
                                controller: oldpController,
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
                                            oldpassError
                                                ? oldpassError = selected!
                                                : oldpassError = selected!;
                                          });
                                        },
                                        isChecked: oldpassError,
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
                                    labelStyle: TextStyle(
                                        fontSize: 5.w, color: Colors.grey),
                                    labelText: 'Old Password',
                                    border: InputBorder.none),
                              ),
                            ),
                          ),
                        ),

                        //New password input
                        Padding(
                          padding: EdgeInsets.only(top: 16.0),
                          child: Card(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
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
                                    labelStyle: TextStyle(
                                        fontSize: 5.w, color: Colors.grey),
                                    labelText: 'New Password',
                                    border: InputBorder.none),
                              ),
                            ),
                          ),
                        ),
                        //Confirm password input

                        Padding(
                          padding: EdgeInsets.only(top: 16.0),
                          child: Card(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
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
                                      labelStyle: TextStyle(
                                          fontSize: 5.w, color: Colors.grey),
                                      labelText: 'Confirm Password',
                                      border: InputBorder.none)),
                            ),
                          ),
                        ),

                        // submit button

                        // sign up button
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: AppButton(
                      color: ConstantsVar.appColor,
                      child: Container(
                        width: 100.w,
                        child: Center(
                          child: Text(
                            'Reset Password'.toUpperCase(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 5.4.w,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      text: '',

                      // add your on tap handler here
                      onTap: () async {
                        if (myGlobalKey.currentState!.validate()) {
                          myGlobalKey.currentState!.save();
                          changePassword();
                        } else {
                          Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text('Please enter correct password.')));
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> changePassword() async {
    // var client = Client();
    final dynamic body = {
      'apiToken': _apiToken,
      'customerId': _customerId,
      'data': jsonEncode(
        {
          'OldPassword': oldpController.text,
          'NewPassword': pController.text,
          'ConfirmNewPassword': cpController.text,
          'Result': null,
          'CustomProperties': {},
        },
      ),
    };
    final uri =
        Uri.parse(BuildConfig.base_url + 'customer/ChangeCustomerPassword?');
    var resp = await post(uri, body: body);

    try {
      var result = jsonDecode(resp.body);

      var status;
      var message;
      setState(() {
        status = result['Status'];
        message = result['Message'][0].toString();
      });

      if (status.toString().contains('Failed')) {
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
              height: 25.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    'Changing password failed.\n\n' + message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 4.w,
                        color: Colors.white),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AppButton(
                        color: Colors.black,
                        child: Container(
                          width: 30.w,
                          child: Center(
                            child: Text(
                              'Okay',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        onTap: () => Navigator.pop(
                          context,
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
              height: 25.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 4.w,
                        color: Colors.white),
                  ),
                  AppButton(
                    color: Colors.black,
                    child: Container(
                      width: 30.w,
                      child: Center(
                        child: Text(
                          'Okay',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    onTap: () => clearUserDetails()
                        .whenComplete(() => Phoenix.rebirth(context)),
                  ),
                ],
              ),
            );
          },
        );
      }

      print(result);
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  InputDecoration editBoxDecoration(
      {required String name, required Icon icon, required String prefixText}) {
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

  void showErrorDialog(String reason) {
    showDialog(
        context: context,
        builder: (context) {
          return CustomDialogBox1(
            descriptions: 'Changing password failed',
            text: 'Okay'.toUpperCase(),
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
            descriptions: 'Registration Successfully Complete',
            text: 'Okay',
            img: 'MyAssets/logo.png',
            isOkay: true,
          );
        });
  }

  Future clearUserDetails() async {
    ConstantsVar.prefs.clear();
  }
}
