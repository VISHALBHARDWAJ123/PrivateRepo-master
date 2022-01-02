import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:ui';
import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:ndialog/ndialog.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/AppPages/Categories/ProductList/SubCatProducts.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreenMain/SearchSuggestions/SearchSuggestion.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreenMain/TopicPageResponse/TopicPageResponse.dart';
import 'package:untitled2/AppPages/NewSubCategoryPage/NewSCategoryPage.dart';
import 'package:untitled2/AppPages/SearchPage/SearchPage.dart';
import 'package:untitled2/AppPages/StreamClass/NewPeoductPage/NewProductScreen.dart';
import 'package:untitled2/AppPages/THEOneAds/AdsResponse.dart';
import 'package:untitled2/AppPages/THEOneAds/TheOneAdd.dart';
import 'package:untitled2/AppPages/WebxxViewxx/TopicPagexx.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';

// import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';
import 'package:untitled2/utils/NewIcons.dart';
import 'package:untitled2/utils/models/homeresponse.dart';
import 'package:untitled2/utils/utils/build_config.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';

import 'RecentlyViewedProductResponse.dart';

class HomeScreenMain extends StatefulWidget {
  _HomeScreenMainState createState() => _HomeScreenMainState();

  HomeScreenMain({Key? key}) : super(key: key);
}

class _HomeScreenMainState extends State<HomeScreenMain> with WidgetsBindingObserver {

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        print('appLifeCycleState inactive');
        break;
      case AppLifecycleState.resumed:
        print('appLifeCycleState resumed');
        break;
      case AppLifecycleState.paused:
        print('appLifeCycleState paused');
        break;

    }
  }


  String bannerImage = '';
  List<TopicItems> modelList = [];
  List<Bannerxx> banners = [];
  List<HomePageCategoriesImage> categoryList = [];
  List<HomePageProductImage> productList = [];
  AssetImage assetImage = AssetImage("MyAssets/imagebackground.png");
  List<Widget> viewsList = [];
  int activeIndex = 0;
  bool showLoading = true;
  bool categoryVisible = false;
  List<SocialModel> socialLinks = [];
  List<String> searchSuggestions = [];
  var userId;
  List<Product> products = [];

  TextEditingController _searchController = TextEditingController();
  var _focusNode = FocusNode();

  var isVisible = false;

  Color btnColor = Colors.black;

  var _suggestController = ScrollController();

  String _titleName = '';

  // ScrollController _scrollController = ScrollController();
  String listString = '';
  var cokkie;

  late ScrollController _productController,
      _serviceController,
      _recentlyProductController;
  ContainerTransitionType _transitionType = ContainerTransitionType.fade;

  var isVisibled = false;

  var apiToken = '';
  List<String> _productIds = [];

  var _refreshController = RefreshController();

  // var _recentlyProductController;

  Future initSharedPrefs() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();

    setState(() {});
  }

  @override
  void initState() {
    initSharedPrefs().whenComplete(() => getRecentlyViewedProduct());
    _productController = new ScrollController();
    _recentlyProductController = new ScrollController();
    _serviceController =
    new ScrollController(initialScrollOffset: modelList.length + 30.w);
    // ApiCa readCounter(customerGuid: gUId).then((value) => context.read<cartCounter>().changeCounter(value));
    getSocialMediaLink();

    getApiToken().then((value) {
      if (mounted) setState(() {});

      showAdDialog().whenComplete(() => apiCallToHomeScreen(value));
    });
    setState(() {});
    super.initState();
  }

  Future showAdDialog() async {
    setState(() {
      userId = ConstantsVar.prefs.getString('email');
    });
    print('I am triggered ');
    CustomProgressDialog progressDialog =
    CustomProgressDialog(context, blur: 2, dismissable: false);
    progressDialog.setLoadingWidget(SpinKitRipple(
      color: Colors.red,
      size: 90,
    ));
    progressDialog.show();
    final url = Uri.parse(BuildConfig.base_url + 'apis/GetHomeScreenPopup');
    try {
      var response = await get(url, headers: ApiCalls.header);
      progressDialog.dismiss();
      setState(() {
        AdsResponse adsResponse = AdsResponse.fromJson(
          jsonDecode(response.body),
        );
        if (adsResponse.active == true &&
            adsResponse.status.contains('Success') &&
            (userId == null || userId == '')) {
          showDialog(
            // barrierColor: Colors.transparent,
              builder: (BuildContext context) {
                return isVisibled
                    ? Container()
                    : AdsDialog(
                  responseHtml: adsResponse.responseData,
                );
              },
              context: context)
              .then((value) => progressDialog.dismiss());
        }
      });
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      progressDialog.dismiss();
    }
  }

  void _launchURL(String _url) async {
    if (_url.contains('fb')) {
      Platform.isIOS ? forIos(_url) : forAndroid(_url);
    } else {
      await canLaunch(_url)
          ? await launch(
        _url,
        forceWebView: false,
        forceSafariVC: false,
      )
          : Fluttertoast.showToast(msg: 'Could not launch $_url');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _suggestController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      maintainBottomViewPadding: true,
      child: Scaffold(
        body: buildSafeArea(context),
      ),
    );
  }

  Widget buildSafeArea(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanDown: (_) {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      onTap: () {
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Container(
        color: Colors.black,
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: <Widget>[
            Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: .1,
                    child: Container(
                      height: 50.h,
                      child: Image.asset(
                        "MyAssets/banner.jpg",
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  Container(
                    height: 100.h,
                    child: ListView(
                      keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                      // physics: NeverScrollableScrollPhysics(),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 6),
                          child: Container(
                            width: 100.w,
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Hero(
                                tag: 'HomeImage',
                                transitionOnUserGestures: true,
                                child: Image.asset('MyAssets/logo.png',
                                    fit: BoxFit.fill,
                                    width: Adaptive.w(14),
                                    height: Adaptive.w(14)),
                              ),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                child: RawAutocomplete<String>(
                                  optionsBuilder:
                                      (TextEditingValue textEditingValue) {
                                    if (textEditingValue.text == null ||
                                        textEditingValue.text == '' ||
                                        textEditingValue.text.length < 3) {
                                      return const Iterable<String>.empty();
                                    }
                                    return searchSuggestions
                                        .where((String option) {
                                      return option.toLowerCase().contains(
                                          new RegExp(
                                              textEditingValue.text
                                                  .toLowerCase(),
                                              caseSensitive: false));
                                    });
                                  },
                                  onSelected: (String selection) {
                                    if (!currentFocus.hasPrimaryFocus) {
                                      currentFocus.unfocus();
                                    }
                                    debugPrint('$selection selected');
                                  },
                                  fieldViewBuilder: (BuildContext context,
                                      TextEditingController
                                      textEditingController,
                                      FocusNode focusNode,
                                      VoidCallback onFieldSubmitted) {
                                    _searchController = textEditingController;
                                    _focusNode = focusNode;
                                    // FocusScopeNode currentFocus = FocusScopeNode.of(context);
                                    return TextFormField(
                                      autocorrect: true,
                                      enableSuggestions: true,
                                      onFieldSubmitted: (val) {
                                        focusNode.unfocus();
                                        if (currentFocus.hasPrimaryFocus) {
                                          currentFocus.unfocus();
                                        }
                                        if (mounted)
                                          setState(() {
                                            var value = _searchController.text;
                                            Navigator.of(context)
                                                .push(
                                              CupertinoPageRoute(
                                                builder: (context) =>
                                                    SearchPage(
                                                      isScreen: true,
                                                      keyword: value,
                                                      enableCategory: false,
                                                    ),
                                              ),
                                            )
                                                .then((value) =>
                                                setState(() {
                                                  _searchController.clear();
                                                }));
                                          });

                                        print('Pressed via keypad');
                                      },
                                      textInputAction: isVisible
                                          ? TextInputAction.done
                                          : TextInputAction.search,
                                      // keyboardType: TextInputType.,
                                      keyboardAppearance: Brightness.light,
                                      // autofocus: true,
                                      onChanged: (_) =>
                                          setState(() {
                                            btnColor = ConstantsVar.appColor;
                                          }),
                                      controller: _searchController,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 5.w),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 13, horizontal: 10),
                                        hintText: 'Search here',
                                        labelStyle: TextStyle(
                                            fontSize: 7.w, color: Colors.grey),
                                        suffixIcon: InkWell(
                                          onTap: () async {
                                            focusNode.unfocus();

                                            if (!currentFocus.hasPrimaryFocus) {
                                              currentFocus.unfocus();
                                            }
                                            if (mounted)
                                              setState(() {
                                                var value =
                                                    _searchController.text;
                                                Navigator.of(context).push(
                                                  CupertinoPageRoute(
                                                    builder: (context) =>
                                                        SearchPage(
                                                          isScreen: true,
                                                          keyword: value,
                                                          enableCategory: false,
                                                        ),
                                                  ),
                                                );
                                              });
                                          },
                                          child: Icon(Icons.search_sharp),
                                        ),
                                      ),
                                      focusNode: _focusNode,
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
                                                      (BuildContext context,
                                                      int index) {
                                                    if (index >=
                                                        options.length) {
                                                      return Align(
                                                        alignment: Alignment
                                                            .bottomCenter,
                                                        child: TextButton(
                                                          child: const Text(
                                                            'Clear',
                                                            style: TextStyle(
                                                              color:
                                                              ConstantsVar
                                                                  .appColor,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            _searchController
                                                                .clear();
                                                          },
                                                        ),
                                                      );
                                                    }
                                                    final String option =
                                                    options
                                                        .elementAt(index);
                                                    return InkWell(
                                                        onTap: () {
                                                          if (!currentFocus
                                                              .hasPrimaryFocus) {
                                                            currentFocus
                                                                .unfocus();
                                                          }
                                                          onSelected(option);
                                                          Navigator.push(
                                                            context,
                                                            CupertinoPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                  SearchPage(
                                                                    keyword: option,
                                                                    isScreen: true,
                                                                    enableCategory:
                                                                    false,
                                                                  ),
                                                            ),
                                                          ).then((value) =>
                                                              setState(() {
                                                                _searchController
                                                                    .clear();
                                                              }));
                                                        },
                                                        child: Container(
                                                          height: 5.8.h,
                                                          width: 95.w,
                                                          child: Column(
                                                            mainAxisSize:
                                                            MainAxisSize
                                                                .min,
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              Container(
                                                                width: 100.w,
                                                                child:
                                                                AutoSizeText(
                                                                  '  ' + option,
                                                                  style:
                                                                  TextStyle(
                                                                    fontSize:
                                                                    16,
                                                                    wordSpacing:
                                                                    2,
                                                                    letterSpacing:
                                                                    1,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                width: 100.w,
                                                                child: Divider(
                                                                  thickness: 1,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade400,
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
                                                builder: (context) =>
                                                    ProductList(
                                                        categoryId: banner.id,
                                                        title: ''),
                                              ),
                                            );
                                          }
                                        },
                                        child: Container(
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 2.0),
                                            child: Container(
                                              child: CachedNetworkImage(
                                                imageUrl: banner.imageUrl,
                                                fit: BoxFit.fill,
                                                placeholder:
                                                    (context, reason) =>
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
                            Visibility(
                              visible: !showLoading,
                              child: Container(
                                padding:
                                const EdgeInsets.symmetric(vertical: 7.0),
                                color: Colors.white,
                                height: 60.w,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        child: Column(
                                          children: [
                                            AutoSizeText(
                                              _titleName.toUpperCase(),
                                              style: TextStyle(
                                                shadows: <Shadow>[
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
                                                ],
                                                fontSize: 5.w,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: VsScrollbar(
                                        style: VsScrollbarStyle(thickness: 3.5),
                                        controller: _productController,
                                        isAlwaysShown: true,
                                        child: ListView.builder(
                                            controller: _productController,
                                            clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                            // padding: EdgeInsets.symmetric(vertical:6),
                                            scrollDirection: Axis.horizontal,
                                            itemCount: productList.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return listContainer(
                                                  productList[index]);
                                            }),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Visibility(
                              visible: categoryVisible,
                              child: Container(
                                color: Colors.white,
                                padding: EdgeInsets.all(4),
                                // margin: EdgeInsets.all(10),
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.max,
                                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: viewsList,
                                ),
                              ),
                            ),
                            Visibility(
                              visible: products.length == 0 ? false : true,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 7.0),
                                color: Colors.white,
                                height: 60.w,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                      const EdgeInsets.all(8.0),
                                      child: Container(
                                        child: Column(
                                          children: [
                                            AutoSizeText(
                                              'Recently Viewed'
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                shadows: <Shadow>[
                                                  Shadow(
                                                    offset: Offset(
                                                        1.0, 1.2),
                                                    blurRadius: 3.0,
                                                    color: Colors
                                                        .grey
                                                        .shade300,
                                                  ),
                                                  Shadow(
                                                    offset: Offset(
                                                        1.0, 1.2),
                                                    blurRadius: 8.0,
                                                    color: Colors
                                                        .grey
                                                        .shade300,
                                                  ),
                                                ],
                                                fontSize: 5.w,
                                                fontWeight:
                                                FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: VsScrollbar(
                                        style: VsScrollbarStyle(
                                            thickness: 3.5),
                                        controller:
                                        _recentlyProductController,
                                        isAlwaysShown: true,
                                        child: ListView.builder(
                                            controller:
                                            _recentlyProductController,
                                            clipBehavior: Clip
                                                .antiAliasWithSaveLayer,
                                            // padding: EdgeInsets.symmetric(vertical:6),
                                            scrollDirection:
                                            Axis.horizontal,
                                            itemCount: products.length,
                                            itemBuilder:
                                                (BuildContext context,
                                                int index) {
                                              return _listContainer(
                                                  products[index]);
                                            }),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Visibility(
                          visible: categoryVisible,
                          child: Container(
                            color: Colors.white,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 8.0,
                                    bottom: 8.0,
                                  ),
                                  child: AutoSizeText(
                                    'Our Services'.toUpperCase(),
                                    style: TextStyle(
                                        shadows: <Shadow>[
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
                                        ],
                                        fontSize: 5.w,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                VsScrollbar(
                                  controller: _serviceController,
                                  style: VsScrollbarStyle(thickness: 3.5),
                                  isAlwaysShown: true,
                                  child: SingleChildScrollView(
                                    controller: _serviceController,
                                    scrollDirection: Axis.horizontal,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6.0),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: modelList
                                            .map((e) =>
                                            Padding(
                                              padding:
                                              const EdgeInsets.all(5.0),
                                              child: OpenContainer(
                                                closedElevation: 0,
                                                openElevation: 0,
                                                transitionType:
                                                _transitionType,
                                                openBuilder: (BuildContext
                                                context,
                                                    void Function(
                                                        {Object?
                                                        returnValue})
                                                    action) {
                                                  return TopicPage(
                                                    paymentUrl: e.url,
                                                  );
                                                },
                                                closedBuilder:
                                                    (BuildContext context,
                                                    void Function()
                                                    action) {
                                                  return Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                    children: [
                                                      Container(
                                                        decoration:
                                                        BoxDecoration(
                                                          image:
                                                          DecorationImage(
                                                            image: CachedNetworkImageProvider(
                                                                e.imagePath),
                                                            fit:
                                                            BoxFit.fill,
                                                          ),
                                                        ),
                                                        width: Adaptive.w(
                                                            43.6),
                                                        height:
                                                        Adaptive.w(45),
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                          horizontal: 2.0,
                                                          vertical: 11,
                                                        ),
                                                        child: Container(
                                                          width: 45.w,
                                                          child:
                                                          AutoSizeText(
                                                            e.textToDisplay,
                                                            maxLines: 1,
                                                            textAlign:
                                                            TextAlign
                                                                .center,
                                                            style:
                                                            TextStyle(
                                                              color: Colors
                                                                  .grey,
                                                              fontSize: 14,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ),
                                            ))
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: categoryVisible,
                          child: Container(
                            color: Colors.white,
                            width: 100.w,
                            height: 150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: AutoSizeText(
                                    'Follow us!'.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 5.w,
                                      fontWeight: FontWeight.bold,
                                      shadows: <Shadow>[
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
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: 100.w,
                                  child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: socialLinks
                                          .map((e) =>
                                          InkWell(
                                              onTap: () async =>
                                                  _launchURL(e.url),
                                              child: Padding(
                                                padding:
                                                const EdgeInsets.symmetric(
                                                  horizontal: 6.0,
                                                ),
                                                child: e.icon,
                                              )))
                                          .toList()),
                                ),
                                SizedBox(
                                  height: 10,
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
          ],
        ),
      ),
    );
  }


  void getSocialMediaLink() {
    socialLinks.add(
      new SocialModel(
        icon: Icon(
          Icons.facebook,
          color: Colors.black.withOpacity(.8),
          size: 48,
        ),
        url: 'fb://page/10150150309565478',
        color: Colors.white,
      ),
    );
    socialLinks.add(
      new SocialModel(
        icon: Icon(
          NewIcons.pinterest__1_,
          size: 42,
        ),
        url: 'https://in.pinterest.com/theoneplanet/_created/',
        color: Colors.red.shade800,
      ),
    );

    socialLinks.add(new SocialModel(
      icon: Icon(
        NewIcons.instagram__8_,
        size: 42,
        // color: Colors.redAccent,
      ),
      url: 'https://www.instagram.com/theoneplanet/',
      color: Colors.white,
    ));
    socialLinks.add(
      new SocialModel(
        icon: Icon(
          NewIcons.youtube__1_,
          size: 42,
        ),
        url: 'https://www.youtube.com/user/theoneplanet',
        color: Colors.red.shade800,
      ),
    );
    setState(() {});
  }

  InkWell listContainer(HomePageProductImage list) {
    return InkWell(
      onTap: () {
        print('${list.id}');
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return new NewProductDetails(
            // customerId: ConstantsVar.customerID,
            productId: list.id, screenName: 'Home Screen',
          );
        }));
      },
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            // height: Adaptive.w(50),
            color: Colors.white,
            width: Adaptive.w(34),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Container(
                    color: Colors.white,
                    width: 33.w,
                    padding: EdgeInsets.all(1.w),
                    height: 33.w,
                    // width: Adaptive.w(32),
                    // height: Adaptive.w(40),
                    child: Hero(
                      tag: 'ProductImage${list.id}',
                      transitionOnUserGestures: true,
                      child: CachedNetworkImage(
                        imageUrl: list.imageUrl[0],
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 36.w,
                  child: Center(
                    child: AutoSizeText(
                      list.price.splitBefore('incl'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        wordSpacing: 4,
                        color: Colors.grey,
                        fontSize: 4.1.w,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: list.discountPercentage
                .trim()
                .length != 0 ? true : false,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Align(
                  alignment: Alignment.topLeft,
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
                            list.discountPercentage,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 3.w,
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
      ),
    );
  }

  InkWell _listContainer(Product list) {
    return InkWell(
      onTap: () {
        print('${list.id}');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return new NewProductDetails(
                // customerId: ConstantsVar.customerID,
                productId: list.id, screenName: 'Home Screen',
              );
            },
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            // height: Adaptive.w(50),
            color: Colors.white,
            width: Adaptive.w(34),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Container(
                    color: Colors.white,
                    width: 33.w,
                    padding: EdgeInsets.all(1.w),
                    height: 33.w,
                    // width: Adaptive.w(32),
                    // height: Adaptive.w(40),
                    child: Hero(
                      tag: 'ProductImage${list.id}',
                      transitionOnUserGestures: true,
                      child: CachedNetworkImage(
                        imageUrl: list.imageUrl[0],
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 36.w,
                  child: Center(
                    child: AutoSizeText(
                      list.price.splitBefore('incl'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        wordSpacing: 4,
                        color: Colors.grey,
                        fontSize: 4.1.w,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: list.discountPercent != null ? true : false,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Align(
                  alignment: Alignment.topLeft,
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
                            list.discountPercent.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 3.w,
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
      ),
    );
  }

  Future getRecentlyViewedProduct() async {
    _productIds = ConstantsVar.prefs.getStringList('RecentProducts')!;
    // _productIds = List<String>.from(dynamicList).toList();
    apiToken = ConstantsVar.prefs.getString('apiTokken')!;
    print('Hello There' + _productIds.join(','));
    setState(() {});
    final url =
    Uri.parse(BuildConfig.base_url + 'apis/GetRecentlyViewedProducts');
    print('.Nop.RecentlyViewedProducts=${_productIds.join(',')}');
    try {
      var jsonResponse = await http.get(
        url,
        headers: {
          'Cookie': '.Nop.Customer=$apiToken',
          "Cookie": '.Nop.RecentlyViewedProducts=${_productIds.join('%2C')}',
        },
      );
      if (jsonDecode(jsonResponse.body)['status'].contains('Success')) {
        RecentlyViewProductResponse _result =
        RecentlyViewProductResponse.fromJson(
          jsonDecode(jsonResponse.body),
        );
        products = _result.products;
        _refreshController.refreshCompleted();
        setState(() {});
      } else {
        products = [];
        _refreshController.refreshCompleted();
        setState(() {});
      }
      print('Recently Viewed Products>>>>>>>>>>>>>>>>>>>>' + jsonResponse.body);
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      products = [];
      _refreshController.refreshCompleted();
      setState(() {});
    }
  }

  /* Api call to home screen */
  Future<http.Response> apiCallToHomeScreen(String value) async {
    getSearchSuggestions();
    getTopicPage();
    // ApiCalls.getRecentlyViewedProduct();
    // var guestCustomerId = ConstantsVar.prefs.getString('guestGUID')!;
    CustomProgressDialog progressDialog =
    CustomProgressDialog(context, blur: 2, dismissable: false);
    progressDialog.setLoadingWidget(SpinKitRipple(
      color: Colors.red,
      size: 90,
    ));
    progressDialog.show();
    String url = BuildConfig.base_url + BuildConfig.banners;

    print('home_url $url');

    final response = await http.get(
      Uri.parse(url),
      headers: ApiCalls.header,
    );
// response.headers
    if (response.statusCode == 200) {
      const start = "samesite=lax,";
      const end = "; expires";

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
        _titleName = homeResponse.homepageProductsTitle;
        banners = homeResponse.banners;
        mounted
            ? setState(() {
          var products = homeResponse.homePageProductImage;
          var categories = homeResponse.homePageCategoriesImage;
          if (products.length > 0) {
            productList = products;
            categoryList = categories;
            String _categoryString = jsonEncode(categoryList);
            String _productString = jsonEncode(productList);
            ConstantsVar.prefs.setString('productString', _productString);
            ConstantsVar.prefs
                .setString('categoryString', _categoryString);
            categoryVisible = true;
            // getServiceList();

            for (var i = 0; i < categoryList.length; i++) {
              if (i % 2 == 0) {
                viewsList.add(
                  categroryLeftView(
                      categoryList[i].name,
                      categoryList[i].imageUrl,
                      categoryList[i].id,
                      categoryList[i].isSubCategory),
                );
              } else {
                viewsList.add(
                  categoryRightView(
                      categoryList[i].name,
                      categoryList[i].imageUrl,
                      categoryList[i].id,
                      categoryList[i].isSubCategory),
                );
              }

              progressDialog.dismiss();
            }
          }
        })
            : viewsList.add(
          Container(
            child: Text('Something Went Wrong'),
          ),
        );
      }
      progressDialog.dismiss();
    } else {
      setState(() {
        showLoading = false;
      });
    }
    progressDialog.dismiss();

    return response;
  }

  Widget categroryLeftView(String name, String imageUrl, final categoryId,
      final type) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),

      // padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 100.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            OpenContainer(
              tappable: true,
              closedElevation: 0,
              openElevation: 0,
              transitionType: _transitionType,
              closedBuilder: (BuildContext context, void Function() action) {
                return Container(
                  width: Adaptive.w(45),
                  height: Adaptive.w(45),
                  child:
                  CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.fill),
                );
              },
              openBuilder: (BuildContext context,
                  void Function({Object? returnValue}) action) {
                if (type == true) {
                  return SubCatNew(
                    catId: '$categoryId',
                    title: name,
                  );
                } else {
                  return ProductList(
                    categoryId: '$categoryId',
                    title: name,
                  );
                }
              },
            ),
            OpenContainer(
              tappable: true,
              closedElevation: 0,
              openElevation: 0,
              transitionType: _transitionType,
              openBuilder: (BuildContext context,
                  void Function({Object? returnValue}) action) {
                if (type == true) {
                  return SubCatNew(
                    catId: '$categoryId',
                    title: name,
                  );
                } else {
                  return ProductList(
                    categoryId: '$categoryId',
                    title: name,
                  );
                }
              },
              closedBuilder: (BuildContext context, void Function() action) {
                return Container(
                  width: Adaptive.w(48),
                  height: Adaptive.w(45),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Container(
                          width: Adaptive.w(48),
                          height: Adaptive.w(45),
                          color: Colors.black,
                          // height: 12.h,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.w, horizontal: 4.w),
                            child: Center(
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  AutoSizeText(
                                    name.toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Padding(
                                    padding:
                                    EdgeInsets.symmetric(vertical: 8.0),
                                    child: Container(
                                      width: 15.w,
                                      child: Divider(
                                          height: 2, color: Colors.white),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                    EdgeInsets.symmetric(vertical: 8.0),
                                    child: AutoSizeText('Shop Now',
                                        style: TextStyle(color: Colors.grey),
                                        textAlign: TextAlign.center),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            width: 5.w,
                            height: 5.w,
                            child: Image.asset('MyAssets/icon.png')),
                      )
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget categoryRightView(String name, String imageUrl, final categoryId,
      final type) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        width: 100.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            OpenContainer(
              tappable: true,
              closedElevation: 0,
              openElevation: 0,
              transitionType: _transitionType,
              openBuilder: (BuildContext context,
                  void Function({Object? returnValue}) action) {
                if (type == true) {
                  return SubCatNew(
                    catId: '$categoryId',
                    title: name,
                  );
                } else {
                  return ProductList(
                    categoryId: '$categoryId',
                    title: name,
                  );
                }
              },
              closedBuilder: (BuildContext context, void Function() action) {
                return Container(
                  width: Adaptive.w(48),
                  height: Adaptive.w(45),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 11.0),
                        child: Container(
                          width: Adaptive.w(48),
                          height: Adaptive.w(45),
                          color: Colors.black,
                          // height: 12.h,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.w, horizontal: 4.w),
                            child: Center(
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  AutoSizeText(
                                    name.toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Padding(
                                    padding:
                                    EdgeInsets.symmetric(vertical: 8.0),
                                    child: Container(
                                      width: 15.w,
                                      child: Divider(
                                          height: 2, color: Colors.white),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                    EdgeInsets.symmetric(vertical: 8.0),
                                    child: AutoSizeText('Shop Now',
                                        style: TextStyle(color: Colors.grey),
                                        textAlign: TextAlign.center),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                            width: 10.w,
                            height: 10.w,
                            child: Image.asset(
                              'MyAssets/icon1.png',
                              fit: BoxFit.fill,
                            )),
                      )
                    ],
                  ),
                );
              },
            ),
            OpenContainer(
              tappable: true,
              closedElevation: 0,
              openElevation: 0,
              transitionType: _transitionType,
              closedBuilder: (BuildContext context, void Function() action) {
                return Container(
                  width: Adaptive.w(45),
                  height: Adaptive.w(45),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.fill,
                  ),
                );
              },
              openBuilder: (BuildContext context,
                  void Function({Object? returnValue}) action) {
                if (type == true) {
                  return SubCatNew(
                    catId: '$categoryId',
                    title: name,
                  );
                } else {
                  return ProductList(
                    categoryId: '$categoryId',
                    title: name,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future getApiToken() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
    // setState(() {});

    return ConstantsVar.prefs.get('apiTokken');
  }

  void navigate(Widget className) =>
      Navigator.push(
          context, CupertinoPageRoute(builder: (context) => className));

  void getSearchSuggestions() async {
    final uri = Uri.parse(BuildConfig.base_url + 'apis/GetActiveUAECategories');

    var response = await http.get(
      uri,
      headers: ApiCalls.header,
    );
    try {
      var result = jsonDecode(response.body);
      SearchSuggestionResponse suggestions =
      SearchSuggestionResponse.fromJson(result);
      print(suggestions.status);
      for (int i = 0; i < suggestions.responseData.length; i++) {
        searchSuggestions.add(suggestions.responseData[i].name);
      }
      listString = jsonEncode(searchSuggestions);
      print(listString);
      ConstantsVar.prefs.setString('searchList', listString);
      setState(() {});
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }

  Future getTopicPage() async {
    final uri = Uri.parse(BuildConfig.base_url + 'apis/GetAppTopics');
    try {
      var response = await http.get(uri, headers: ApiCalls.header);
      TopicPageResponse result = TopicPageResponse.fromJson(
        jsonDecode(response.body),
      );
      modelList = result.responseData;

      setState(() {});
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }

  forIos(String _url) async {
    await canLaunch(_url)
        ? await launch(
      _url,
      forceWebView: false,
      forceSafariVC: false,
    )
        : await launch(
      'fb://profile/10150150309565478',
      forceWebView: false,
      forceSafariVC: false,
    );
  }

  forAndroid(String _url) async {
    await canLaunch(_url)
        ? await launch(
      _url,
      forceWebView: false,
      forceSafariVC: false,
    )
        : Fluttertoast.showToast(msg: 'Could not launch $_url');
  }

  final itemSize = 45.w;


}
class ServicesModel {
  String desc;
  String shortDesc;
  String imageName;

  ServicesModel({
    required this.desc,
    required this.imageName,
    required this.shortDesc,
  });
}

class SocialModel {
  String url;
  Icon icon;
  Color color;

  SocialModel({
    required this.url,
    required this.icon,
    required this.color,
  });
}
