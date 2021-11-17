import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:loader_overlay/src/overlay_controller_widget_extension.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:untitled2/AppPages/CustomLoader/CustomDialog/CustomDialog.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';
import 'package:untitled2/utils/utils/build_config.dart';

import 'OTP_Response.dart';

const Color primaryColor = Color(0xFF121212);
const Color accentPurpleColor = Color(0xFF6A53A1);
const Color accentPinkColor = Color(0xFFF99BBD);
const Color accentDarkGreenColor = Color(0xFF115C49);
const Color accentYellowColor = Color(0xFFFFB612);
const Color accentOrangeColor = Color(0xFFEA7A3B);

class VerificationScreen1 extends StatefulWidget {
  @override
  _VerificationScreen1State createState() => _VerificationScreen1State();
}

class _VerificationScreen1State extends State<VerificationScreen1> {
  late List<TextStyle?> otpTextStyles;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Verification Code",
              style: theme.textTheme.headline4,
            ),
            SizedBox(height: 16),
            Text(
              "We texted you a code",
              style: theme.textTheme.headline6,
            ),
            Text("Please enter it below", style: theme.textTheme.headline6),
            Spacer(flex: 2),
            OtpTextField(
              numberOfFields: 5,
              borderColor: Color(0xFF512DA8),
              focusedBorderColor: primaryColor,

              showFieldAsBox: true,
              textStyle: theme.textTheme.subtitle1,
              onCodeChanged: (String value) {},
              onSubmit: (String verificationCode) {
                //navigate to different screen code goes here
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Verification Code"),
                      content: Text('Code entered is $verificationCode'),
                    );
                  },
                );
              }, // end onSubmit
            ),
            Spacer(),
            Center(
              child: Text(
                "Didn't get code?",
                style: theme.textTheme.subtitle1,
              ),
            ),
            Spacer(flex: 3),
            // CustomButton(
            //   onPressed: () {},
            //   title: "Confirm",
            //   color: primaryColor,
            //   textStyle: theme.textTheme.subtitle1?.copyWith(
            //     color: Colors.white,
            //   ),
            // ),
            Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}

class VerificationScreen2 extends StatefulWidget {
  String phoneNumber;

  String email;

  String password;

  VerificationScreen2({
    required this.phoneNumber,
    required this.email,
    required this.password,
  });

  @override
  _VerificationScreen2State createState() => _VerificationScreen2State();
}

class _VerificationScreen2State extends State<VerificationScreen2> {
  late List<TextStyle?> otpTextStyles;

  String? apiToken;

  String? guid;

  String? databody;

  String? otpRefs;
  String statusSus = 'Sucess';
  String failed = 'Failed';
  var reason;

  String otpString = '';

  String myOtp = '';

  @override
  void initState() {
    // TODO: implement initState

    initSharedPrefs().then((val) => getOtp());
    // TODO: implement initState
    super.initState();

    setState(() {
      apiToken = ConstantsVar.prefs.getString('apiTokken');
      guid = ConstantsVar.prefs.getString('guestGUID');
      databody = ConstantsVar.prefs.getString('regBody');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    otpTextStyles = [
      createStyle(accentPurpleColor),
      createStyle(accentYellowColor),
      createStyle(accentDarkGreenColor),
      createStyle(accentOrangeColor),
      createStyle(accentPinkColor),
      createStyle(accentPurpleColor),
    ];
    return SafeArea(

      top: true,
      bottom: true,
      maintainBottomViewPadding: true,
      child: Scaffold(
        appBar: new AppBar(
            backgroundColor: ConstantsVar.appColor,
            toolbarHeight: 18.w,
            centerTitle: true,
            title: Image.asset(
              'MyAssets/logo.png',
              width: 15.w,
              height: 15.w,
            )),
        body: Container(
          // padding: const EdgeInsets.only(left: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: AutoSizeText(
                      "Verification Code".toUpperCase(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 6.5.w),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 4.w),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                ),
                child: AutoSizeText(
                  "We texted you a code",
                  style: theme.textTheme.headline6,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AutoSizeText("Please enter it below",
                    style: theme.textTheme.headline6),
              ),
              Spacer(flex: 2),
              OtpTextField(
                numberOfFields: 6,
                borderColor: Color(0xFF512DA8),
                focusedBorderColor: primaryColor,
                obscureText: true,
                showFieldAsBox: true,
                textStyle: theme.textTheme.subtitle1,
                onCodeChanged: (String value) {},
                onSubmit: (String verificationCode) async {
                  //navigate to different screen code goes here
                  setState(() => myOtp = verificationCode);

                  await verifyOTP(int.parse('$verificationCode')).then((otp) {
                    context.loaderOverlay.hide();
                    // register();
                  });
                }, // end onSubmit
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  getOtp();
                },
                child: Center(
                  child: AutoSizeText(
                    "Didn't get code?",
                    style: theme.textTheme.subtitle1,
                  ),
                ),
              ),
              Spacer(flex: 3),
              Spacer(flex: 2),
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
                            onPressed: () async {
                              setState(() {});
                              //
                              var string = myOtp;

                              setState(() {
                                otpString = string;
                              });
                              print(otpString);
                              if (myOtp.length == 0 ||
                                  myOtp.length < 6 ||
                                  myOtp.length > 6) {
                                Fluttertoast.showToast(
                                    msg: 'Please provide OTP',
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.SNACKBAR);
                              } else {
                                await verifyOTP(int.parse('$otpString'))
                                    .then((otp) {
                                  context.loaderOverlay.hide();
                                  // register();
                                });
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
                                    "VERIFY OTP",
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future getOtp() async {
    context.loaderOverlay.show(
      widget: SpinKitRipple(color: Colors.red, size: 90),
    );
    // await SmsAutoFill().listenForCode;
    // final uri = Uri.parse(
    //    PhoneNumber=${BuildConfig.countryCode}${widget.phoneNumber}');

    final uri = Uri.parse(BuildConfig.base_url + 'customer/SendOTP');
    print(uri);
    final body = {'PhoneNumber': BuildConfig.countryCode + widget.phoneNumber};
    var response = await post(uri, body: body);

    try {
      context.loaderOverlay.hide();
      OtpResponse otpResponse = OtpResponse.fromJson(jsonDecode(response.body));
      if (otpResponse.status.contains('Success')) {
        setState(() {
          otpRefs = otpResponse.responseData.otpReference;
        });
        Fluttertoast.showToast(msg: 'You will receive an otp shortly');
        context.loaderOverlay.hide();
      } else {
        Fluttertoast.showToast(msg: 'Something went wrong!');
        context.loaderOverlay.hide();
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
      context.loaderOverlay.hide();
    }
  }

  void showErrorDialog(String reason) {
    showDialog(
        context: context,
        builder: (context) {
          return CustomDialogBox1(
            descriptions: 'Registration Failed!',
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
            descriptions: 'Registration Successful!',
            text: 'Okay',
            img: 'MyAssets/logo.png',
            isOkay: true,
          );
        });
  }

  Future verifyOTP(int otp) async {
    final body = {
      'PhoneNumber': BuildConfig.countryCode + widget.phoneNumber,
      'otp': Uri.encodeComponent(otp.toString()),
      'otpReference': otpRefs,
    };
    print(body);
    String url2 = BuildConfig.base_url + 'customer/VerifyOTP';
    final url = Uri.parse(url2);
    print(url);

    try {
      var response = await post(url, body: body);

      dynamic result = jsonDecode(response.body);
      context.loaderOverlay.hide();

      print(result);
      if (result['Status'].toString().contains('Failed')) {
        Fluttertoast.showToast(msg: 'Verification failed');
      } else {
        register();
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      context.loaderOverlay.hide();
    }
  }

  Future initSharedPrefs() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
  }

  Future register() async {
    String dataBody = ConstantsVar.prefs.getString('regBody')!;
    print(dataBody);

    String urL = BuildConfig.base_url + 'Customer/CustomerRegister';
    context.loaderOverlay.show(
        widget: SpinKitRipple(
      size: 90,
      color: Colors.red,
    ));
    final body = {'apiToken': apiToken, 'CustomerGuid': guid, 'data': dataBody};
    final url = Uri.parse(urL);

    try {
      var response = await post(url, body: body);
      var result = jsonDecode(response.body);
      print(result);
      String status = result['status'];
      if (status.contains(statusSus)) {
        ApiCalls.login(context, widget.email, widget.password, 'OTP Screen')
            .then((value) {
          context.loaderOverlay.hide();
          showSucessDialog();
        });
      } else if (status.contains(failed)) {
        context.loaderOverlay.hide();

        setState(() => reason = result['Message']);
        showErrorDialog(reason);
        print(result);
      }
    } on Exception catch (e) {
      context.loaderOverlay.hide();
      Fluttertoast.showToast(msg: e.toString());
      print(e.toString());
    }
  }

  TextStyle? createStyle(Color color) {
    ThemeData theme = Theme.of(context);
    return theme.textTheme.headline3?.copyWith(color: color);
  }
}
