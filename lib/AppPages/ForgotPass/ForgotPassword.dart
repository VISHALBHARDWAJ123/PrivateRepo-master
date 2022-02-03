// ignore_for_file: deprecated_member_use

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:progress_loading_button/progress_loading_button.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:untitled2/AppPages/CustomLoader/CustomDialog/CustomDialog.dart';
import 'package:untitled2/AppPages/Registration/RegistrationPage.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/Widgets/widgets/AppBar.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';
import 'package:untitled2/utils/utils/colors.dart';

class ForgotPassScreen extends StatefulWidget {
  const ForgotPassScreen({
    Key? key,
  }) : super(key: key);

  @override
  _ForgotPassScreenState createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen>
    with InputValidationMixin {
  TextEditingController emailController = TextEditingController();

  // TextEditingController otpController = TextEditingController();
  GlobalKey<FormState> _forgotState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      maintainBottomViewPadding: true,
      child: Scaffold(
        appBar: new AppBar(
          backgroundColor: ConstantsVar.appColor,
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
          child: Form(
            key: _forgotState,
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
                          child: AutoSizeText(
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
                          padding: const EdgeInsets.only(top: 40.0,left: 30,right: 30),
                          child:               Card(
                            // color: Colors.white60,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                12.0,
                              ),
                            ),
                            elevation: 2.0,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: Container(

                                width: 90.w,
                                child: TextFormField(

                                  autofocus: true,
                                  textInputAction: TextInputAction.next,
                                  keyboardType:
                                  TextInputType.emailAddress,
                                  validator: (val) {
                                    if (isEmailValid(val!)) {
                                      return null;
                                    }
                                    return 'Please enter a valid email address!';
                                  },
                                  cursorColor: ConstantsVar.appColor,

                                  controller: emailController,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.0,
                                  ),
                                  decoration: editBoxDecoration(
                                      'E-mail Address',
                                      Icon(
                                        Icons.email,
                                        color:
                                        AppColor.PrimaryAccentColor,
                                      ),
                                      false),
                                ),
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
                                  height: 50,
                                  width: ConstantsVar.width / 2,
                                  child: Center(
                                    child: AutoSizeText(
                                      "CANCEL",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                )),
                          ),
                          Expanded(
                              child: Container(
                                color: ConstantsVar.appColor,
                                child: LoadingButton(
                                  height: 50,
                                  onPressed: () async {
                                    if (_forgotState.currentState!.validate()) {
                                      _forgotState.currentState!.save();
                                      await ApiCalls.forgotPass(
                                          context, emailController.text)
                                          .then((val) {
                                        context.loaderOverlay.hide();
                                        return showDialog(
                                          context: context,
                                          builder: (_) => CustomDialogBox(
                                            descriptions: val,
                                            text: 'Not Go',
                                            isOkay: true,
                                            img: 'MyAssets/logo.png',
                                          ),
                                        );
                                      });
                                    } else {}
                                  },
                                  color: ConstantsVar.appColor,
                                  loadingWidget: SpinKitCircle(
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  defaultWidget: AutoSizeText(
                                    'CONFIRM',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                  )
                ],
              ),
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
        labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
        labelText: name,
        border: InputBorder.none);
  }
}
