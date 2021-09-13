// import 'package:connectivity/connectivity.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/AppPages/ForgotPass/ForgotPassword.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/Registration/RegistrationPage.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';
import 'package:untitled2/utils/CartBadgeCounter/CartBadgetLogic.dart';
import 'package:untitled2/utils/utils/colors.dart';
import 'package:untitled2/utils/utils/general_functions.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with InputValidationMixin {
  var passController = TextEditingController();
  var emailController = TextEditingController();
  var otpController = TextEditingController();
  bool emailError = false;
  bool passError = true;

  bool connectionStatus = true;
  var btnColor;
  var apiTokken;
  DateTime currentBackPressTime = DateTime.now();

  var isSuffix = true;

  GlobalKey<FormState> _loginKey = GlobalKey<FormState>();

  void initilaize() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    initilaize();

    ConstantsVar.subscription = ConstantsVar.connectivity.onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        ConstantsVar.showSnackbar(context, ' Internet connection found.', 5);
        setState(() {
          connectionStatus = true;
          btnColor = Colors.black;
        });
      } else {
        ConstantsVar.showSnackbar(context,
            'No Internet connection found. Please check your connection', 5);
        setState(() {
          connectionStatus = false;
          btnColor = Colors.grey;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    ConstantsVar.subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: WillPopScope(
        onWillPop: ApiCalls.onWillPop,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          extendBodyBehindAppBar: true,
          body: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: FlutterSizer(
              builder: (BuildContext, Orientation, ScreenType) {
                return Center(
                  child: SingleChildScrollView(
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        color: Colors.white10,
                        child: Form(
                          key: _loginKey,
                          child: ListView(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.bottomCenter,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () => Navigator.pop(context),
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(
                                            5.h, 3.5.h, 5.h, 3.5.h),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          child: Container(
                                              width: 20.h,
                                              height: 20.h,
                                              child: Image.asset(
                                                "MyAssets/logo.png",
                                                fit: BoxFit.fill,
                                              )),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "CUSTOMER LOGIN",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 26.dp,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 2),
                                    )
                                  ],
                                ),
                              ),
                              addVerticalSpace(6.h),
                              Padding(
                                padding: EdgeInsets.only(left: 8.w, right: 8.w),
                                child: Container(
                                  height: 55.h,
                                  child: Form(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0)),
                                          elevation: 8.0,
                                          child: Container(
                                            height: 15.w,
                                            child: TextFormField(
                                              validator: (val) {
                                                if (isEmailValid(val!)) {
                                                  return null;
                                                }
                                                return 'Please enter a valid email address!.';
                                              },
                                              controller: emailController,
                                              style: TextStyle(
                                                  color: Colors.black),
                                              decoration: editBoxDecoration(
                                                  'E-mail Address',
                                                  Icon(
                                                    Icons.email,
                                                    color: AppColor
                                                        .PrimaryAccentColor,
                                                  ),
                                                  false),
                                            ),
                                          ),
                                        ),
                                        Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0)),
                                          elevation: 8.0,
                                          child: Container(
                                            padding:
                                                EdgeInsets.only(right: 12.0),
                                            child: TextFormField(
                                              enableInteractiveSelection: false,
                                              textInputAction:
                                                  TextInputAction.next,
                                              obscureText: passError,
                                              // validator: (inputz) =>
                                              //     input!.isValidPass() ? null : "Check your Password",
                                              controller: passController,
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              cursorColor: Colors.black,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14),
                                              decoration: new InputDecoration(
                                                  suffix: ClipOval(
                                                    child: RoundCheckBox(
                                                      uncheckedColor:
                                                          Colors.white,
                                                      checkedColor:
                                                          Colors.white,
                                                      size: 26,
                                                      onTap: (selected) {
                                                        setState(() {
                                                          print(
                                                              'Tera kaam  bngya');
                                                          passError
                                                              ? passError =
                                                                  selected!
                                                              : passError =
                                                                  selected!;
                                                        });
                                                      },
                                                      isChecked: passError,
                                                      checkedWidget: Center(
                                                        child: Icon(
                                                          Icons
                                                              .remove_red_eye_outlined,
                                                        ),
                                                      ),
                                                      uncheckedWidget: Center(
                                                        child: Icon(
                                                          Icons.remove_red_eye,
                                                          color: ConstantsVar
                                                              .appColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  prefixIcon: Icon(
                                                    Icons.password_rounded,
                                                    color:
                                                        ConstantsVar.appColor,
                                                  ),
                                                  labelStyle: TextStyle(
                                                      fontSize: 5.w,
                                                      color: Colors.grey),
                                                  labelText: 'Password',
                                                  border: InputBorder.none),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          margin: EdgeInsets.symmetric(
                                            vertical: 3.h,
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Expanded(
                                                child: Card(
                                                  color: AppColor
                                                      .PrimaryAccentColor,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              36.0)),
                                                  child: Container(
                                                    height: 12.w,
                                                    child: IgnorePointer(
                                                      ignoring:
                                                          connectionStatus ==
                                                                  true
                                                              ? false
                                                              : true,
                                                      child: TextButton(
                                                          onPressed: () async {
                                                            if (_loginKey
                                                                .currentState!
                                                                .validate()) {
                                                              _loginKey
                                                                  .currentState!
                                                                  .save();

                                                              ApiCalls.login(
                                                                context,
                                                                emailController
                                                                    .text
                                                                    .toString()
                                                                    .trim(),
                                                                passController
                                                                    .text,
                                                              ).then((val) {
                                                                val == true
                                                                    ? getCartBagdge(0).then((value) => Navigator.pushAndRemoveUntil(
                                                                        context,
                                                                        CupertinoPageRoute(
                                                                            builder: (context) =>
                                                                                MyApp()),
                                                                        (route) =>
                                                                            false))
                                                                    : null;

                                                                setState(() {
                                                                  ConstantsVar
                                                                          .isVisible =
                                                                      false;
                                                                  print(val);
                                                                });
                                                              });
                                                            } else {
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg:
                                                                          'Please Enter Correct Details');
                                                            }
                                                          },
                                                          child: Text(
                                                            "LOGIN",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 14.0),
                                                          )),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Card(
                                                  color: AppColor
                                                      .PrimaryAccentColor,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              36.0)),
                                                  child: Container(
                                                    height: 12.w,
                                                    margin: EdgeInsets.only(
                                                        left: 16.0),
                                                    child: IgnorePointer(
                                                      ignoring:
                                                          connectionStatus ==
                                                                  true
                                                              ? false
                                                              : true,
                                                      child: TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .push(MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            RegstrationPage()));
                                                          },
                                                          child: Text(
                                                            "REGISTER",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 14.0),
                                                          )),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Center(
                                            child: FlatButton(
                                                onPressed: () {
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ForgotPassScreen()));
                                                },
                                                child: Text(
                                                  'Forgot Password?',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ))),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration editBoxDecoration(String name, Icon icon, bool isSuffix) {
    return new InputDecoration(
        suffix: isSuffix == false
            ? null
            : ClipOval(
                child: RoundCheckBox(
                  border: Border.all(width: 0),
                  size: 24,
                  onTap: (selected) {},
                  checkedWidget: Icon(Icons.mood, color: Colors.white),
                  uncheckedWidget: Icon(Icons.mood_bad),
                  animationDuration: Duration(
                    seconds: 1,
                  ),
                ),
              ),
        prefixIcon: icon,
        labelStyle: TextStyle(fontSize: 5.w, color: Colors.grey),
        labelText: name,
        border: InputBorder.none);
  }

  Future getCartBagdge(int val) async {
    ApiCalls.readCounter(
            customerGuid: ConstantsVar.prefs.getString('guestGUID')!)
        .then((value) {
      setState(() {
        val = int.parse(value);
        context.read<cartCounter>().changeCounter(val);
      });
    });
  }
}
