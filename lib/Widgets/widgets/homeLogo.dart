import 'package:flutter/material.dart';
import 'package:untitled2/AppPages/LoginScreen/LoginScreen.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/utils/HeartIcon.dart';

Widget homeLogo(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('MyAssets/top-background.png'),
            fit: BoxFit.cover),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        )),
    child: Padding(
      padding: const EdgeInsets.all(24.0),
      child: Align(
        alignment: Alignment.center,
        child: Container(
          height: 70,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                child: Image.asset(
                  'MyAssets/logo.png',
                  width: 75.0,
                  height: 75.0,
                ),
              ),
              Positioned(
                top: 1,
                right: 1,
                child: InkWell(
                  onTap: () {
                    ConstantsVar.prefs.clear();
                    Navigator.of(context)
                        .pushReplacement(MaterialPageRoute(builder: (context) {
                      return LoginScreen();
                    }));
                  },
                  child: Icon(HeartIcon.logout, color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}
