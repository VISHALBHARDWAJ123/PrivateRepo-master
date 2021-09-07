import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:fluttertoast/fluttertoast.dart';

// import 'package:untitled2/AppPages/Cart%20Screen/CartScreen2.dart';
import 'package:untitled2/AppPages/CartxxScreen/CartScreen2.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/LoginScreen/LoginScreen.dart';
import 'package:untitled2/AppPages/Registration/RegistrationPage.dart';
import 'package:untitled2/AppPages/Registration/register_page.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/utils/HeartIcon.dart';

enum AniProps { color }

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  var color1 = ConstantsVar.appColor;
  var color2 = Colors.black54;
  late Animation<double> size;
  bool isLoadVisible = false;
  bool isListVisible = false;
  bool isLoading = true;
  TextEditingController _searchController = TextEditingController();

  List<Color> colorList = [
    ConstantsVar.appColor,
    Colors.black26,
    Colors.white60
  ];
  List<Alignment> alignmentList = [
    Alignment.bottomLeft,
    Alignment.bottomRight,
    Alignment.topRight,
    Alignment.topLeft,
  ];
  int index = 0;
  Color topColor = ConstantsVar.appColor;
  Color bottomColor = Colors.black26;
  Alignment begin = Alignment.bottomLeft;
  Alignment end = Alignment.topRight;
  Color btnColor = Colors.black;
  int pageIndex = 0;
  var customerId;

  // var gUId;

  // RefreshController _refreshController = RefreshController();
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    getCustomerId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: new AppBar(
        backgroundColor: ConstantsVar.appColor,
        backwardsCompatibility: true,
        toolbarHeight: 18.w,
        // leading: IconButton(
        //   onPressed: () {},
        //   icon: Icon(Icons.arrow_back),
        // ),
        title: InkWell(
          onTap: () => Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(
                builder: (context) => MyHomePage(),
              ),
              (route) => false),
          child: Image.asset(
            'MyAssets/logo.png',
            width: 15.w,
            height: 15.w,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              width: 100.w,
              height: 100.h,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DelayedDisplay(
                      delay: Duration(milliseconds: 50),
                      slidingBeginOffset: Offset(
                        1,
                        0,
                      ),
                      child: Container(
                        color: Colors.white,
                        height: 25.h,
                        width: 100.w,
                        // color: Colors.black,
                        child: Center(
                          child: Image.asset(
                            'MyAssets/logo.png',
                            width: 45.w,
                            height: 25.h,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // DelayedDisplay(
                  //   delay: Duration(
                  //     seconds: 1,
                  //     microseconds: 100,
                  //   ),
                  //   child: Card(
                  //     color: Colors.white,
                  //
                  //     // color: Colors.white,
                  //     child: Padding(
                  //       padding: EdgeInsets.symmetric(
                  //         vertical: 6.w,
                  //         horizontal: 8.w,
                  //       ),
                  //       child: Row(
                  //         crossAxisAlignment: CrossAxisAlignment.center,
                  //         children: [
                  //           Card(
                  //             child: Icon(
                  //               HeartIcon.user,
                  //               color: ConstantsVar.appColor,
                  //               size: 34,
                  //             ),
                  //           ),
                  //           SizedBox(
                  //             width: 20,
                  //           ),
                  //           Container(
                  //             child: Text(
                  //               'My Account'.toUpperCase(),
                  //               style: TextStyle(
                  //                 color: Colors.black,
                  //                 fontSize: 5.w,
                  //                 fontWeight: FontWeight.bold,
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  DelayedDisplay(
                    delay: Duration(
                      milliseconds: 70,
                    ),
                    child: InkWell(
                      onTap: () => Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => CartScreen2())),
                      child: Card(
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 6.w,
                            horizontal: 8.w,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Card(
                                child: Icon(
                                  Icons.shopping_cart,
                                  color: ConstantsVar.appColor,
                                  size: 34,
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                // color: Colors.white,
                                child: Text(
                                  'My Cart'.toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 5.w,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  DelayedDisplay(
                    delay: Duration(
                      milliseconds: 70,
                    ),
                    child: Card(
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 6.w,
                          horizontal: 8.w,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Card(
                              child: Icon(
                                Icons.notifications,
                                color: ConstantsVar.appColor,
                                size: 34,
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              // color: Colors.white,
                              child: Text(
                                'notifications'.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 5.w,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  DelayedDisplay(
                    delay: Duration(
                      milliseconds: 70,
                    ),
                    child: InkWell(
                      onTap: () {
                        customerId == '' || customerId == null
                            ? Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => RegstrationPage()))
                            : Fluttertoast.showToast(
                                msg: 'You Already Login with The One Account',
                                toastLength: Toast.LENGTH_LONG,
                              );
                      },
                      child: Card(
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 6.w,
                            horizontal: 8.w,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Card(
                                child: Icon(
                                  HeartIcon.user,
                                  color: ConstantsVar.appColor,
                                  size: 34,
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                // color: Colors.white,
                                child: Text(
                                  'Register'.toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 5.w,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  DelayedDisplay(
                    delay: Duration(
                      milliseconds: 70,
                    ),
                    child: InkWell(
                      onTap: () {
                        if (customerId == '' || customerId == null) {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => LoginScreen()));
                        } else {
                          clearUserDetails()
                              .then((value) => Phoenix.rebirth(context));
                        }
                      },
                      child: Card(
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 6.w,
                            horizontal: 8.w,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Card(
                                child: Icon(
                                  HeartIcon.logout,
                                  color: ConstantsVar.appColor,
                                  size: 34,
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                // color: Colors.white,
                                child: Text(
                                  customerId == '' || customerId == null
                                      ? 'login'.toUpperCase()
                                      : 'logout'.toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 5.w,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future getCustomerId() async {
    customerId = ConstantsVar.prefs.getString('userId')!;
    print(ConstantsVar.customerID);
  }

  Future clearUserDetails() async {
    ConstantsVar.prefs.clear();
  }
}
