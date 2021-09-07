import 'dart:async';

import 'package:flutter/material.dart';

class EmailClass extends StatefulWidget {
  const EmailClass({Key? key}) : super(key: key);

  @override
  _EmailClassState createState() => _EmailClassState();
}

class _EmailClassState extends State<EmailClass> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(new Duration(seconds: 8), () {
      debugPrint("Launching Login Screen");
      Navigator.of(context).popAndPushNamed('/LoginScreen');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Text(
            'A Link Has been send to your Email.\n Please check your Email'),
      ),
    );
  }
}
