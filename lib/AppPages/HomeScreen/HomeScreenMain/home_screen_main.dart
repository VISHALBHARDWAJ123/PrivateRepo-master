import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/AppPages/Categories/ProductList/SubCatProducts.dart';
import 'package:untitled2/AppPages/NewSubCategoryPage/NewSCategoryPage.dart';
import 'package:untitled2/AppPages/StreamClass/NewPeoductPage/NewProductScreen.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/utils/models/homeresponse.dart';
import 'package:untitled2/utils/utils/build_config.dart';
import 'package:untitled2/utils/utils/colors.dart';
import 'package:untitled2/utils/utils/general_functions.dart';

class HomeScreenMain extends StatefulWidget {
  _HomeScreenMainState createState() => _HomeScreenMainState();

  HomeScreenMain({Key? key}) : super(key: key);
}

class _HomeScreenMainState extends State<HomeScreenMain> {
  String bannerImage = '';

  List<Bannerxx> banners = [];
  List<HomePageCategoriesImage> categoryList = [];
  List<HomePageProductImage> productList = [];
  AssetImage assetImage = AssetImage("MyAssets/imagebackground.png");
  List<Widget> viewsList = [];
  int activeIndex = 0;
  bool showLoading = false;
  bool categoryVisible = false;

  @override
  void initState() {
    super.initState();

    getApiToken().then((value) => apiCallToHomeScreen(value));
  }

  @override
  void didUpdateWidget(covariant HomeScreenMain oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    buildSafeArea(context);
  }

  // @override
  // void didUpdateWidget (
  //     )
  //
  @override
  Widget build(BuildContext context) {
    return SafeArea(top: true, child: Scaffold(body: buildSafeArea(context)));
  }

  Widget buildSafeArea(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
          overflow: Overflow.visible,
          clipBehavior: Clip.hardEdge,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: Container(
                      height: 30.h,
                      child: Image.asset(
                        "MyAssets/imagebackground.png",
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  ),
                  ListView(
                    // physics: NeverScrollableScrollPhysics(),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 6),
                        child: Container(
                          width: 100.w,
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Image.asset('MyAssets/logo.png',
                                fit: BoxFit.fill,
                                width: Adaptive.w(18),
                                height: Adaptive.w(18)),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              left: 4,
                              right: 4,
                            ),
                            child: CarouselSlider(
                              options: CarouselOptions(
                                  // enlargeStrategy: CenterPageEnlargeStrategy.height,
                                  disableCenter: true,
                                  pageSnapping: true,
                                  height: 24.h,
                                  viewportFraction: 1,
                                  // aspectRatio: 4 / 3,
                                  autoPlay: true,
                                  enlargeCenterPage: false),
                              items: banners.map((banner) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return InkWell(
                                      onTap: () {
                                        String type = banner.type;

                                        if (type.contains('Category')) {
                                          Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (context) => ProductList(
                                                  categoryId: banner.id,
                                                  title: ''),
                                            ),
                                          );
                                        }
                                      },
                                      child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 2.0),
                                          child: Container(
                                            child: CachedNetworkImage(
                                              imageUrl: banner.imageUrl,
                                              fit: BoxFit.fill,
                                              placeholder: (context, reason) =>
                                                  Center(
                                                child: SpinKitRipple(
                                                  color: Colors.red,
                                                  size: 90,
                                                ),
                                              ),
                                            ),
                                          )),
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                          Container(
                            height: 29.5.h,
                              // margin: EdgeInsets.only(top: 20.0, left: 10, right: 10),
                              // height: Adaptive.h(24),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                        padding: EdgeInsets.all(8),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: productList.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return listContainer(
                                              productList[index]);
                                        }),
                                  ),
                                ],
                              )),
                          Visibility(
                            visible: categoryVisible,
                            child: Container(
                              color: Colors.white,
                              padding: EdgeInsets.all(10),
                              // margin: EdgeInsets.all(10),
                              child: Column(children: viewsList),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            Visibility(
              visible: showLoading,
              child: Positioned.fill(
                child: Align(
                    alignment: Alignment.centerRight, child: showloader()),
              ),
            ),
          ]),
    );
  }

  // Stack homeView(){
  //   return
  // }

  InkWell listContainer(HomePageProductImage list) {
    return InkWell(
      onTap: () {
        print('${list.id}');
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return new NewProductDetails(
            // customerId: ConstantsVar.customerID,
            productId: list.id,
          );
        }));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        // height: Adaptive.w(50),
        // color: Colors.white60,
        width: Adaptive.w(32),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: Container(

                color: Colors.white,
                height: 16.h,
                // width: Adaptive.w(32),
                // height: Adaptive.w(40),
                child: Card(
                  elevation: 20,
                  child: CachedNetworkImage(
                      imageUrl: list.imageUrl[0], fit: BoxFit.fill,),
                ),
              ),
            ),
            addVerticalSpace(4.0),
            Padding(
              padding: EdgeInsets.only(left: 12, right: 12),
              child: Center(
                child: Text(
                  list.name.toUpperCase(),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            addVerticalSpace(1.0),
            Text(
              list.price,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  /* Api call to home screen */
  Future<http.Response> apiCallToHomeScreen(String value) async {
    var guestCustomerId = ConstantsVar.prefs.getString('guestGUID')!;
    setState(() {
      showLoading = true;
    });
    String url =
        BuildConfig.base_url + BuildConfig.banners + '?apiToken=' + '$value';

    print('home_url $url');

    final response = await http.get(Uri.parse(url),
        headers: {HttpHeaders.cookieHeader: guestCustomerId});

    if (response.statusCode == 200) {
      mounted
          ? setState(() {
              showLoading = false;
            })
          : null;
      // print(response.body);
      HomeResponse1 homeResponse =
          HomeResponse1.fromJson(jsonDecode(response.body));
      if (homeResponse == null) {
        print('NULL NO VALUE return');
      } else {
        banners = homeResponse.banners;
        mounted
            ? setState(() {
                var products = homeResponse.homePageProductImage;
                var categories = homeResponse.homePageCategoriesImage;
                if (products.length > 0) {
                  productList = products;
                  categoryList = categories;
                  categoryVisible = true;

                  for (var i = 0; i < categoryList.length; i++) {
                    if (i % 2 == 0) {
                      viewsList.add(categroryLeftView(
                          categoryList[i].name,
                          categoryList[i].imageUrl,
                          categoryList[i].id,
                          categoryList[i].isSubCategory));
                    } else {
                      viewsList.add(categoryRightView(
                          categoryList[i].name,
                          categoryList[i].imageUrl,
                          categoryList[i].id,
                          categoryList[i].isSubCategory));
                    }
                  }
                }
              })
            : null;
      }
    } else {
      setState(() {
        showLoading = false;
      });
    }
    return response;
  }

  Widget categroryLeftView(
      String name, String imageUrl, final categoryId, final type) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Card(
            elevation: 10,
            shadowColor: Colors.grey,
            child: Container(
                width: Adaptive.w(41),
                height: Adaptive.w(25),
                child:
                    CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.fill)),
          ),
          InkWell(
            onTap: () {
              if (type == true) {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) =>
                            SubCatNew(catId: '$categoryId', title: name)));
              } else {
                Navigator.push(context, CupertinoPageRoute(builder: (context) {
                  return ProductList(
                    categoryId: '$categoryId',
                    title: name,
                  );
                }));
              }
            },
            child: Card(
              shadowColor: Colors.grey,
              elevation: 10,
              child: Container(
                width: Adaptive.w(41),
                height: Adaptive.w(25), color: AppColor.greyColor,
                // height: 12.h,
                child: Center(
                  child: Text(name,
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget categoryRightView(
      String name, String imageUrl, final categoryId, final type) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          InkWell(
            onTap: () {
              if (type == true) {
                print('$categoryId');
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) =>
                            SubCatNew(catId: '$categoryId', title: name)));
              } else {
                Navigator.push(context, CupertinoPageRoute(builder: (context) {
                  return ProductList(
                    categoryId: '$categoryId',
                    title: name,
                  );
                }));
              }
            },
            child: Card(
              shadowColor: Colors.grey,
              elevation: 10,
              child: Container(
                // width: 41.w,
                color: AppColor.greyColor,
                width: Adaptive.w(41),
                height: Adaptive.w(27),
                child: Center(
                  child: Text(name,
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center),
                ),
              ),
            ),
          ),
          Card(
            shadowColor: Colors.grey,
            elevation: 10,
            child: Container(
                width: Adaptive.w(41),
                height: Adaptive.w(25),
                child:
                    CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.fill)),
          ),
        ],
      ),
    );
  }

  Future getApiToken() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
    return ConstantsVar.prefs.get('apiTokken');
  }

  void navigate(Widget className) => Navigator.push(
      context, CupertinoPageRoute(builder: (context) => className));
}
//Please wait for few seconds
