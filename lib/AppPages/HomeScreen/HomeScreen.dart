import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:loader_overlay/loader_overlay.dart';
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
import 'package:untitled2/utils/mobX/MobXBtmNav.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            appBarTheme: AppBarTheme(
              backgroundColor: ConstantsVar.appColor,
            )),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
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

  List<Widget> viewsList = [
    Container(
      child: HomeScreenMain(
          // key: PageStorageKey('HomeScreenMain'),
          ),
    ),
    HomeCategory(
        // key: PageStorageKey('HomeCategory'),
        ),
    SearchPage(
        // key: PageStorageKey('SearchPage'),
        ),
    CartScreen2(
        // key: PageStorageKey('CartScreen2'),
        ),
    MenuPage(
        // key: PageStorageKey('MenuPage'),
        ),
  ];

  // DateTime currentBackPressTime = DateTime.now();

  // int activeIndex = 0;

  // void backToHomePage() {
  //   setState(() {
  //     activeIndex = ConstantsVar.selectedIndex;
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSharedPrefs();
    // _controller = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
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
          body: viewsList.elementAt(activeIndex),
          bottomNavigationBar: Container(
            color: Colors.black,
            height: 50,
            child: Observer(
              builder: (_) => RollingNavBar.iconData(
                activeIndex: activeIndex,
                iconData: <IconData>[
                  Icons.home_filled,
                  Icons.shopping_bag,
                  Icons.search,
                  Icons.shopping_cart,
                  Icons.menu,
                ],
                indicatorColors: <Color>[
                  Colors.red,
                  Colors.red,
                  Colors.red,
                  Colors.red,
                  Colors.red,
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
      ),
    );
  }

  void initSharedPrefs() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
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
        return SearchPage();
      case 3:
        return CartScreen2();
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
