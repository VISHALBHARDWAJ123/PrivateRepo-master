import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/AppPages/CartxxScreen/CartScreen2.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/StreamClass/NewPeoductPage/NewProductScreen.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/Widgets/CustomButton.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';
import 'package:untitled2/utils/CartBadgeCounter/CartBadgetLogic.dart';
import 'package:untitled2/utils/HeartIcon.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  var wishlistProvider;

  @override
  initState() {
    initSharedPrefs();
    super.initState();
  }

  String apiToken = '';
  String customerId = '';

  void initSharedPrefs() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance().whenComplete(
      () => setState(
        () {
          customerId = ConstantsVar.prefs.getString('guestCustomerID')!;
          apiToken = ConstantsVar.prefs.getString('apiTokken')!;
        },
      ),
    );
    wishlistProvider = Provider.of<cartCounter>(context, listen: false);
    wishlistProvider.getWishlist(
      apiToken: apiToken,
      customerId: customerId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      child: Scaffold(
        appBar: new AppBar(
          // backgroundColor: ConstantsVar.appColor,
          actions: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: InkWell(
                radius: 48,
                child: Consumer<cartCounter>(
                  builder: (context, value, child) {
                    return Badge(
                      position: BadgePosition.topEnd(),
                      badgeColor: Colors.white,
                      badgeContent: new AutoSizeText(
                        value.badgeNumber.toString(),
                      ),
                      child: Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
                onTap: () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => CartScreen2(
                      isOtherScren: true,
                      otherScreenName: 'Product Screen',
                    ),
                  ),
                ),
              ),
            )
          ],
          toolbarHeight: 18.w,
          backgroundColor: ConstantsVar.appColor,
          centerTitle: true,
          title: InkWell(
            onTap: () => Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(
                    builder: (context) => MyHomePage(
                          pageIndex: 0,
                        )),
                (route) => false),
            child: Image.asset(
              'MyAssets/logo.png',
              width: 15.w,
              height: 15.w,
            ),
          ),
        ),
        body: Column(
          children: [
            Card(
              child: ListTile(
                title: Center(
                  child: AutoSizeText(
                    'Wishlist'.toUpperCase(),
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
            ),
            Consumer<cartCounter>(builder: (context, value, _) {
              if (value.isVisible == true) {
                return Container(
                  width: 100.w,
                  height: 70.h,
                  child: Center(
                    child: SpinKitRipple(
                      color: Colors.red,
                      size: 60,
                    ),
                  ),
                );
              } else {
                if (value.wishlistItems.length == 0) {
                  return Container(
                    width: 100.w,
                    height: 70.h,
                    child: Center(
                      child: AnimatedTextKit(
                        repeatForever: true,
                        animatedTexts: [
                          ColorizeAnimatedText(
                            'No Data Available',
                            textStyle: colorizeTextStyle,
                            colors: colorizeColors,
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Expanded(
                    child: ListView(
                      // physics: NeverScrollableScrollPhysics(),

                      shrinkWrap: true,
                      children: List.generate(
                        value.wishlistItems.length,
                        (index) => Card(
                          child: Container(
                            width: 100.w,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => NewProductDetails(
                                      productId: value
                                          .wishlistItems[index].productId
                                          .toString(),
                                      screenName: 'Wishlist Screen',
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                height: 24.h,
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 10, right: 10, top: 20),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(16))),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                              margin: EdgeInsets.only(
                                                  right: 8,
                                                  left: 8,
                                                  top: 8,
                                                  bottom: 8),
                                              width: 80,
                                              height: 80,
                                              child: CachedNetworkImage(
                                                imageUrl: value
                                                    .wishlistItems[index]
                                                    .picture
                                                    .imageUrl,
                                                fit: BoxFit.cover,
                                              )),
                                          Expanded(
                                            child: Container(
                                              height: 23.h,
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: <Widget>[
                                                  Container(
                                                    // padding: EdgeInsets.only(right: 8, top: 4),
                                                    child: AutoSizeText(
                                                      value.wishlistItems[index]
                                                          .productName,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      softWrap: true,
                                                      style: CustomTextStyle
                                                          .textFormFieldSemiBold
                                                          .copyWith(
                                                              fontSize: 16),
                                                    ),
                                                  ),
                                                  // Utils.getSizedBox(null, 6),
                                                  AutoSizeText(
                                                    "SKU : ${value.wishlistItems[index].sku}",
                                                    style: CustomTextStyle
                                                        .textFormFieldRegular
                                                        .copyWith(
                                                            color: Colors.grey,
                                                            fontSize: 15),
                                                  ),
                                                  // Utils.getSizedBox(null, 6),
                                                  AutoSizeText(
                                                    value.wishlistItems[index]
                                                        .unitPrice,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            flex: 100,
                                          )
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top: 1,
                                      right: 1,
                                      child: Card(
                                        elevation: 10,
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: LikeButton(
                                            onTap: (isLiked) async {
                                              await ApiCalls.removeFromWishlist(
                                                      apiToken: apiToken,
                                                      customerId: customerId,
                                                      productId: value
                                                          .wishlistItems[index]
                                                          .productId
                                                          .toString(),
                                                      productName: value
                                                          .wishlistItems[index]
                                                          .productName,
                                                      imageUrl: value
                                                          .wishlistItems[index]
                                                          .picture
                                                          .imageUrl)
                                                  .then((value) =>
                                                      isLiked = value)
                                                  .then((value) =>
                                                      wishlistProvider
                                                          .getWishlist(
                                                        apiToken: apiToken,
                                                        customerId: customerId,
                                                      ));
                                              return isLiked;
                                            },
                                            size:
                                                IconTheme.of(context).size! - 4,
                                            circleColor: CircleColor(
                                              start: ConstantsVar.appColor,
                                              end: ConstantsVar.appColor,
                                            ),

                                            bubblesColor: BubblesColor(
                                              dotPrimaryColor:
                                                  ConstantsVar.appColor,
                                              dotSecondaryColor:
                                                  ConstantsVar.appColor,
                                            ),
                                            // isLiked: isWishlisted,
                                            likeBuilder: (bool isLiked) {
                                              return Icon(
                                                HeartIcon.cross,
                                                color: ConstantsVar.appColor,
                                                size: IconTheme.of(context)
                                                        .size! -
                                                    2,
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }
              }
            })
          ],
        ),
      ),
    );
  }

  final colorizeTextStyle =
      TextStyle(fontSize: 6.w, fontWeight: FontWeight.bold);

  final colorizeColors = [
    Colors.lightBlueAccent,
    Colors.grey,
    Colors.black,
    ConstantsVar.appColor,
  ];
}
