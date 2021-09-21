import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:untitled2/AppPages/Categories/ProductList/SubCatProducts.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/SearchPage/SearchResponse/SearchResponse.dart';
import 'package:untitled2/AppPages/StreamClass/NewPeoductPage/NewProductScreen.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';
import 'package:untitled2/utils/HeartIcon.dart';
import 'package:untitled2/utils/utils/build_config.dart';
import 'package:untitled2/utils/utils/colors.dart';

enum AniProps { color }

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var color1 = ConstantsVar.appColor;
  var color2 = Colors.black54;
  late Animation<double> size;
  bool isLoadVisible = false;
  bool isListVisible = false;
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
  var totalCount;
  Color topColor = ConstantsVar.appColor;
  Color bottomColor = Colors.black26;
  Alignment begin = Alignment.bottomLeft;
  Alignment end = Alignment.topRight;
  Color btnColor = Colors.black;
  int pageIndex = 0;
  var guestCustomerId;
  late bool noMore;

  RefreshController _refreshController = RefreshController();

  // RefreshController _refreshController = RefreshController();
  //  FocusScopeNode currentFocus;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    noMore = false;
    // currentFocus = FocusScope.of(context);
    guestCustomerId = ConstantsVar.prefs.getString('guestCustomerID');
  }

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    return GestureDetector(
      onTap: () {
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: SafeArea(
          top: true,
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: new AppBar(
                backgroundColor: ConstantsVar.appColor,
                backwardsCompatibility: true,
                toolbarHeight: 18.w,
                // leading: IconButton(
                //   onPressed: () {
                //     setState(() {
                //       final counter = Counter();
                //       counter.value = 0;
                //     });
                //   },
                //   icon: Icon(Icons.arrow_back),
                //   // ),
                // ),
                title: InkWell(
                  onTap: () => Navigator.pushAndRemoveUntil(context,
                      CupertinoPageRoute(builder: (context) {
                    return MyHomePage();
                  }), (route) => false),
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
                  AnimatedContainer(
                    duration: Duration(seconds: 1),
                    onEnd: () {
                      setState(() {
                        index = index + 1;
                        // animate the color
                        bottomColor = colorList[index % colorList.length];
                        topColor = colorList[(index + 1) % colorList.length];
                      });
                    },
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: begin,
                            end: end,
                            colors: [bottomColor, topColor])),
                  ),
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  elevation: 8.0,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 75.w,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: TextFormField(
                                            keyboardAppearance:
                                                Brightness.light,
                                            // autofocus: true,
                                            onChanged: (_) => setState(() {
                                              btnColor = ConstantsVar.appColor;
                                            }),
                                            controller: _searchController,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 5.w),
                                            decoration: editBoxDecoration(Icon(
                                              Icons.search,
                                              color:
                                                  AppColor.PrimaryAccentColor,
                                            )),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        splashColor: Colors.redAccent,
                                        color: btnColor,
                                        icon: Icon(Icons.search_sharp),
                                        onPressed: () async {
                                          if (!currentFocus.hasPrimaryFocus) {
                                            currentFocus.unfocus();
                                          }
                                          setState(() {
                                            noMore = false;
                                          });
                                          searchProducts(
                                                  _searchController.text
                                                      .toString(),
                                                  0)
                                              .then((value) => print(value));
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: isListVisible,
                            child: Expanded(
                              child: CupertinoScrollbar(
                                isAlwaysShown: true,
                                thickness: 6,
                                radius: Radius.circular(8),
                                child: SmartRefresher(
                                  onLoading: _onLoading,
                                  enablePullUp:
                                      searchedProducts.length == totalCount
                                          ? false
                                          : true,
                                  enablePullDown: false,
                                  enableTwoLevel: false,
                                  footer: CustomFooter(
                                    builder: (context, mode) {
                                      Widget body;
                                      if (mode == LoadStatus.idle) {
                                        body = CupertinoActivityIndicator();
                                      } else if (mode == LoadStatus.loading) {
                                        body = CupertinoActivityIndicator();
                                      } else if (mode == LoadStatus.failed) {
                                        body = Text("Load Failed!Click retry!");
                                      } else if (mode ==
                                          LoadStatus.canLoading) {
                                        body = Text("release to load more");
                                      } else {
                                        body = Text("No more Data");
                                      }
                                      return Container(
                                        height: 55.0,
                                        child: Center(child: body),
                                      );
                                    },
                                  ),
                                  controller: _refreshController,
                                  child: GridView.count(
                                    physics: ClampingScrollPhysics(),
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10,
                                    childAspectRatio: 3 / 6,
                                    mainAxisSpacing: 10,
                                    children: List.generate(
                                        searchedProducts.length,
                                        (index) => InkWell(
                                              onTap: () {
                                                SchedulerBinding.instance!
                                                    .addPostFrameCallback(
                                                        (timeStamp) {
                                                  Navigator.push(
                                                    context,
                                                    CupertinoPageRoute(
                                                      builder: (context) {
                                                        return NewProductDetails(
                                                          productId:
                                                              searchedProducts[
                                                                      index]
                                                                  .id
                                                                  .toString(),
                                                          // customerId:
                                                          //     ConstantsVar
                                                          //         .customerID,
                                                        );
                                                      },
                                                    ),
                                                  );
                                                });
                                              },
                                              child: Container(
                                                color: Colors.white,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      color: Colors.white,
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            // ConstantsVar.netImage2,
                                                            searchedProducts[
                                                                    index]
                                                                .defaultPictureModel
                                                                .imageUrl,
                                                        fit: BoxFit.cover,
                                                        placeholder: (context,
                                                                reason) =>
                                                            SpinKitRipple(
                                                                color:
                                                                    Colors.red,
                                                                size: 90),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 4.0,
                                                              horizontal: 3.0),
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      // color: Color(0xFFe0e1e0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            searchedProducts[
                                                                    index]
                                                                .name
                                                                .toString(),
                                                            maxLines: 2,
                                                            style: TextStyle(
                                                                height: 1,
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 5.w,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                              top: 2.w,
                                                              bottom: 2.w,
                                                            ),
                                                            child: Text(
                                                              searchedProducts[
                                                                              index]
                                                                          .productPrice
                                                                          .priceWithDiscount ==
                                                                      null
                                                                  ? '${searchedProducts[index].productPrice.price}'
                                                                  : '${searchedProducts[index].productPrice.priceWithDiscount}',
                                                              maxLines: 1,
                                                              style: TextStyle(
                                                                  height: 1,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade600,
                                                                  fontSize: 4.w,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                              top: 2.w,
                                                              bottom: 2.w,
                                                            ),
                                                            child: Text(
                                                              '${searchedProducts[index].stockAvailability}',
                                                              maxLines: 1,
                                                              style: TextStyle(
                                                                  height: 1,
                                                                  color: searchedProducts[
                                                                              index]
                                                                          .stockAvailability
                                                                          .toString()
                                                                          .contains(
                                                                              'Out')
                                                                      ? Colors
                                                                          .red
                                                                      : Colors
                                                                          .green,
                                                                  fontSize:
                                                                      20.dp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                            ),
                                                          ),
                                                          AddCartBtn(
                                                            productId:
                                                                searchedProducts[
                                                                        index]
                                                                    .id
                                                                    .toString(),
                                                            // width: 50.w,
                                                            isTrue: true,
                                                            guestCustomerId:
                                                                guestCustomerId,
                                                            checkIcon: searchedProducts[
                                                                        index]
                                                                    .stockAvailability
                                                                    .toString()
                                                                    .contains(
                                                                        'Out of stock')
                                                                ? Icon(HeartIcon
                                                                    .cross)
                                                                : Icon(Icons
                                                                    .check),

                                                            text: searchedProducts[
                                                                        index]
                                                                    .stockAvailability
                                                                    .toString()
                                                                    .contains(
                                                                        'Out of stock')
                                                                ? 'OUT OF STOCK'
                                                                : 'add to cart'
                                                                    .toUpperCase(),

                                                            color: searchedProducts[
                                                                        index]
                                                                    .stockAvailability
                                                                    .toString()
                                                                    .contains(
                                                                        'Out of stock')
                                                                ? Colors.grey
                                                                : ConstantsVar
                                                                    .appColor,
                                                            // fontSize: 4.w,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: isLoadVisible,
                            child: Center(
                              child: SpinKitRipple(
                                color: Colors.redAccent,
                                size: 90,
                              ),
                            ),
                          ),
                          Visibility(
                              visible: noMore, child: Text('No Products Found'))
                        ],
                      ),
                    ),
                  ),
                ],
              ))),
    );
  }

  InputDecoration editBoxDecoration(Icon icon) {
    return new InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        hintText: 'Search here',
        labelStyle: TextStyle(fontSize: 7.w, color: Colors.grey),
        border: InputBorder.none);
  }

  List<Product> searchedProducts = [];

  Future searchProducts(String productName, int pageNumber) async {
    setState(() {
      searchedProducts.clear();
      isLoadVisible = true;
      isListVisible = false;
    });
    final uri = Uri.parse(BuildConfig.base_url +
        'apis/GetSearchProducts?searchkeyword=$productName&pagesize=8&pageindex=$pageNumber');
    try {
      var response = await http.get(uri,headers: ApiCalls.header);
      var jsonMap = jsonDecode(response.body);
      print(jsonMap);
      if (jsonMap['products'] == null) {
        Fluttertoast.showToast(msg: 'No Product found');
        setState(() {
          isLoadVisible = false;
          noMore = true;
        });
      } else {
        SearchResponse mySearchResponse = SearchResponse.fromJson(jsonMap);
        if (mySearchResponse.products == null) {
          setState(() {
            noMore = true;
            isListVisible = false;
            isLoadVisible = false;
          });
        } else {
          setState(() {
            isLoadVisible = false;

            searchedProducts = mySearchResponse.products;
            isListVisible = true;
            totalCount = int.parse(mySearchResponse.totalproducts);
          });

          if (totalCount == 0) {
            setState(() {
              isListVisible = true;
              //

              Fluttertoast.showToast(msg: 'No Products found');
            });
          } else if (searchedProducts.length ==
              int.parse(mySearchResponse.totalproducts)) {
            setState(() {
              isLoadVisible = false;
            });
          }
          return searchedProducts;
        }
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  void _onLoading() async {
    Fluttertoast.showToast(msg: 'Loading please wait');
    var prodName;
    setState(() {
      prodName = _searchController.text.toString();
      pageIndex = pageIndex + 1;
    });
    final uri = Uri.parse(BuildConfig.base_url +
        'apis/GetSearchProducts?searchkeyword=$prodName&pagesize=20&pageindex=$pageIndex');
    try {
      var response = await http.get(uri,headers: ApiCalls.header);
      var result = jsonDecode(response.body);
      print(result);
      SearchResponse mySearchResponse = SearchResponse.fromJson(result);

      setState(() {
        searchedProducts.addAll(mySearchResponse.products);
        _refreshController.loadComplete();

        // if (mySearchResponse.products.length == 0) {
        //   _refreshController.loadComplete();
        //   _refreshController.loadNoData();
        // }
      });

      if (searchedProducts.length == totalCount) {
        setState(() {});
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      _refreshController.loadFailed();
    }
  }
}
