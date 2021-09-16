import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class NotificationClass extends StatelessWidget {
  const NotificationClass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
            appBar: new AppBar(
              toolbarHeight: 18.w,
              centerTitle: true,
              title: InkWell(
                child: Image.asset(
                  'MyAssets/logo.png',
                  width: 15.w,
                  height: 15.w,
                ),
              ),
            ),
            body: Container(
              child: Center(
                child: Text('No new notifications.'),
              ),
            )));
  }
}
