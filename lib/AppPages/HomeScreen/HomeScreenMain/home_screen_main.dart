import 'dart:convert';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:ndialog/ndialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/AppPages/Categories/ProductList/SubCatProducts.dart';
import 'package:untitled2/AppPages/NewSubCategoryPage/NewSCategoryPage.dart';
import 'package:untitled2/AppPages/SearchPage/SearchPage.dart';
import 'package:untitled2/AppPages/StreamClass/NewPeoductPage/NewProductScreen.dart';
import 'package:untitled2/AppPages/WebxxViewxx/TopicPagexx.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';
import 'package:untitled2/utils/HeartIcon.dart';
import 'package:untitled2/utils/NewIcons.dart';
import 'package:untitled2/utils/models/homeresponse.dart';
import 'package:untitled2/utils/utils/build_config.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreenMain extends StatefulWidget {
  _HomeScreenMainState createState() => _HomeScreenMainState();

  HomeScreenMain({Key? key}) : super(key: key);
}

class _HomeScreenMainState extends State<HomeScreenMain> {
  String bannerImage = '';
  List<ServicesModel> modelList = [];
  List<Bannerxx> banners = [];
  List<HomePageCategoriesImage> categoryList = [];
  List<HomePageProductImage> productList = [];
  AssetImage assetImage = AssetImage("MyAssets/imagebackground.png");
  List<Widget> viewsList = [];
  int activeIndex = 0;
  bool showLoading = true;
  bool categoryVisible = false;
  List<SocialModel> socialLinks = [];

  TextEditingController _searchController = TextEditingController();
  var _focusNode = FocusNode();

  var isVisible = false;

  Color btnColor = Colors.black;

  var _suggestController = ScrollController();

  String _titleName = '';
  ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  @override
  void initState() {
    super.initState();
    // ApiCa readCounter(customerGuid: gUId).then((value) => context.read<cartCounter>().changeCounter(value));
    getSocialMediaLink();
    getApiToken().then((value) => apiCallToHomeScreen(value));
  }

  @override
  void didUpdateWidget(covariant HomeScreenMain oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    buildSafeArea(context);
  }

  void _launchURL(String _url) async => await canLaunch(_url)
      ? await launch(_url)
      : Fluttertoast.showToast(msg: 'Could not launch $_url');

  // @override
  // void didUpdateWidget (
  //     )
  //
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
      child: Scaffold(
        body: buildSafeArea(context),
      ),
    );
  }

  Widget buildSafeArea(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

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
                                  return ConstantsVar.suggestionList
                                      .where((String option) {
                                    return option.toLowerCase().contains(
                                        new RegExp(
                                            textEditingValue.text.toLowerCase(),
                                            caseSensitive: false));
                                  });
                                },
                                onSelected: (String selection) {
                                  debugPrint('$selection selected');
                                },
                                fieldViewBuilder: (BuildContext context,
                                    TextEditingController textEditingController,
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
                                          Navigator.of(context).push(
                                            CupertinoPageRoute(
                                              builder: (context) => SearchPage(
                                                isScreen: true,
                                                keyword: value,
                                              ),
                                            ),
                                          );
                                        });

                                      print('Pressed via keypad');
                                    },
                                    textInputAction: isVisible
                                        ? TextInputAction.done
                                        : TextInputAction.search,
                                    // keyboardType: TextInputType.,
                                    keyboardAppearance: Brightness.light,
                                    // autofocus: true,
                                    onChanged: (_) => setState(() {
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
                                                  if (index >= options.length) {
                                                    return Align(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      child: TextButton(
                                                        child: const Text(
                                                          'Clear',
                                                          style: TextStyle(
                                                            color: ConstantsVar
                                                                .appColor,
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                                      options.elementAt(index);
                                                  return InkWell(
                                                      onTap: () {
                                                        onSelected(option);
                                                        Navigator.push(
                                                          context,
                                                          CupertinoPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    SearchPage(
                                                              keyword: option,
                                                              isScreen: true,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: Container(
                                                        height: 5.8.h,
                                                        width: 95.w,
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
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
                                                                  fontSize: 16,
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
                                    child: ListView.builder(
                                        controller: _scrollController,
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        // padding: EdgeInsets.symmetric(vertical:6),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: productList.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return listContainer(
                                              productList[index]);
                                        }),
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
                              // Container(
                              //   width: 30.w,
                              //   child: Divider(
                              //     thickness: 4,
                              //     color: ConstantsVar.appColor,
                              //   ),
                              // ),
                              Container(
                                width: 100.w,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: modelList
                                        .map((e) => InkWell(
                                              onTap: () => e.desc.trim() != ''
                                                  ? Navigator.push(
                                                      context,
                                                      CupertinoPageRoute(
                                                        builder: (context) =>
                                                            TopicPage(
                                                          paymentUrl: e.desc,
                                                        ),
                                                      ),
                                                    )
                                                  : null,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: AssetImage(
                                                              e.imageName),
                                                          fit: BoxFit.fill,
                                                        ),

                                                      ),
                                                      width: 180,
                                                      height: 180,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 2.0,
                                                        vertical: 11,
                                                      ),
                                                      child: Container(
                                                        width: 180,
                                                        child: AutoSizeText(
                                                          e.shortDesc,
                                                          maxLines: 1,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ))
                                        .toList(),
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
                                    fontSize: 4.2.w,
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
                              AutoSizeText(
                                'Get news and inspiration and much more.',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 4.2.w,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: 100.w,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: socialLinks
                                        .map((e) => InkWell(
                                            onTap: () => _launchURL(e.url),
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
    );
  }

  // Stack homeView(){
  //   return
  // }
  void getSocialMediaLink() {
    socialLinks.add(
      new SocialModel(
        icon: Icon(
          Icons.facebook,
          color:Colors.black,
          size: 48,
        ),
        url: 'https://www.facebook.com/THEOnePlanet/',
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
                    child: CachedNetworkImage(
                      imageUrl: list.imageUrl[0],
                      fit: BoxFit.fill,
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
            visible: list.discountPercentage.trim().length != 0 ? true : false,
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

  /* Api call to home screen */
  Future<http.Response> apiCallToHomeScreen(String value) async {
    var guestCustomerId = ConstantsVar.prefs.getString('guestGUID')!;
    CustomProgressDialog progressDialog =
        CustomProgressDialog(context, blur: 2, dismissable: false);
    progressDialog.setLoadingWidget(SpinKitRipple(
      color: Colors.red,
      size: 90,
    ));
    progressDialog.show();
    String url =
        BuildConfig.base_url + BuildConfig.banners + '?apiToken=' + '$value';

    print('home_url $url');

    final response = await http.get(
      Uri.parse(url),
      headers: ApiCalls.header,
    );

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
        _titleName = homeResponse.homepageProductsTitle;
        banners = homeResponse.banners;
        mounted
            ? setState(() {
                var products = homeResponse.homePageProductImage;
                var categories = homeResponse.homePageCategoriesImage;
                if (products.length > 0) {
                  productList = products;
                  categoryList = categories;
                  categoryVisible = true;
                  getServiceList();

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

                    progressDialog.dismiss();
                  }
                }
              })
            : null;
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

  Widget categroryLeftView(
      String name, String imageUrl, final categoryId, final type) {
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
              child: Container(
                  width: Adaptive.w(45),
                  height: Adaptive.w(45),
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
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) {
                    return ProductList(
                      categoryId: '$categoryId',
                      title: name,
                    );
                  }));
                }
              },
              child: Container(
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
                              vertical: 10.w, horizontal: 5.w),
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
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  width: 15.w,
                                  child:
                                      Divider(height: 2, color: Colors.white),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: AutoSizeText('Shop Now',
                                    style: TextStyle(color: Colors.grey),
                                    textAlign: TextAlign.center),
                              ),
                            ],
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
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        width: 100.w,
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
              child: Container(
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
                              vertical: 10.w, horizontal: 8.w),
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
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  width: 15.w,
                                  child:
                                      Divider(height: 2, color: Colors.white),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: AutoSizeText('Shop Now',
                                    style: TextStyle(color: Colors.grey),
                                    textAlign: TextAlign.center),
                              ),
                            ],
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
              child: Container(
                  width: Adaptive.w(45),
                  height: Adaptive.w(45),
                  child:
                      CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.fill)),
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

  void getServiceList() {
    modelList.add(
      new ServicesModel(
        desc: 'https://www.theone.com/delivery-assembly-4',
        imageName: 'ServicesImages/delivery_icon.jpg',
        shortDesc: 'Delivery & Assembly',
      ),
    );
    modelList.add(
      new ServicesModel(
        desc: 'https://www.theone.com/home-styling-2',
        imageName: 'ServicesImages/hs_icon.jpg',
        shortDesc: 'Home Styling',
      ),
    );

    modelList.add(
      new ServicesModel(
        desc: '',
        imageName: 'ServicesImages/designer_card_icon.jpg',
        shortDesc: 'Designer One Card',
      ),
    );

    modelList.add(
      new ServicesModel(
        desc: 'https://www.theone.com/easy-payment-plan-options-2',
        imageName: 'ServicesImages/easy_payment_icon.jpg',
        shortDesc: 'Easy Payment Plan',
      ),
    );
    setState(() {});
  }
}
//Please wait for few seconds

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
