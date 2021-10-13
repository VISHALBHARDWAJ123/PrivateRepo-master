import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:ej_selector/ej_selector.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
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
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'SearchResponse/SearchCatMdel.dart';

enum AniProps { color }

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final colorizeColors = [
    Colors.white,
    Colors.grey,
    Colors.black,
    ConstantsVar.appColor,
  ];

  final colorizeTextStyle =
      TextStyle(fontSize: 6.w, fontWeight: FontWeight.bold);

  var color1 = ConstantsVar.appColor;
  var color2 = Colors.black54;
  late Animation<double> size;
  bool isLoadVisible = false;
  bool isListVisible = false;
  TextEditingController _searchController = TextEditingController();
  TextEditingController _minPriceController = TextEditingController();
  TextEditingController _maxPriceController = TextEditingController();

  List<SearchCatResponeData> mList = [];
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

  var focusNode = FocusNode();

  String _catId = '';

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String _maxPrice = '', _minPrice = '';

  String _selectedText = 'All';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    noMore = false;
    guestCustomerId = ConstantsVar.prefs.getString('guestCustomerID');
    getSearchCat();
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
      child: GestureDetector(
        onTap: () {
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: SafeArea(
            top: true,
            child: Scaffold(
                key: _scaffoldKey,
                resizeToAvoidBottomInset: false,
                appBar: new AppBar(
                  backgroundColor: ConstantsVar.appColor,
                  toolbarHeight: 18.w,
                  actions: [],
                  title: InkWell(
                    onTap: () => Navigator.pushAndRemoveUntil(context,
                        CupertinoPageRoute(builder: (context) {
                      return MyHomePage(
                        pageIndex: 0,
                      );
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
                      width: 100.w,
                      height: 100.h,
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
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0)),
                                            elevation: 8.0,
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 69.5.w,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 15),
                                                    child: TextFormField(
                                                      onFieldSubmitted: (val) {
                                                        if (!currentFocus
                                                            .hasPrimaryFocus) {
                                                          currentFocus
                                                              .unfocus();
                                                        }
                                                        setState(() {
                                                          noMore = false;
                                                          _catId = '';
                                                          _selectedText = 'All';
                                                          _minPrice = '';
                                                          _maxPrice = '';
                                                        });
                                                        searchProducts(
                                                                val.toString(),
                                                                0,
                                                                _catId,
                                                                '',
                                                                '')
                                                            .then((value) =>
                                                                print(value));

                                                        print(
                                                            'Pressed via keypad');
                                                      },
                                                      textInputAction:
                                                          TextInputAction
                                                              .search,
                                                      // keyboardType: TextInputType.,
                                                      keyboardAppearance:
                                                          Brightness.light,
                                                      // autofocus: true,
                                                      onChanged: (_) =>
                                                          setState(() {
                                                        btnColor = ConstantsVar
                                                            .appColor;
                                                      }),
                                                      controller:
                                                          _searchController,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 5.w),
                                                      decoration:
                                                          editBoxDecoration(
                                                              Icon(
                                                        Icons.search,
                                                        color: AppColor
                                                            .PrimaryAccentColor,
                                                      )),
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                  splashColor: Colors.redAccent,
                                                  color: btnColor,
                                                  icon:
                                                      Icon(Icons.search_sharp),
                                                  onPressed: () async {
                                                    if (!currentFocus
                                                        .hasPrimaryFocus) {
                                                      currentFocus.unfocus();
                                                    }
                                                    setState(() {
                                                      noMore = false;
                                                      _catId = '';
                                                      _selectedText = 'All';
                                                      _minPrice = '';
                                                      _maxPrice = '';
                                                      _maxPriceController.text =
                                                          _maxPrice;
                                                      _minPriceController.text =
                                                          _minPrice;
                                                    });
                                                    searchProducts(
                                                            _searchController
                                                                .text
                                                                .toString(),
                                                            0,
                                                            '',
                                                            '',
                                                            '')
                                                        .then((value) =>
                                                            print(value));
                                                  },
                                                ),
                                                InkWell(
                                                  radius: 36,
                                                  splashColor: Colors.red,
                                                  hoverColor: Colors.red,
                                                  highlightColor: Colors.red,
                                                  onTap: () =>
                                                      showSearchModelSheet(
                                                          currentFocus),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 6.0),
                                                    child: Icon(
                                                      HeartIcon.searchFilter,
                                                      color: btnColor,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
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
                                        enablePullUp: searchedProducts.length ==
                                                totalCount
                                            ? false
                                            : true,
                                        enablePullDown: false,
                                        enableTwoLevel: false,
                                        footer: CustomFooter(
                                          builder: (context, mode) {
                                            Widget body;
                                            if (mode == LoadStatus.idle) {
                                              body =
                                                  CupertinoActivityIndicator();
                                            } else if (mode ==
                                                LoadStatus.loading) {
                                              body =
                                                  CupertinoActivityIndicator();
                                            } else if (mode ==
                                                LoadStatus.failed) {
                                              body = AutoSizeText(
                                                  "Load Failed!Click retry!");
                                            } else if (mode ==
                                                LoadStatus.canLoading) {
                                              body = AutoSizeText(
                                                  "release to load more");
                                            } else {
                                              body =
                                                  AutoSizeText("No more Data");
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
                                                                screenName:
                                                                    'Search Screen',
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
                                                            child:
                                                                CachedNetworkImage(
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
                                                                      color: Colors
                                                                          .red,
                                                                      size: 90),
                                                            ),
                                                          ),
                                                          Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        4.0,
                                                                    horizontal:
                                                                        3.0),
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            // color: Color(0xFFe0e1e0),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                AutoSizeText(
                                                                  searchedProducts[
                                                                          index]
                                                                      .name
                                                                      .toString(),
                                                                  maxLines: 2,
                                                                  style: TextStyle(
                                                                      height: 1,
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          5.w,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                    top: 2.w,
                                                                    bottom: 2.w,
                                                                  ),
                                                                  child:
                                                                      AutoSizeText(
                                                                    searchedProducts[index].productPrice.priceWithDiscount ==
                                                                            null
                                                                        ? '${searchedProducts[index].productPrice.price}'
                                                                        : '${searchedProducts[index].productPrice.priceWithDiscount}',
                                                                    maxLines: 1,
                                                                    style: TextStyle(
                                                                        height:
                                                                            1,
                                                                        color: Colors
                                                                            .grey
                                                                            .shade600,
                                                                        fontSize:
                                                                            4.w,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                    top: 2.w,
                                                                    bottom: 2.w,
                                                                  ),
                                                                  child:
                                                                      AutoSizeText(
                                                                    '${searchedProducts[index].stockAvailability}',
                                                                    maxLines: 1,
                                                                    style: TextStyle(
                                                                        height:
                                                                            1,
                                                                        color: searchedProducts[index].stockAvailability.toString().contains('Out')
                                                                            ? Colors
                                                                                .red
                                                                            : Colors
                                                                                .green,
                                                                        fontSize: 20
                                                                            .dp,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                  ),
                                                                ),
                                                                AddCartBtn(
                                                                  productId: searchedProducts[
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
                                                                      ? Colors
                                                                          .grey
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
                              ],
                            ),
                            Visibility(
                              visible: noMore,
                              child: Center(
                                  child: AnimatedTextKit(
                                repeatForever: true,
                                animatedTexts: [
                                  ColorizeAnimatedText(
                                    'No Product Found',
                                    textStyle: colorizeTextStyle,
                                    colors: colorizeColors,
                                  ),
                                ],
                              )
                                  // AutoSizeText(
                                  //   'No Products Found',
                                  //   style: TextStyle(
                                  //     color: Colors.white,
                                  //     fontSize: 6.w,
                                  //     fontWeight: FontWeight.w600,
                                  //   ),
                                  // ),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ))),
      ),
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

  Future searchProducts(String productName, int pageNumber, String CategoryId,
      String minPrice, String maxPrice) async {
    setState(() {
      searchedProducts.clear();
      isLoadVisible = true;
      isListVisible = false;
    });
    final uri = Uri.parse(BuildConfig.base_url +
        'apis/GetSearchProducts?searchkeyword=$productName&pagesize=8&pageindex=$pageNumber&categoryid=$CategoryId&minPrice=$minPrice&maxPrice=$maxPrice');
    try {
      var response = await http.get(uri, headers: ApiCalls.header);
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
      ConstantsVar.excecptionMessage(e);
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
        'apis/GetSearchProducts?searchkeyword=$prodName&pagesize=20&pageindex=$pageIndex&categoryid = $_catId&minPrice=$_minPrice&maxPrice=$_maxPrice');
    try {
      var response = await http.get(uri, headers: ApiCalls.header);
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
        setState(() {
          _refreshController.loadComplete();
        });
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      _refreshController.loadFailed();
    }
  }

  showSearchModelSheet(FocusScopeNode currentFocus) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: true,
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 67.h,
            color: Colors.transparent,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(35.0),
                        // bottomRight: Radius.circular(35.0),
                        topLeft: Radius.circular(35.0),
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(90.0),
                          // bottomRight: Radius.circular(35.0),
                          topLeft: Radius.circular(90.0),
                        ),
                        color: Colors.white,
                      ),
                      height: 59.h,
                      width: 100.w,
                      child: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 20.w,
                              horizontal: 6.w,
                            ),
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                AutoSizeText(
                                  'Category: '.toUpperCase(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 4.8.w,
                                  ),
                                ),
                                Card(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 4.0.w),
                                    child: Container(
                                      height: 6.h,
                                      width: 100.w,
                                      child: EJSelectorButton<
                                          SearchCatResponeData>(
                                        divider: Container(
                                          height: 1,
                                          width: 100.w,
                                          child: Divider(
                                            color: Colors.black,
                                            thickness: 1,
                                          ),
                                        ),
                                        dialogWidth: 100.w,
                                        onChange: (newValue) {
                                          Fluttertoast.showToast(
                                              msg: newValue.name);

                                          setState(() {
                                            _catId = newValue.id.toString();
                                            _selectedText = newValue.name;
                                          });
                                        },
                                        useValue: true,
                                        hint: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            _selectedText,
                                            style: TextStyle(
                                                fontSize: 5.w,
                                                color: Colors.black),
                                          ),
                                        ),
                                        buttonBuilder: (child, value) =>
                                            Container(
                                          alignment: Alignment.center,
                                          height: 6.h,
                                          width: 100.w,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            // color: Colors.green,
                                          ),
                                          child: value != null
                                              ? Container(
                                                  width: 100.w,
                                                  child: AutoSizeText(
                                                    value.name,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black),
                                                  ),
                                                )
                                              : child,
                                        ),
                                        selectedWidgetBuilder:
                                            (valueOfSelected) {
                                          Fluttertoast.showToast(
                                              msg: valueOfSelected.name);
                                          return Container(
                                            width: 100.w,
                                            color: Colors.grey,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16, horizontal: 32),
                                            child: Text(
                                              valueOfSelected.name,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.blue),
                                            ),
                                          );
                                        },
                                        items: mList
                                            .map(
                                              (item) => EJSelectorItem(
                                                value: item,
                                                widget: Container(
                                                  width: 100.w,
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 16,
                                                      horizontal: 32),
                                                  child: Text(
                                                    item.name,
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                AutoSizeText(
                                  'Price Range: '.toUpperCase(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 4.8.w,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: Container(
                                    width: 100.w,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            height: 12.w,
                                            width: 42.w,
                                            child: TextFormField(
                                              textInputAction:
                                                  TextInputAction.next,
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: _minPriceController,
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(10),
                                                    ),
                                                  ),
                                                  labelText: 'Min Price'),
                                            ),
                                          ),
                                          Container(
                                            height: 12.w,
                                            width: 42.w,
                                            child: TextFormField(
                                              textInputAction:
                                                  TextInputAction.next,
                                              controller: _maxPriceController,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                ),
                                                labelText: 'Max Price',
                                              ),
                                            ),
                                          )
                                        ]),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 12,
                            child: InkWell(
                              radius: 36,
                              highlightColor: ConstantsVar.appColor,
                              hoverColor: ConstantsVar.appColor,
                              focusColor: ConstantsVar.appColor,
                              splashColor: Colors.redAccent,
                              onTap: () => Navigator.pop(context),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0),
                                ),
                                child: Icon(
                                  Icons.close,
                                  color: ConstantsVar.appColor,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: AppButton(
                              onTap: () {
                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }
                                _minPrice = _minPriceController.text;
                                _maxPrice = _maxPriceController.text;
                                setState(() {
                                  noMore = false;
                                });
                                Future.delayed(
                                    Duration(seconds: 1, milliseconds: 35),
                                    () => Navigator.pop(context));

                                searchProducts(
                                        _searchController.text.toString(),
                                        0,
                                        _catId,
                                        _minPrice,
                                        _maxPrice)
                                    .then((value) => print(value));
                              },
                              width: 100.w,
                              child: Container(
                                color: ConstantsVar.appColor,
                                height: 10.w,
                                width: 100.w,
                                child: Center(
                                  child: Text(
                                    'Search',
                                    style: TextStyle(
                                      fontSize: 4.w,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: CircleAvatar(
                    backgroundImage: AssetImage(
                      'MyAssets/logo.png',
                    ),
                    radius: 56,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getSearchCat() async {
    final url =
        Uri.parse(BuildConfig.base_url + 'apis/GetSearchPageCategories');
    var response = await http.get(url);
    try {
      SearchCatModel model = SearchCatModel.fromJson(jsonDecode(response.body));
      setState(() {
        mList.addAll(model.responseData);
      });
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }
}
