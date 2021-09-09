import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/AppPages/CustomLoader/CustomDialog/CustomDialog.dart';
import 'package:untitled2/AppPages/OtP/OTP_Response.dart';
import 'package:untitled2/AppPages/OtP/OTP_Verify_Response.dart';

// import 'package:sms_autofill/sms_autofill.dart';
import 'package:untitled2/AppPages/Registration/RegistrationPage.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/Widgets/widgets/AppBar.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';
import 'package:untitled2/utils/utils/build_config.dart';

class OTP_Screen extends StatefulWidget {
  final String email;
  final password;

  OTP_Screen({
    Key? key,
    required this.title,
    // required this.otpController,
    required this.mainBtnTitle,
    required this.phoneNumber,
    required this.email,
    required this.password,
  }) : super(key: key);
  final String title;
  final phoneNumber;

  final String mainBtnTitle;

  @override
  _OTP_ScreenState createState() => _OTP_ScreenState();
}

class _OTP_ScreenState extends State<OTP_Screen> {
  var otpString;

  String appSign = '';

  var reason;

  @override
  void initState() {
    initSharedPrefs().then((val) => getOtp());
    // TODO: implement initState
    super.initState();
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
    try {
      var response = await post(uri, body: body);

      OtpResponse otpResponse = OtpResponse.fromJson(jsonDecode(response.body));
      Fluttertoast.showToast(msg: otpResponse.status);
    } on Exception catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
      context.loaderOverlay.hide();
    }
  }

  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
          toolbarHeight: 18.w,
          centerTitle: true,
          title: Image.asset(
            'MyAssets/logo.png',
            width: 15.w,
            height: 15.w,
          )),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: SafeArea(
          top: true,
          bottom: true,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: AppBarLogo(widget.title, context),
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            'ENTER OTP ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: ConstantsVar.textSize,
                                fontWeight: FontWeight.w500),
                            softWrap: false,
                            // maxLines: 1,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: Container(
                          margin: EdgeInsets.only(left: 40, right: 40),
                          child: ListTile(
                            trailing: Text(
                              '*',
                              style: TextStyle(color: ConstantsVar.appColor),
                            ),
                            title: TextField(
                              maxLength: 6,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.done,
                              controller: otpController,
                              // autovalidateMode:
                              //     AutovalidateMode.onUserInteraction,
                              cursorColor: Colors.black,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: ConstantsVar.textFieldSize),
                              decoration: InputDecoration(
                                  counterText: '',
                                  contentPadding: EdgeInsets.all(2),
                                  border: OutlineInputBorder(
                                    gapPadding: 2,
                                  ),
                                  errorStyle: TextStyle(
                                      color: Colors.black, fontSize: 14.0)),
                            ),
                          ),
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
                                Navigator.pop(
                                  context,
                                );
                              },
                              color: ConstantsVar.appColor,
                              shape: RoundedRectangleBorder(),
                              child: SizedBox(
                                height: 60,
                                width: MediaQuery.of(context).size.width / 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Center(
                                    child: Text(
                                      "CANCEL",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0),
                                    ),
                                  ),
                                ),
                              )),
                        ),
                        Expanded(
                          child: RaisedButton(
                              onPressed: () async {
                                // setState(() {});

                                var string = otpController.text.toString();

                                setState(() {
                                  otpString = string;
                                });
                                print(otpString);
                                if (otpController.text.length == 0) {
                                  Fluttertoast.showToast(
                                      msg: 'Please provide OTP',
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.SNACKBAR);
                                } else {
                                  context.loaderOverlay.show(
                                      widget: SpinKitRipple(
                                          size: 90, color: Colors.red));
                                  await verifyOTP(
                                          '${ConstantsVar.prefs.getString('hashOTP')}',
                                          otpString)
                                      .then((otp) {
                                    context.loaderOverlay.hide();
                                    register();
                                  });
                                }
                              },
                              color: ConstantsVar.appColor,
                              shape: RoundedRectangleBorder(),
                              child: SizedBox(
                                height: 60,
                                width: MediaQuery.of(context).size.width / 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Center(
                                    child: Text(
                                      widget.mainBtnTitle,
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

  void showErrorDialog(String reason) {
    showDialog(
        context: context,
        builder: (context) {
          return CustomDialogBox1(
            descriptions: 'Registration failed',
            text: 'Okay',
            img: 'MyAssets/logo.png',
            reason: '',
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
          );
        });
  }

  Future verifyOTP(String hashOTP, String otp) async {
    final body = {
      'PhoneNumber': BuildConfig.countryCode + widget.phoneNumber,
      'otp': otp,
    };
    String url2 = BuildConfig.base_url + 'customer/VerifyOTP';
    final url = Uri.parse(url2);
    print(url2);
    try {
      var response = await post(url, body: body);
      OtpVerifyResponse model =
          OtpVerifyResponse.fromJson(jsonDecode(response.body));
      if (model.status.contains('Success')) {
        register();
      } else {}
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future initSharedPrefs() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
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
        ApiCalls.login(context, widget.email,
                Uri.encodeComponent(widget.password))
            .then((value) {
          context.loaderOverlay.hide();
          showSucessDialog();
        });
      } else {
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
}
