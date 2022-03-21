import 'dart:async';
import 'dart:collection';
import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:rolling_nav_bar/rolling_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:untitled2/AppPages/Cart%20Screen/CartScreen2.dart';
import 'package:untitled2/AppPages/CartxxScreen/CartScreen2.dart';
import 'package:untitled2/AppPages/HomeCategory/HomeCategory.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreenMain/home_screen_main.dart';
import 'package:untitled2/AppPages/NavigationPage/MenuPage.dart';
import 'package:untitled2/AppPages/SearchPage/SearchPage.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/PojoClass/GridViewModel.dart';
import 'package:untitled2/PojoClass/itemGridModel.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';
import 'package:untitled2/utils/CartBadgeCounter/CartBadgetLogic.dart';
import 'package:untitled2/utils/mobX/MobXBtmNav.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // AwesomeNotifications().

  Future<void> setFireStoreData(
    RemoteMessage message,
  ) async {
    // AwesomeNotifications().createNotificationFromJsonData(message.data);
    final refrence = FirebaseFirestore.instance.collection('UserNotifications');
    String formattedDate =
        DateFormat('dd-MM-yyyy – hh:mm').format(message.sentTime!);
    Map<String, dynamic> data = {
      'Title': message.notification!.title,
      'Desc': message.notification!.body,
      'Time':Timestamp.fromDate(message.sentTime!)
    };
    refrence.add(data);
  }

  Future<void> _messageHandler(RemoteMessage message) async {
    // var guestGuid = ConstantsVar.prefs.getString('sepGuid');

    setFireStoreData(
      message,
    );
    print('background message ${message.notification!.body}');
    print('background message message got ');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      FirebaseMessaging.instance;
      FirebaseMessaging.onBackgroundMessage(_messageHandler);
    });
    // AwesomeNotifications()
    //     .actionStream
    //     .listen((ReceivedNotification receivedNotification) {
    //   if (receivedNotification.channelKey!
    //       .contains('Remove from Wishlist Notification')) {
    //     Navigator.pushReplacement(
    //         context,
    //         CupertinoPageRoute(
    //             builder: (context) => NewProductDetails(
    //                   productId: receivedNotification.id,
    //                   screenName: 'Notification',
    //                 )));
    //   } else if (receivedNotification.channelKey!
    //       .contains('Add to Cart Notification')) {
    //     Navigator.pushAndRemoveUntil(
    //         context,
    //         CupertinoPageRoute(
    //             builder: (context) => MyHomePage(
    //                   pageIndex: 3,
    //                 )),
    //         (route) => false);
    //   } else if (receivedNotification.channelKey!
    //       .contains('Add to Wishlist Notification')) {
    //     Navigator.pushReplacement(
    //       context,
    //       CupertinoPageRoute(
    //         builder: (context) => WishlistScreen(),
    //       ),
    //     );
    //   }
    // });
    getCartBagdge(0);
  }

  Future getCartBagdge(int val) async {
    ApiCalls.readCounter(
            customerGuid: ConstantsVar.prefs.getString('guestGUID')!)
        .then((value) {
      if (mounted) {
        context.read<cartCounter>().changeCounter(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: FlutterSizer(
        builder: (context, ori, deviceType) => MyHomePage(
          pageIndex: 0,
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({required this.pageIndex});

  int pageIndex;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with AutomaticKeepAliveClientMixin {
  List<GridViewModel> mList = [];
  final counter = Counter();
  List<GridPojo> mList1 = [];
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final PageStorageBucket bucket = PageStorageBucket();
  var activeIndex = 0;

  ListQueue<int> _navQueue = new ListQueue();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSharedPrefs().then((value) => getCartBagdge(0));

    setState(() => activeIndex = widget.pageIndex);
    // _controller = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      maintainBottomViewPadding: true,
      child: WillPopScope(
        onWillPop: () async {
          //
          if (activeIndex == 0) return true;
          setState(() {
            activeIndex = 0;
          });

          return false;

          //>....<//
          if (_navQueue.isEmpty) return true;
          setState(() {
            activeIndex = _navQueue.last;
            _navQueue.removeLast();
          });

          return false;
        },
        child: Scaffold(
          // transitionBackgroundColor: Colors.black54,
          key: _scaffoldKey,
          body: PageTransitionSwitcher(
            transitionBuilder: (
              Widget child,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) {
              return FadeThroughTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                child: child,
              );
            },
            child: getBodies(activeIndex),
          ),
          bottomNavigationBar: Container(
            color: Colors.black,
            height: 50,
            child: RollingNavBar.iconData(
              activeIconColors: [
                Colors.white,
                Colors.white,
                Colors.white,
                Colors.white,
                Colors.white,
              ],
              activeIndex: activeIndex,
              badges: [
                null,
                null,
                null,
                Consumer<cartCounter>(builder: (context, value, child) {
                  return Text(
                    value.badgeNumber.toString(),
                    style: TextStyle(
                      fontSize: 8,
                      color: Colors.white,
                    ),
                  );
                }),
                null
              ],
              iconData: <IconData>[
                Icons.home_filled,
                Icons.shopping_bag,
                Icons.search,
                Icons.shopping_cart,
                Icons.menu,
              ],
              indicatorColors: <Color>[
                ConstantsVar.appColor,
                ConstantsVar.appColor,
                ConstantsVar.appColor,
                ConstantsVar.appColor,
                ConstantsVar.appColor,
              ],
              iconText: <Widget>[
                Text('Home',
                    style: TextStyle(color: Colors.black, fontSize: 11)),
                Text('Products',
                    style: TextStyle(color: Colors.black, fontSize: 11)),
                Text('Search',
                    style: TextStyle(color: Colors.black, fontSize: 11)),
                Text('Cart',
                    style: TextStyle(color: Colors.black, fontSize: 11)),
                Text('Profile',
                    style: TextStyle(color: Colors.black, fontSize: 11)),
              ],
              onTap: (index) {
                setState(() {
                  activeIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  Future initSharedPrefs() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
  }

  Future getCartBagdge(int val) async {
    ApiCalls.readCounter(
            customerGuid: ConstantsVar.prefs.getString('guestGUID')!)
        .then((value) {
      setState(() {
        context.read<cartCounter>().changeCounter(value);
      });
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;

  Widget getBodies(int index) {
    switch (index) {
      case 0:
        return HomeScreenMain();
      case 1:
        return HomeCategory();
      case 2:
        return SearchPage(
          keyword: '',
          isScreen: false,
          enableCategory: true,
        );
      case 3:
        return CartScreen2(
          isOtherScren: false,
          otherScreenName: '',
        );
      case 4:
        return MenuPage();
      default:
        return Container(
          child: Center(
            child: Text('Wrong Route'),
          ),
        );
    }
  }
}
