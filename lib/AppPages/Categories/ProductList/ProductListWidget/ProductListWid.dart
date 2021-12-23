// import 'dart:html';

import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:untitled2/AppPages/CartxxScreen/ConstantVariables.dart';
import 'package:untitled2/AppPages/NewSubCategoryPage/ModelClass/NewSubCatProductModel.dart';
import 'package:untitled2/AppPages/SearchPage/SearchPage.dart';
import 'package:untitled2/AppPages/StreamClass/NewPeoductPage/NewProductScreen.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';
import 'package:untitled2/utils/HeartIcon.dart';

import '../../DiscountxxWidget.dart';
import '../SubCatProducts.dart';

class prodListWidget extends StatefulWidget {
  prodListWidget({
    Key? key,
    required this.products,
    required this.title,
    required this.isShown,
    required this.id,
    required this.pageIndex,
    required this.productCount,
    required this.guestCustomerId,
  }) : super(key: key);
  List<ResponseDatum> products;
  final title;
  FocusNode focusNode = FocusNode();

  // dynamic result;
  int pageIndex;
  String id;
  int productCount;
  final guestCustomerId;
  RefreshController myController = RefreshController();
  bool isShown;

  @override
  _prodListWidgetState createState() => _prodListWidgetState();
}

class _prodListWidgetState extends State<prodListWidget> {
  void initSharedPrefs() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
    if (mounted)
      setState(() {
        String listString = ConstantsVar.prefs.getString('searchList')!;
        // print(listString);
        List<dynamic> testingList = jsonDecode(listString);
        searchSuggestions = testingList.cast<String>();
        print(searchSuggestions.length.toString());
      });
  }

  List<String> searchSuggestions = [];
  var pageIndex1 = 1;

  bool isLoading = true;

  Color btnColor = Colors.black;

  var _suggestController = ScrollController();

  TextEditingController _searchController = TextEditingController();

  bool _isGiftCard = false;
  bool _isProductAttributeAvail = false;

  void _onLoading() async {
    print('object');
    if (widget.products.length == widget.productCount) {
      widget.myController.loadComplete();
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = true;
        pageIndex1 = pageIndex1 + 1;
        print('$pageIndex1');
        ApiCalls.getCategoryById('${widget.id}', context, pageIndex1)
            .then((value) {
          ProductListModel model = ProductListModel.fromJson(value);
          if (widget.products.length == model.productCount) {
            Fluttertoast.showToast(msg: 'No More Products Available for now');
            widget.myController.loadComplete();
            // widget.myController.requestLoading();

          } else {
            widget.products.addAll(model.responseData);
          }

          setState(() {});
        });
      });

      // monitor network fetch

      // if failed,use loadFailed(),if no data return,use LoadNodata()
      //   if(widget.myController.)
      if (mounted) setState(() {});
      widget.myController.loadComplete();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    pageIndex1 = widget.pageIndex;
    initSharedPrefs();
    super.initState();
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
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            color: ConstantsVar.appColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                child: RawAutocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text == null ||
                        textEditingValue.text == '') {
                      return const Iterable<String>.empty();
                    }
                    return searchSuggestions.where((String option) {
                      return option
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase());
                    });
                  },
                  onSelected: (String selection) {
                    debugPrint('$selection selected');
                  },
                  fieldViewBuilder: (BuildContext context,
                      TextEditingController textEditingController,
                      FocusNode focusNodee,
                      VoidCallback onFieldSubmitted) {
                    _searchController = textEditingController;
                    widget.focusNode = focusNodee;
                    // FocusScopeNode currentFocus = FocusScopeNode.of(context);
                    return TextFormField(
                      autocorrect: true,
                      enableSuggestions: true,
                      onFieldSubmitted: (val) {
                        widget.focusNode.unfocus();
                        if (currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                        if (mounted)
                          setState(() {
                            var value = _searchController.text;
                            Navigator.of(context)
                                .push(
                                  CupertinoPageRoute(
                                    builder: (context) => SearchPage(
                                      isScreen: true,
                                      keyword: value,
                                      enableCategory: false,
                                    ),
                                  ),
                                )
                                .then((value) => setState(() {
                                      _searchController.clear();
                                    }));
                          });

                        print('Pressed via keypad');
                      },
                      textInputAction: TextInputAction.search,
                      // keyboardType: TextInputType.,
                      keyboardAppearance: Brightness.light,
                      // autofocus: true,
                      onChanged: (_) => setState(() {
                        btnColor = ConstantsVar.appColor;
                      }),
                      controller: _searchController,
                      style: TextStyle(color: Colors.black, fontSize: 5.w),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 13, horizontal: 10),
                        hintText: 'Search here',
                        labelStyle:
                            TextStyle(fontSize: 7.w, color: Colors.grey),
                        suffixIcon: InkWell(
                          onTap: () async {
                            widget.focusNode.unfocus();

                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                            if (mounted)
                              setState(() {
                                var value = _searchController.text;
                                Navigator.of(context)
                                    .push(
                                      CupertinoPageRoute(
                                        builder: (context) => SearchPage(
                                          isScreen: true,
                                          keyword: value,
                                          enableCategory: false,
                                        ),
                                      ),
                                    )
                                    .then(
                                      (value) => setState(() {
                                        _searchController.clear();
                                      }),
                                    );
                              });
                          },
                          child: Icon(Icons.search_sharp),
                        ),
                      ),
                      focusNode: widget.focusNode,
                    );
                  },
                  optionsViewBuilder: (BuildContext context,
                      AutocompleteOnSelected<String> onSelected,
                      Iterable<String> options) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        top: 8.0,
                        right: 10,
                      ),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Material(
                          child: Card(
                            child: Container(
                              height: 178,
                              child: Scrollbar(
                                controller: _suggestController,
                                thickness: 5,
                                isAlwaysShown: true,
                                child: ListView.builder(
                                  // padding: EdgeInsets.all(8.0),
                                  itemCount: options.length + 1,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (index >= options.length) {
                                      return Align(
                                        alignment: Alignment.bottomCenter,
                                        child: TextButton(
                                          child: const Text(
                                            'Clear',
                                            style: TextStyle(
                                              color: ConstantsVar.appColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          onPressed: () {
                                            _searchController.clear();
                                          },
                                        ),
                                      );
                                    }
                                    final String option =
                                        options.elementAt(index);
                                    return GestureDetector(
                                        onTap: () {
                                          onSelected(option);
                                          Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                  builder: (context) =>
                                                      SearchPage(
                                                        keyword: option,
                                                        isScreen: true,
                                                        enableCategory: false,
                                                      ))).then(
                                            (value) => setState(
                                              () {
                                                _searchController.clear();
                                              },
                                            ),
                                          );
                                        },
                                        child: Container(
                                          height: 5.2.h,
                                          width: 95.w,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 100.w,
                                                child: AutoSizeText(
                                                  '  ' + option,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    wordSpacing: 2,
                                                    letterSpacing: 1,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 100.w,
                                                child: Divider(
                                                  thickness: 1,
                                                  color: Colors.grey.shade400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )

                                        // ListTile(
                                        //   title: Text(option),
                                        //   subtitle: Container(
                                        //     width: 100.w,
                                        //     child: Divider(
                                        //       thickness: 1,
                                        //       color:
                                        //           ConstantsVar.appColor,
                                        //     ),
                                        //   ),
                                        // ),
                                        );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          ListTile(
            title: Center(
              child: AutoSizeText(
                widget.title,
                style: TextStyle(shadows: <Shadow>[
                  Shadow(
                    offset: Offset(1.0, 1.2),
                    blurRadius: 3.0,
                    color: Colors.grey.shade300,
                  ),
                  Shadow(
                    offset: Offset(1.0, 1.2),
                    blurRadius: 8.0,
                    color: Colors.grey.shade300,
                  ),
                ], fontSize: 5.w, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: 100.w,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: CupertinoScrollbar(
                  isAlwaysShown: true,
                  child: SmartRefresher(
                    onLoading: _onLoading,
                    controller: widget.myController,
                    footer: CustomFooter(
                      builder: (context, mode) {
                        Widget body;
                        if (mode == LoadStatus.idle) {
                          body = SpinKitRipple(
                            color: Colors.red,
                            size: 90,
                          );
                        } else if (mode == LoadStatus.loading) {
                          body = CupertinoActivityIndicator();
                        } else if (mode == LoadStatus.failed) {
                          body = AutoSizeText("Load Failed!Click retry!");
                        } else if (mode == LoadStatus.canLoading) {
                          body = AutoSizeText("release to load more");
                        } else {
                          body = AutoSizeText("No more Data");
                        }
                        return Container(
                          height: 55.0,
                          child: Center(child: body),
                        );
                      },
                    ),
                    enablePullDown: false,
                    enablePullUp: isLoading,
                    enableTwoLevel: false,
                    physics: ClampingScrollPhysics(),
                    child: GridView.count(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      shrinkWrap: false,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 6,
                      cacheExtent: 20,
                      children: List.generate(
                        widget.products.length,
                        (index) {
                          return Stack(
                            children: [
                              Card(
                                // elevation: 2,
                                child: OpenContainer(
                                  closedElevation: 2,
                                  openBuilder: (BuildContext context,
                                      void Function({Object? returnValue})
                                          action) {
                                    return NewProductDetails(
                                      productId:
                                          widget.products[index].id.toString(),
                                      screenName: 'Product List',
                                      // customerId: ConstantsVar.customerID,
                                    );
                                  },
                                  closedBuilder: (BuildContext context,
                                      void Function() action) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          color: Colors.white,
                                          padding: EdgeInsets.all(4.0),
                                          child: CachedNetworkImage(
                                            imageUrl: widget
                                                .products[index].productPicture,
                                            fit: BoxFit.cover,
                                            placeholder: (context, reason) =>
                                                new SpinKitRipple(
                                              color: Colors.red,
                                              size: 90,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8.0,
                                              horizontal: 8.0),
                                          width: MediaQuery.of(context)
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
                                              // sorry mam nahi hua!
                                              Container(
                                                child: Text(
                                                  widget
                                                      .products[index].name,
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                  maxLines: 3,
                                                  // minFontSize:.w,
                                                  style: TextStyle(
                                                      color:
                                                      Colors.black,
                                                      fontSize: 4.5.w,
                                                      fontWeight:
                                                      FontWeight
                                                          .bold),
                                                  textAlign:
                                                  TextAlign.start,
                                                ),
                                                constraints:
                                                BoxConstraints
                                                    .tightFor(
                                                    width: 48.w,
                                                    height:
                                                    18.w),
                                              ),
                                              Padding(
                                                padding:
                                                const EdgeInsets
                                                    .symmetric(
                                                    vertical: 6.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  children: [

                                                    AutoSizeText(
                                                      widget
                                                          .products[index].discountPrice ==
                                                          null
                                                          ? widget
                                                          .products[index]
                                                          .price
                                                          :widget
                                                          .products[index].discountPrice,
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
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        AddCartBtn(
                                          productId: widget.products[index].id,
                                          // width: 2.w,
                                          isTrue: true,
                                          guestCustomerId:
                                              widget.guestCustomerId,
                                          checkIcon: widget
                                                  .products[index].stockQuantity
                                                  .contains('Out of stock')
                                              ? Icon(HeartIcon.cross)
                                              : Icon(Icons.check),
                                          text: widget
                                                  .products[index].stockQuantity
                                                  .contains('Out of stock')
                                              ? 'Out of Stock'.toUpperCase()
                                              : 'ADD TO CArt'.toUpperCase(),
                                          color: widget
                                                  .products[index].stockQuantity
                                                  .contains('Out of stock')
                                              ? Colors.grey
                                              : ConstantsVar.appColor,
                                          isGiftCard: _isGiftCard,
                                          isProductAttributeAvail:
                                              _isProductAttributeAvail,
                                          attributeId: '',
                                          recipEmail: '',
                                          email: '',
                                          message: '',
                                          name: '',
                                          recipName: '',
                                          // fontSize: 12,
                                        )
                                      ],
                                    );
                                  },
                                ),
                              ),
                              Visibility(
                                visible: widget
                                            .products[index].discountPercentage
                                            .trim()
                                            .length !=
                                        0
                                    ? true
                                    : false,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Container(
                                        width: 14.w,
                                        height: 14.w,
                                        child: Stack(
                                          children: [
                                            Image.asset(
                                              'MyAssets/plaincircle.png',
                                              width: 15.w,
                                              height: 15.w,
                                            ),
                                            Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                widget.products[index]
                                                    .discountPercentage,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 4.8.w,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )),
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
