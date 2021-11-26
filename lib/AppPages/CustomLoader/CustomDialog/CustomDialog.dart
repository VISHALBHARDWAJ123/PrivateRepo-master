import 'dart:ui';

// import 'package:custom_dialog_flutter_demo/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

// import 'package:untitled2/AppPages/CartxxScreen/ConstantVariables.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/LoginScreen/LoginScreen.dart';
import 'package:untitled2/AppPages/OtP/OTPScreen.dart';
import 'package:untitled2/AppPages/Registration/RegistrationPage.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';

class CustomDialogBox extends StatefulWidget {
  final String descriptions, text;
  final String img;
  final bool isOkay;

  // final Route route;

  const CustomDialogBox({
    Key? key,
    required this.isOkay,
    // required this.title,
    required this.descriptions,
    required this.text,
    required this.img,
    // required this.route,
  }) : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding:
              EdgeInsets.only(left: 20, top: 45 + 20, right: 20, bottom: 20),
          margin: EdgeInsets.only(top: 45),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AutoSizeText(
                widget.descriptions,
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 6,
              ),
              AutoSizeText(
                widget.text.contains('Not Go') ? '' : widget.text,
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 22,
              ),
              Align(
                alignment: Alignment.center,
                child: Visibility(
                  visible: widget.isOkay,
                  child: FlatButton(
                      color: Colors.black,
                      onPressed: () {
                        widget.text == 'Not Go'
                            ? Navigator.pop(context)
                            : Navigator.pushAndRemoveUntil(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => MyHomePage(
                                          pageIndex: 0,
                                        )),
                                (route) => false);
                      },
                      child: Container(
                        color: Colors.black,
                        child: AutoSizeText(
                          'OKAY',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 20,
          right: 20,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 45,
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(45)),
                child: Image.asset("MyAssets/logo.png")),
          ),
        ),
      ],
    );
  }
}

class CustomDialogBox1 extends StatefulWidget {
  final String descriptions, text;
  final String img;
  final String reason;

  // final Route route;

  const CustomDialogBox1({
    Key? key,
    // required this.title,
    required this.descriptions,
    required this.text,
    required this.img,
    required this.reason,
    // required this.route,
  }) : super(key: key);

  @override
  _CustomDialogBoxState1 createState() => _CustomDialogBoxState1();
}

class _CustomDialogBoxState1 extends State<CustomDialogBox1> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding:
              EdgeInsets.only(left: 20, top: 45 + 20, right: 20, bottom: 20),
          margin: EdgeInsets.only(top: 45),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AutoSizeText(
                widget.reason.length == 0
                    ? widget.descriptions
                    : widget.descriptions +
                        '!' +
                        '\n' +
                        '${widget.reason + '.'}',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 22,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                    color: Colors.black,
                    onPressed: () async {
                      ConstantsVar.prefs =
                          await SharedPreferences.getInstance();
                      ConstantsVar.prefs.setString('regBody', '');
                      Navigator.of(context).pop();
                    },
                    child: AutoSizeText(
                      widget.text,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    )),
              ),
            ],
          ),
        ),
        Positioned(
          left: 20,
          right: 20,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 45,
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(45)),
                child: Image.asset("MyAssets/logo.png")),
          ),
        ),
      ],
    );
  }
}
