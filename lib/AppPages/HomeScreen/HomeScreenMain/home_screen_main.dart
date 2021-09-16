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
    return SafeArea(
      top: true,
      child: Scaffold(
        body: buildSafeArea(context),
      ),
    );
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
                              width: Adaptive.w(14),
                              height: Adaptive.w(14)),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            left: 2,
                            right: 2,
                            bottom: 4,
                          ),
                          child: CarouselSlider(
                            options: CarouselOptions(
                                // enlargeStrategy: CenterPageEnlargeStrategy.height,
                                disableCenter: true,
                                pageSnapping: true,
                                // height: 24.h,
                                viewportFraction: 1,
                                aspectRatio: 4.5 / 2,
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
                          padding: const EdgeInsets.symmetric(vertical: 7.0),
                          color: Colors.black,
                          height:52.w,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: ListView.builder(
                                    // padding: EdgeInsets.symmetric(vertical:6),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: productList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return listContainer(productList[index]);
                                    }),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: categoryVisible,
                          child: Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(4),
                            // margin: EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              // crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: viewsList,
                            ),
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
              child:
                  Align(alignment: Alignment.centerRight, child: showloader()),
            ),
          ),
        ],
      ),
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
        padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
        // height: Adaptive.w(50),
        // color: Colors.white60,
        width: Adaptive.w(37),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Container(
                color: Colors.white,
                width: 36.w,
                padding: EdgeInsets.all(3.w),
                height: 36.w,
                // width: Adaptive.w(32),
                // height: Adaptive.w(40),
                child: CachedNetworkImage(
                  imageUrl: list.imageUrl[0],
                  fit: BoxFit.fill,
                ),
              ),
            ),
            addVerticalSpace(6),
            Container(
              width: 36.w,
              child: Center(
                child: Text(
                  list.price.splitBefore('incl') +
                      '   ' +
                      '\n' +
                      'i' +
                      list.price.splitAfter('i'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    wordSpacing: 4,
                    color: Colors.white,
                    fontSize: 4.1.w,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            InkWell(
              onTap: () {
                if (type == true) {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) =>
                              SubCatNew(catId: '$categoryId', title: name)));
                } else {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) {
                    return ProductList(
                      categoryId: '$categoryId',
                      title: name,
                    );
                  }));
                }
              },
              child: Card(
                elevation: 10,
                shadowColor: Colors.grey,
                child: Container(
                    width: Adaptive.w(45),
                    height: Adaptive.w(45),
                    child: CachedNetworkImage(
                        imageUrl: imageUrl, fit: BoxFit.fill)),
              ),
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
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) {
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
                  width: Adaptive.w(45),
                  height: Adaptive.w(45), color: AppColor.greyColor,
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
      ),
    );
  }

  Widget categoryRightView(
      String name, String imageUrl, final categoryId, final type) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:4.0),
      child: Container(
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
                  // width: 45.w,
                  color: AppColor.greyColor,
                  width: Adaptive.w(45),
                  height: Adaptive.w(45),
                  child: Center(
                    child: Text(name,
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center),
                  ),
                ),
              ),
            ),
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
                    width: Adaptive.w(45),
                    height: Adaptive.w(45),
                    child:
                        CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.fill)),
              ),
            ),
          ],
        ),
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
