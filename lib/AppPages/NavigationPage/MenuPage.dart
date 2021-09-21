import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:untitled2/AppPages/Cart%20Screen/CartScreen2.dart';
import 'package:untitled2/AppPages/CartxxScreen/CartScreen2.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/LoginScreen/LoginScreen.dart';
import 'package:untitled2/AppPages/MyAccount/MyAccount.dart';
import 'package:untitled2/AppPages/NotificationxxScreen/Notification_Screen.dart';
import 'package:untitled2/AppPages/Registration/RegistrationPage.dart';
import 'package:untitled2/AppPages/Registration/register_page.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/utils/HeartIcon.dart';
// import 'package:untitled2/utils/utils/colors.dart';

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
  var userName, email, phnNumber;

  bool isEmailVisible = true, isPhoneNumberVisible = true;

  // var gUId;

  // RefreshController _refreshController = RefreshController();
  @override
  void initState() {
    // TODO: implement initState
    getCustomerId();
    setState(() {
      customerId = ConstantsVar.prefs.getString('userId');
      email = ConstantsVar.prefs.getString('email');
      userName = ConstantsVar.prefs.getString('userName');
      phnNumber = ConstantsVar.prefs.getString('phone');
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              color: Colors.white,
              width: 100.w,
              height: 100.h,
              child: ListView(
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 2.w, horizontal: 4.w),
                        child: DelayedDisplay(
                          delay: Duration(milliseconds: 50),
                          slidingBeginOffset: Offset(
                            -1,
                            0,
                          ),
                          child: Container(
                            color:Colors.white,
                            width: 100.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.0),
                                  child: Container(
                                    width: 100.w,
                                    child: Center(
                                      child: Text(
                                        'Welcome',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 8.5.w,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 100.w,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 100.w,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Visibility(
                                              visible: userName == null ? false : true,
                                              child: Icon(
                                                Icons.person,
                                                color: ConstantsVar.appColor,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Visibility(
                                              visible: userName == null ? false : true,
                                              child: Text(
                                                userName == null ? '' : userName,
                                                style: TextStyle(
                                                  color: Colors.grey.shade700,
                                                  fontSize: 5.w,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Visibility(
                                        visible: email == null ? false : true,
                                        child: Container(
                                          width: 100.w,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Icon(
                                                Icons.email,
                                                color: ConstantsVar.appColor,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                email == null ? '' : email,
                                                style: TextStyle(
                                                  color: Colors.grey.shade700,
                                                  fontSize: 5.w,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Visibility(
                                        visible: phnNumber == null ? false : true,
                                        child: Container(
                                          width: 100.w,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Icon(Icons.phone,
                                                  color: ConstantsVar.appColor),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                phnNumber == null ? '' : phnNumber,
                                                style: TextStyle(
                                                  color: Colors.grey.shade700,
                                                  fontSize: 5.w,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  DelayedDisplay(
                    delay: Duration(
                      milliseconds: 70,
                    ),
                    child: InkWell(
                      onTap: () => Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => MyAccount())),
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
                                  Icons.account_circle_sharp,
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
                                  'My Account'.toUpperCase(),
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
                    child: InkWell(
                      onTap: () => Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => NotificationClass())),
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
                              .whenComplete(() => Phoenix.rebirth(context));
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
    ConstantsVar.prefs = await SharedPreferences.getInstance().whenComplete(() {
      print('customerId ==>>' + ConstantsVar.customerID);
    });
  }

  void getUserCreds() async {
    print(userName + email + phnNumber);

    if (email == '') {
      setState(() {
        isEmailVisible = false;
        email = '';
      });
    }
    if (userName == '') {
      setState(() {
        userName =
            'Guestuser' + ConstantsVar.prefs.getString('guestCustomerID')!;

        print(userName);
      });
    }
    if (phnNumber == '') {
      setState(() {
        isPhoneNumberVisible = false;
        phnNumber = '';
      });
    }
  }

  Future clearUserDetails() async {
    ConstantsVar.prefs.clear();
  }
}

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
