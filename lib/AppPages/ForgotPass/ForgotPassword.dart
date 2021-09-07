import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:untitled2/AppPages/Registration/RegistrationPage.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/Widgets/widgets/AppBar.dart';

// import 'package:untitled2/utils/ApiCalls/ApiCall.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';
import 'package:untitled2/utils/CustomDialog/CustomxxLoginxxCheck.dart';

class ForgotPassScreen extends StatefulWidget {
  const ForgotPassScreen({
    Key? key,
  }) : super(key: key);

  @override
  _ForgotPassScreenState createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  TextEditingController emailController = TextEditingController();

  // TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          toolbarHeight: 18.w,
          title: Image.asset(
            'MyAssets/logo.png',
            width: 15.w,
            height: 15.w,
          ),
        ),
        extendBodyBehindAppBar: false,
        resizeToAvoidBottomInset: true,
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Container(
            width: ConstantsVar.width,
            height: ConstantsVar.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: AppBarLogo('RECOVER PASSWORD', context),
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'ENTER YOUR EMAIL',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: ConstantsVar.textSize,
                              fontWeight: FontWeight.bold),
                          softWrap: false,
                          // maxLines: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: ListTile(
                            title: TextFormField(
                              maxLines: 1,
                              textAlign: TextAlign.start,
                              controller: emailController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              cursorColor: Colors.black,
                              // validator: (input) => input!.isValidEmail()
                              //     ? null
                              //     : "Check your Email",
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  suffixText: '*',
                                  counterText: '',
                                  border: OutlineInputBorder(gapPadding: 2),
                                  errorText: emailController.text.length == 0
                                      ? 'Please Enter Your Email'
                                      : null,
                                  focusColor: Colors.black,
                                  hintText: "E-Mail Address",
                                  hintStyle: TextStyle(color: Colors.black),
                                  errorStyle: TextStyle(color: Colors.black)),
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
                    width: ConstantsVar.width,
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
                                height: 60,
                                width: ConstantsVar.width / 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Center(
                                    child: Text(
                                      "CANCEL",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                        ),
                        Expanded(
                          child: RaisedButton(
                              onPressed: () {
                                context.loaderOverlay.show(
                                    widget: SpinKitRipple(
                                  color: Colors.red,
                                  size: 90,
                                ));
                                if (emailController.text.length == 0) {
                                  ConstantsVar.showSnackbar(
                                      context, 'Please Provide Email', 5);
                                } else if (RegExp(ConstantsVar.email_Pattern)
                                    .hasMatch(emailController.text)) {
                                  ApiCalls.forgotPass(
                                          context, emailController.text)
                                      .whenComplete(() {
                                    context.loaderOverlay.hide();
                                    return showDialog(
                                      context: context,
                                      builder: (_) => loginCheck(),
                                    );
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
                                      'CONFIRM',
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
}
