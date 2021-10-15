import 'dart:async';
import 'dart:convert';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:delayed_display/delayed_display.dart';
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
import 'package:ndialog/ndialog.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:untitled2/AppPages/Categories/DiscountxxWidget.dart';
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
  var _range;
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
  bool isVisible = false;
  RefreshController _refreshController = RefreshController();

  var focusNode = FocusNode();

  String _catId = '';

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int _maxPrice = 30000, _minPrice = 0;

  String _selectedText = 'All';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _range = RangeValues(_minPrice.toDouble(), _maxPrice.toDouble());
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
      child: SafeArea(
        top: true,
        child: Scaffold(
          key: _scaffoldKey,
          // appBar: new AppBar(
          //   backgroundColor: ConstantsVar.appColor,
          //   toolbarHeight: 18.w,
          //   actions: [],
          //   title: InkWell(
          //     onTap: () => Navigator.pushAndRemoveUntil(context,
          //         CupertinoPageRoute(builder: (context) {
          //       return MyHomePage(
          //         pageIndex: 0,
          //       );
          //     }), (route) => false),
          //     child: Image.asset(
          //       'MyAssets/logo.png',
          //       width: 15.w,
          //       height: 15.w,
          //     ),
          //   ),
          //   centerTitle: true,
          // ),
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
                child: Stack(
                  children: [
                    Container(
                      height: 100.h,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Container(
                              width: 100.w,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: ConstantsVar.appColor,
                                ),
                                child: Stack(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0)),
                                            elevation: 8.0,
                                            child: TextFormField(
                                              onFieldSubmitted: isVisible ==
                                                      true
                                                  ? null
                                                  : (val) {
                                                      if (!currentFocus
                                                          .hasPrimaryFocus) {
                                                        currentFocus.unfocus();
                                                      }
                                                      setState(() {
                                                        isVisible = false;
                                                        noMore = false;
                                                        _catId = '';
                                                        _selectedText = 'All';
                                                        _minPrice = 0;
                                                        pageIndex = 0;
                                                        _maxPrice = 30000;
                                                        _range = RangeValues(
                                                            _minPrice
                                                                .toDouble(),
                                                            _maxPrice
                                                                .toDouble());
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
                                              textInputAction: isVisible
                                                  ? TextInputAction.done
                                                  : TextInputAction.search,
                                              // keyboardType: TextInputType.,
                                              keyboardAppearance:
                                                  Brightness.light,
                                              // autofocus: true,
                                              onChanged: (_) => setState(() {
                                                btnColor =
                                                    ConstantsVar.appColor;
                                              }),
                                              controller: _searchController,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 5.w),
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 13,
                                                        horizontal: 10),
                                                hintText: 'Search here',
                                                labelStyle: TextStyle(
                                                    fontSize: 7.w,
                                                    color: Colors.grey),
                                                suffixIcon: InkWell(
                                                  onTap: () async {
                                                    if (!currentFocus
                                                        .hasPrimaryFocus) {
                                                      currentFocus.unfocus();
                                                    }
                                                    setState(() {
                                                      noMore = false;
                                                      _catId = '';
                                                      _selectedText = 'All';
                                                      _minPrice = 0;
                                                      _maxPrice = 30000;
                                                      _range = RangeValues(
                                                          _minPrice.toDouble(),
                                                          _maxPrice.toDouble());
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
                                                  child:
                                                      Icon(Icons.search_sharp),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: isListVisible,
                                          child: InkWell(
                                            radius: 36,
                                            splashColor: Colors.red,
                                            hoverColor: Colors.red,
                                            highlightColor: Colors.red,
                                            onTap: () => isVisible == false
                                                ? setState(
                                                    () => isVisible = true)
                                                : setState(
                                                    () => isVisible = false),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              child: Icon(
                                                HeartIcon.searchFilter,
                                                color: Colors.white,
                                                size: 32,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Visibility(

                                          visible: isVisible,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 55,bottom: 4),
                                            child: showSearchFilter(),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
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
                                        body = AutoSizeText(
                                            "Load Failed!Click retry!");
                                      } else if (mode ==
                                          LoadStatus.canLoading) {
                                        body = AutoSizeText(
                                            "release to load more");
                                      } else {
                                        body = AutoSizeText("No more Data");
                                      }
                                      return Container(
                                        // height: 55.0,
                                        child: Center(child: body),
                                      );
                                    },
                                  ),
                                  controller: _refreshController,
                                  child: GridView.count(
                                    physics: ClampingScrollPhysics(),
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 5,
                                    childAspectRatio: 3 / 6,
                                    mainAxisSpacing: 5,
                                    children: List.generate(
                                      searchedProducts.length,
                                      (index) {
                                        // var name = searchedProducts[index].stockQuantity.contains('In stock');
                                        return InkWell(
                                          onTap: () {
                                            print(searchedProducts[index]
                                                .id
                                                .toString());

                                            //
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
                                                          'Product List',
                                                      // customerId: ConstantsVar.customerID,
                                                    );
                                                  },
                                                ),
                                              );
                                            });
                                          },
                                          child: Stack(
                                            children: [
                                              Card(
                                                // elevation: 2,
                                                child: Container(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        color: Colors.white,
                                                        padding:
                                                            EdgeInsets.all(4.0),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl:
                                                              searchedProducts[
                                                                      index]
                                                                  .productPicture,
                                                          fit: BoxFit.cover,
                                                          placeholder: (context,
                                                                  reason) =>
                                                              new SpinKitRipple(
                                                            color: Colors.red,
                                                            size: 90,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 8.0,
                                                                horizontal:
                                                                    8.0),
                                                        width: MediaQuery.of(
                                                                context)
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
                                                            AutoSizeText(
                                                              searchedProducts[
                                                                      index]
                                                                  .name,
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
                                                                  TextAlign
                                                                      .start,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          6.0),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .only(
                                                                      top: 2.w,
                                                                      left: 2,
                                                                    ),
                                                                    child:
                                                                        discountWidget(
                                                                      actualPrice:
                                                                          searchedProducts[index]
                                                                              .price,
                                                                      fontSize:
                                                                          2.4.w,
                                                                      width:
                                                                          25.w,
                                                                      isSpace: searchedProducts[index].discountedPrice ==
                                                                              null
                                                                          ? true
                                                                          : false,
                                                                    ),
                                                                  ),
                                                                  AutoSizeText(
                                                                    searchedProducts[index].discountedPrice ==
                                                                            null
                                                                        ? searchedProducts[index]
                                                                            .price
                                                                        : searchedProducts[index]
                                                                            .discountedPrice,
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
                                                                  Padding(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .only(
                                                                      top: 4,
                                                                      bottom: 2,
                                                                    ),
                                                                    child:
                                                                        AutoSizeText(
                                                                      searchedProducts[
                                                                              index]
                                                                          .stockQuantity,
                                                                      maxLines:
                                                                          1,
                                                                      style: TextStyle(
                                                                          height:
                                                                              1,
                                                                          color: searchedProducts[index].stockQuantity.contains('In stock')
                                                                              ? Colors
                                                                                  .green
                                                                              : Colors
                                                                                  .red,
                                                                          fontSize: 20
                                                                              .dp,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      AddCartBtn(
                                                        productId:
                                                            searchedProducts[
                                                                    index]
                                                                .id,
                                                        // width: 2.w,
                                                        isTrue: true,
                                                        guestCustomerId:
                                                            guestCustomerId,
                                                        checkIcon: searchedProducts[
                                                                    index]
                                                                .stockQuantity
                                                                .contains(
                                                                    'Out of stock')
                                                            ? Icon(
                                                                HeartIcon.cross)
                                                            : Icon(Icons.check),
                                                        text: searchedProducts[
                                                                    index]
                                                                .stockQuantity
                                                                .contains(
                                                                    'Out of stock')
                                                            ? 'Out of Stock'
                                                                .toUpperCase()
                                                            : 'ADD TO CArt'
                                                                .toUpperCase(),
                                                        color: searchedProducts[
                                                                    index]
                                                                .stockQuantity
                                                                .contains(
                                                                    'Out of stock')
                                                            ? Colors.grey
                                                            : ConstantsVar
                                                                .appColor,
                                                        // fontSize: 12,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top:3,
                                                left:3,
                                                child: Visibility(
                                                  visible: searchedProducts[index].discountPercent.trim().length != 0 ? true : false,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(4.0),
                                                    child: Container(
                                                      width: 10.w,
                                                      height: 10.w,
                                                      child: Stack(
                                                        children: [
                                                          Image.asset(
                                                            'MyAssets/plaincircle.png',
                                                            width: 10.w,
                                                            height: 10.w,
                                                          ),
                                                          Align(
                                                            alignment: Alignment.center,
                                                            child: Text(
                                                              searchedProducts[index].discountPercent,
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.w800,
                                                                fontSize: 3.w,
                                                                color: Colors.white,
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                    ),
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
    );
  }

  InputDecoration editBoxDecoration(Icon icon) {
    return new InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 10),
      hintText: 'Search here',
      labelStyle: TextStyle(fontSize: 7.w, color: Colors.grey),
      border: InputBorder.none,
    );
  }

  List<Product> searchedProducts = [];

  Future searchProducts(String productName, int pageNumber, String CategoryId,
      String minPrice, String maxPrice) async {
    CustomProgressDialog progressDialog =
        CustomProgressDialog(context, blur: 2, dismissable: false);
    progressDialog.setLoadingWidget(SpinKitRipple(
      color: Colors.red,
      size: 90,
    ));
    progressDialog.show();
    setState(() {
      searchedProducts.clear();
      isLoadVisible = true;
      isListVisible = false;
    });
    final uri = Uri.parse(BuildConfig.base_url +
        'apis/GetSearchProducts?searchkeyword=$productName&pagesize=8&pageindex=$pageNumber&categoryid=$CategoryId&minPrice=$minPrice&maxPrice=$maxPrice');

    print(uri);
    try {
      var response = await http.get(uri, headers: ApiCalls.header);
      var jsonMap = jsonDecode(response.body);
      print(jsonMap);
      if (jsonMap['products'] == null) {
        Fluttertoast.showToast(msg: 'No Product found');
        progressDialog.dismiss();
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
            progressDialog.dismiss();
          });
        } else {
          setState(() {
            isLoadVisible = false;
            progressDialog.dismiss();
            searchedProducts = mySearchResponse.products;
            isListVisible = true;
            totalCount = mySearchResponse.totalproducts;
          });

          if (totalCount == 0) {
            setState(() {
              isListVisible = true;
              //
              progressDialog.dismiss();
              Fluttertoast.showToast(msg: 'No Products found');
            });
          } else if (searchedProducts.length ==
              mySearchResponse.totalproducts) {
            setState(() {
              isLoadVisible = false;
              progressDialog.dismiss();
            });
          }
          return searchedProducts;
        }
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      progressDialog.dismiss();
    }
  }

  void _onLoading() async {
    Fluttertoast.showToast(msg: 'Loading please wait');
    var prodName;
    setState(() {
      prodName = _searchController.text.toString();
      pageIndex = pageIndex + 1;
      print(pageIndex);
    });
    final uri = Uri.parse(BuildConfig.base_url +
        'apis/GetSearchProducts?searchkeyword=$prodName&pagesize=20&pageindex=$pageIndex&categoryid = $_catId&minPrice=$_minPrice&maxPrice=$_maxPrice');
    print(uri);
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
                                        _minPrice.toString(),
                                        _maxPrice.toString())
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

  Widget showSearchFilter() => Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    elevation: 10.0,
    child: Container(
      // color: Colors.white,
      height: 33.h,
      width: 100.w,
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(children: [
              AutoSizeText(
                'Category: '.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 4.8.w,
                ),
              ),
              DropdownButton<SearchCatResponeData>(
                isDense: true,
                hint: Container(width: 52.w, child: Text('All')),
                items: mList.map((value) {
                  return DropdownMenuItem<SearchCatResponeData>(
                    value: value,
                    child: Container(
                      width: 55.w,
                      height: 10.w,
                      child: Text(value.name),
                    ),
                  );
                }).toList(),
                onChanged: (_) {},
              ),
            ]),
          ),
          // Card(
          //   child: Padding(
          //     padding: EdgeInsets.symmetric(horizontal: 4.0.w),
          //     child: Container(
          //       height: 6.h,
          //       width: 100.w,
          //       child: EJSelectorButton<SearchCatResponeData>(
          //         divider: Container(
          //           height: 1,
          //           width: 100.w,
          //           child: Divider(
          //             color: Colors.black,
          //             thickness: 1,
          //           ),
          //         ),
          //         dialogWidth: 100.w,
          //         onChange: (newValue) {
          //           Fluttertoast.showToast(msg: newValue.name);
          //
          //           setState(() {
          //             _catId = newValue.id.toString();
          //             _selectedText = newValue.name;
          //           });
          //         },
          //         useValue: true,
          //         hint: Align(
          //           alignment: Alignment.centerLeft,
          //           child: Text(
          //             _selectedText,
          //             style:
          //                 TextStyle(fontSize: 5.w, color: Colors.black),
          //           ),
          //         ),
          //         buttonBuilder: (child, value) => Container(
          //           alignment: Alignment.center,
          //           height: 6.h,
          //           width: 100.w,
          //           decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(4),
          //             // color: Colors.green,
          //           ),
          //           child: value != null
          //               ? Container(
          //                   width: 100.w,
          //                   child: AutoSizeText(
          //                     value.name,
          //                     style: TextStyle(
          //                         fontSize: 16, color: Colors.black),
          //                   ),
          //                 )
          //               : child,
          //         ),
          //         selectedWidgetBuilder: (valueOfSelected) {
          //           Fluttertoast.showToast(msg: valueOfSelected.name);
          //           return Container(
          //             width: 100.w,
          //             color: Colors.green,
          //             padding: const EdgeInsets.symmetric(
          //                 vertical: 16, horizontal: 32),
          //             child: Text(
          //               valueOfSelected.name,
          //               style:
          //                   TextStyle(fontSize: 20, color: Colors.blue),
          //             ),
          //           );
          //         },
          //         items: mList
          //             .map(
          //               (item) => EJSelectorItem(
          //                 value: item,
          //                 widget: Container(
          //                   width: 100.w,
          //                   padding: const EdgeInsets.symmetric(
          //                       vertical: 16, horizontal: 32),
          //                   child: Text(
          //                     item.name,
          //                     style: TextStyle(fontSize: 16),
          //                   ),
          //                 ),
          //               ),
          //             )
          //             .toList(),
          //       ),
          //     ),
          //   ),
          // ),
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
          Container(
            width: 100.w,
            child: RangeSlider(
              activeColor: Colors.red,
              inactiveColor: Colors.black,
              divisions: 30000,
              min: 0,
              labels: RangeLabels('$_minPrice', '$_maxPrice'),
              max: 30000,
              values: _range,
              onChanged: (RangeValues value) {
                print('$value');
                setState(() {
                  _range = value;
                  _minPrice = _range.start.round();
                  _maxPrice = _range.end.round();
                });
              },
            ),
          ),
          Container(
            width: 60.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Min Price: $_minPrice'),
                Text('Max Price: $_maxPrice'),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          AppButton(
            textStyle: TextStyle(color: Colors.white),
            height: 5.w,
            text: 'Apply Filters',
            color: ConstantsVar.appColor,
            splashColor: Colors.white,
            onTap: () {
              // _minPrice = _minPriceController.text;
              // _maxPrice = _maxPriceController.text;
              setState(() {
                noMore = false;
              });
              Future.delayed(
                  Duration(
                    seconds: 1,
                  ),
                  () => setState(() => isVisible = false));

              searchProducts(_searchController.text.toString(), 0, _catId,
                      _minPrice.toString(), _maxPrice.toString())
                  .then((value) => print(value));
            },
            width: 100.w,
          ),
        ],
      ),
    ),
  );
}
