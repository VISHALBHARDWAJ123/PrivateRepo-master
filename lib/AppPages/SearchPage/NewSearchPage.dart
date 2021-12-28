import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/AppPages/Categories/DiscountxxWidget.dart';
import 'package:untitled2/AppPages/Categories/ProductList/SubCatProducts.dart';
import 'package:untitled2/AppPages/StreamClass/NewPeoductPage/NewProductScreen.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';
import 'package:untitled2/utils/CartBadgeCounter/SearchModel/SearchNotifier.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:untitled2/utils/HeartIcon.dart';
import 'package:untitled2/utils/utils/build_config.dart';

import 'SearchResponse/SearchResponse.dart';

class NewSearchPage extends StatefulWidget {
  const NewSearchPage({Key? key}) : super(key: key);

  @override
  _NewSearchPageState createState() => _NewSearchPageState();
}

class _NewSearchPageState extends State<NewSearchPage> {
  final controller = FloatingSearchBarController();

  var guestCustomerId;

  bool isLoadVisible = false;

  var totalCount;

  String _searchText = 'Search Here...';

  void initSharedPrefs() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    initSharedPrefrences();
    // TODO: implement initState
    super.initState();
    guestCustomerId = ConstantsVar.prefs.getString('guestCustomerID');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: buildSearchBar(),
      ),
    );
  }

  Widget buildSearchBar() {
    final actions = [
      FloatingSearchBarAction(
        showIfClosed: false,
        showIfOpened: true,
        child: CircularButton(
          icon: const Icon(Icons.search),
          onPressed: () async {
            // Random random = Random();
            Fluttertoast.showToast(msg: 'Hi There');
            searchProducts(
                controller.query.toString(), 0, 0.toString(), '25000');
          },
        ),
      ),
      // FloatingSearchBarAction.searchToClear(
      //   showIfClosed: false,
      // ),
    ];

    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Consumer<SearchModel>(
      builder: (context, model, _) => FloatingSearchBar(
        toolbarOptions: ToolbarOptions(),
        onSubmitted: (val) {},
        automaticallyImplyBackButton: false,
        controller: controller,
        clearQueryOnClose: true,
        hint: 'Search Here',
        iconColor: Colors.grey,
        transitionDuration: const Duration(milliseconds: 800),
        transitionCurve: Curves.easeInOutCubic,
        physics: const BouncingScrollPhysics(),
        // axisAlignment: isPortrait ? 0.0 : -1.0,
        openAxisAlignment: 0.0,
        title: Text(_searchText),
        actions: actions,
        leadingActions: [
          FloatingSearchBarAction.back(
            showIfClosed: true,
          )
        ],
        progress: model.isLoading,
        debounceDelay: const Duration(milliseconds: 500),
        onQueryChanged: model.onQueryChanged,
        scrollPadding: EdgeInsets.zero,
        transition: CircularFloatingSearchBarTransition(spacing: 16),
        builder: (context, _) => buildExpandableBody(model),
        body: searchList(),
      ),
    );
  }

  Widget buildExpandableBody(SearchModel model) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.antiAlias,
        child: ImplicitlyAnimatedList<String>(
          shrinkWrap: true,
          // physics: const NeverScrollableScrollPhysics(),
          items: model.suggestions,
          insertDuration: const Duration(milliseconds: 700),
          itemBuilder: (context, animation, item, i) {
            return SizeFadeTransition(
              animation: animation,
              child: buildItem(context, item),
            );
          },
          updateItemBuilder: (context, animation, item) {
            return FadeTransition(
              opacity: animation,
              alwaysIncludeSemantics: true,
              child: buildItem(context, item),
            );
          },
          areItemsTheSame: (a, b) => a == b,
        ),
      ),
    );
  }

  Widget buildItem(BuildContext context, String place) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final model = Provider.of<SearchModel>(context, listen: false);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            FloatingSearchBar.of(context)!.close();
            Future.delayed(
              const Duration(milliseconds: 500),
              () => searchProducts(place, 0, '0', 25000.toString()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Text(
                  place,
                  style: textTheme.subtitle1,
                ),
                const SizedBox(height: 2),
              ],
            ),
          ),
        ),
        if (model.suggestions.isNotEmpty && place != model.suggestions.last)
          const Divider(height: 0),
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void initSharedPrefrences() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
  }

  List<GetProductsByCategoryIdClass> searchedProducts = [];

  Widget searchList() {
    return Visibility(
      visible: searchedProducts.length == 0 ? false : true,
      child: Padding(
        padding: const EdgeInsets.only(top: 60.0),
        child: Container(
          // height:82.5.h,
          child: Scrollbar(
            isAlwaysShown: true,
            thickness: 10,
            child: GridView.count(
              // physics: AlwaysScrollableScrollPhysics(),
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
                      print(searchedProducts[index].id.toString());

                      //
                      SchedulerBinding.instance!
                          .addPostFrameCallback((timeStamp) {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) {
                              return NewProductDetails(
                                productId:
                                    searchedProducts[index].id.toString(),
                                screenName: 'Product List',
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.all(4.0),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        searchedProducts[index].productPicture,
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
                                      vertical: 8.0, horizontal: 8.0),
                                  width: MediaQuery.of(context).size.width,
                                  // color: Color(0xFFe0e1e0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // sorry mam nahi hua!
                                      AutoSizeText(
                                        searchedProducts[index].name,
                                        maxLines: 2,
                                        style: TextStyle(
                                            height: 1,
                                            color: Colors.black,
                                            fontSize: 5.w,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.start,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 6.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                top: 2.w,
                                                left: 2,
                                              ),
                                              child: discountWidget(
                                                actualPrice:
                                                    searchedProducts[index]
                                                        .price,
                                                fontSize: 2.4.w,
                                                width: 25.w,
                                                isSpace: searchedProducts[index]
                                                            .discountedPrice ==
                                                        null
                                                    ? true
                                                    : false,
                                              ),
                                            ),
                                            AutoSizeText(
                                              searchedProducts[index]
                                                          .discountedPrice ==
                                                      null
                                                  ? searchedProducts[index]
                                                      .price
                                                  : searchedProducts[index]
                                                      .discountedPrice,
                                              maxLines: 1,
                                              style: TextStyle(
                                                  height: 1,
                                                  color: Colors.grey.shade600,
                                                  fontSize: 4.w,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.start,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: searchedProducts[index].isGiftCard ==
                                              true ||
                                          searchedProducts[index]
                                                  .isDeliveryProduct ==
                                              true
                                      ? false
                                      : true,
                                  child: AddCartBtn(
                                    productId: searchedProducts[index].id,
                                    // width: 2.w,
                                    isTrue: true,
                                    guestCustomerId: guestCustomerId,
                                    checkIcon: searchedProducts[index]
                                            .stockQuantity
                                            .contains('Out of stock')
                                        ? Icon(HeartIcon.cross)
                                        : Icon(Icons.check),
                                    text: searchedProducts[index]
                                            .stockQuantity
                                            .contains('Out of stock')
                                        ? 'Out of Stock'.toUpperCase()
                                        : 'ADD TO CArt'.toUpperCase(),
                                    color: searchedProducts[index]
                                            .stockQuantity
                                            .contains('Out of stock')
                                        ? Colors.grey
                                        : ConstantsVar.appColor,
                                    isGiftCard: false,
                                    isProductAttributeAvail: false,
                                    email: '',
                                    recipName: '',
                                    recipEmail: '',
                                    attributeId: '',
                                    name: '',
                                    message: '',
                                    productName: searchedProducts[index].name,
                                    productImage:
                                        searchedProducts[index].productPicture,
                                    // fontSize: 12,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 3,
                          left: 3,
                          child: Visibility(
                            visible: searchedProducts[index]
                                        .discountPercent
                                        .length !=
                                    0
                                ? true
                                : false,
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
    );
  }

  bool isListVisible = false, isFilterVisible = false;
  late bool noMore;
  List<SpecificationAttributeFilter> mList = [];

  Future searchProducts(String productName, int pageNumber, String minPrice,
      String maxPrice) async {
    // _refreshController.refreshToIdle();
    CustomProgressDialog progressDialog =
        CustomProgressDialog(context, blur: 2, dismissable: false);
    progressDialog.setLoadingWidget(SpinKitRipple(
      color: Colors.red,
      size: 90,
    ));

    Future.delayed(Duration.zero, () {
      progressDialog.show();
    });

    setState(() {
      noMore = false;
      searchedProducts.clear();
      isLoadVisible = true;
      isListVisible = false;
      _mainString = _selectedSeatsId + _selectedColorsId + _selectedFaimlyId;
    });
    final uri = Uri.parse(BuildConfig.base_url +
        'apis/GetSearch?keyword=$productName&pagesize=10&pageindex=$pageNumber&minPrice=$minPrice&maxPrice=$maxPrice&specId=$_mainString');

    print(uri);
    try {
      var response = await get(uri, headers: ApiCalls.header);
      var jsonMap = jsonDecode(response.body);
      print(jsonMap);
      if (mounted) if (jsonMap['ResponseData'] == null) {
        Fluttertoast.showToast(msg: 'No Product found');
        if (mounted)
          setState(() {
            isLoadVisible = false;
            isFilterVisible = true;
            noMore = true;
            progressDialog.dismiss();
          });
      } else {
        SearchResponse mySearchResponse = SearchResponse.fromJson(jsonMap);
        progressDialog.dismiss();

        if (mySearchResponse.responseData.getProductsByCategoryIdClasses ==
            null) {
          setState(() {
            noMore = true;
            isListVisible = false;
            isFilterVisible = true;
            isLoadVisible = false;
            progressDialog.dismiss();
          });
        } else {
          if (mounted)
            setState(() {
              isLoadVisible = false;
              isFilterVisible = true;
              progressDialog.dismiss();
              searchedProducts.addAll(
                  mySearchResponse.responseData.getProductsByCategoryIdClasses);
              mList =
                  mySearchResponse.responseData.specificationAttributeFilters;

              if (mList.length == 0) {
              } else {
                for (int i = 0; i <= mList.length - 1; i++) {
                  if (mList[i].name.contains('Number of Seats')) {
                    _numberOfSeatList.clear();
                    _numberOfSeatList = mList[i].specificationoptions;
                  }
                  if (mList[i].name.contains('Family')) {
                    _familyList.clear();
                    _familyList = mList[i].specificationoptions;
                  }
                  if (mList[i].name.contains('Colour')) {
                    _colorList.clear();

                    _colorList = mList[i].specificationoptions;
                  }
                }
              }

              isListVisible = true;
              totalCount = mySearchResponse.responseData.totalCount;
            });

          if (totalCount == 0) {
            setState(() {
              isListVisible = true;
              //
              progressDialog.dismiss();
              Fluttertoast.showToast(msg: 'No Products found');
            });
          } else if (searchedProducts.length ==
              mySearchResponse.responseData.totalCount) {
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
    progressDialog.dismiss();
  }

  List<Specificationoption> _colorList = [];
  List<Specificationoption> _numberOfSeatList = [];
  List<Specificationoption> _familyList = [];
  String _selectedSeats = '', _selectedColors = '', _selectedFaimly = '';
  String _selectedSeatsId = '',
      _selectedColorsId = '',
      _selectedFaimlyId = '',
      _mainString = '';
}
