import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/utils/utils/build_config.dart';

class ReturnScreen extends StatefulWidget {
  const ReturnScreen({Key? key}) : super(key: key);

  @override
  _ReturnScreenState createState() => _ReturnScreenState();
}

class _ReturnScreenState extends State<ReturnScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRetrunableItems();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      child: Scaffold(
        appBar: new AppBar(
          backgroundColor: ConstantsVar.appColor,
          title: InkWell(
            onTap: () => Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(
                  builder: (context) => MyHomePage(
                    pageIndex: 0,
                  ),
                ),
                (route) => false),
            child: Image.asset(
              'MyAssets/logo.png',
              width: 15.w,
              height: 15.w,
            ),
          ),
          centerTitle: true,
          toolbarHeight: 18.w,
        ),
        body: Container(
            height: 100.h,
            width: 100.w,
            child: Center(child: Text('Order Return Screen.'))),
      ),
    );
  }

  void getRetrunableItems() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
    var apiToken = ConstantsVar.prefs.getString('key');
    var customerId = ConstantsVar.prefs.getString('key');

    final url = Uri.parse(BuildConfig.base_url+'apis/GetReturnRequests?apiToken=$apiToken&customerid=$customerId');
  }
}
