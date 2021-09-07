import 'package:flutter/material.dart';
import 'package:untitled2/AppPages/CartxxScreen/ConstantVariables.dart';
import 'package:untitled2/AppPages/LoginScreen/LoginScreen.dart';

class loginCheck extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => loginCheckState();
}

class loginCheckState extends State<loginCheck>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(15.0),
              height: 180.0,
              decoration: ShapeDecoration(
                  color: ConstantsVar.appColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0))),
              child: Column(
                children: <Widget>[
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(
                        top: 30.0, left: 20.0, right: 20.0),
                    child: Text(
                      "Email with instructions has been sent to you.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                  )),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ButtonTheme(
                        height: 35.0,
                        minWidth: 110.0,
                        child: RaisedButton(
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          splashColor: Colors.white.withAlpha(40),
                          child: Text(
                            'okay',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13.0),
                          ),
                          onPressed: () {
                            setState(() {
                              Route route = MaterialPageRoute(
                                  builder: (context) => LoginScreen());
                              Navigator.pop(context, route);
                            });
                          },
                        )),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
