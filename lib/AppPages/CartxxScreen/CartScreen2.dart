import 'dart:io' show Platform;
import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_loading_button/progress_loading_button.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/LoginScreen/LoginScreen.dart';
import 'package:untitled2/AppPages/Registration/RegistrationPage.dart';
import 'package:untitled2/AppPages/ShippingxxxScreen/BillingxxScreen/BillingScreen.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/PojoClass/NetworkModelClass/CartModelClass/CartModel.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';
import 'package:untitled2/utils/CartBadgeCounter/CartBadgetLogic.dart';
import 'package:untitled2/utils/HeartIcon.dart';
import 'package:untitled2/utils/utils/colors.dart';
import 'package:untitled2/utils/utils/general_functions.dart';

import 'CartItems.dart';
import 'package:provider/provider.dart';

class CartScreen2 extends StatefulWidget {
  final bool isOtherScren;
  final String otherScreenName;

  @override
  _CartScreen2State createState() => _CartScreen2State();

  CartScreen2({required this.isOtherScren, required this.otherScreenName});
}

class _CartScreen2State extends State<CartScreen2>
    with AutomaticKeepAliveClientMixin, InputValidationMixin {
  bool isCartAvail = true;
  var gUId;
  var customerId;
  var guestCustomerID;
  var quantity;
  bool visibility = false;
  bool indVisibility = true;
  var subTotal = '';
  var shipping = '';
  var taxPrice = '';
  var totalAmount = '';
  var discountPrice = '';
  String discountCoupon = '';
  String giftCoupon = '';
  bool showDiscount = false;
  bool showLoading = false, applyCouponCode = true, removeCouponCode = false;
  bool applyGiftCard = true, removeGiftCard = false;

  bool connectionStatus = true;
  List<Item> cartItems = [];
  bool loadCartFirst = true;
  TextEditingController discountController = new TextEditingController();
  TextEditingController giftCardController = new TextEditingController();

  final doubleRegex = RegExp(r'^\[A-Z+\0-9+\a-z+\A-Z]$', multiLine: true);
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final GlobalKey<FormState> discountKey = GlobalKey<FormState>();
  final GlobalKey<FormState> giftCouponKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    getCustomerIdxx();
    ApiCalls.readCounter(customerGuid: gUId)
        .then((value) => context.read<cartCounter>().changeCounter(value));

    getCustomerId().then((value) => setState(() => customerId = value));
    setState(() {
      guestCustomerID = ConstantsVar.prefs.getString('guestCustomerID');

      print('$guestCustomerID');

      if (loadCartFirst == false) {
        setState(() {
          loadCartFirst = true;
        });
      } else {
        showAndUpdateUi();
        setState(() => loadCartFirst = false);
      }
    });

    print('customerid>>>>> $customerId');
    visibility = false;
    indVisibility = true;
    if (discountController.text.toString() == null ||
        discountController.text.toString == '') {
      setState(() {
        removeCouponCode = false;
      });
    } else {
      setState(() => removeCouponCode = true);
    }

    ConstantsVar.subscription = ConstantsVar.connectivity.onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        setState(() {
          connectionStatus = true;
        });
      } else {
        ConstantsVar.showSnackbar(context,
            'No Internet connection found. Please check your connection', 5);
        setState(() {
          connectionStatus = false;
        });
      }
    });
  }

  void showAndUpdateUi() async {
    gUId = ConstantsVar.prefs.getString('guestGUID');

    guestCustomerID = ConstantsVar.prefs.getString('guestCustomerID');
    getCustomerId();
    ApiCalls.readCounter(customerGuid: gUId)
        .then((value) => context.read<cartCounter>().changeCounter(value));
    setState(() {
      isCartAvail = true;
    });
    print('Checkig gID in Cart Screen');

    ApiCalls.showCart(guestCustomerID).then((value) {
      setState(() {
        isCartAvail = false;
        CartModel model = CartModel.fromJson(value);
        cartItems = model.listCart.items;
        visibility = true;
        indVisibility = false;
        subTotal = model.orderTotalsModel.subTotal;
        shipping = model.orderTotalsModel.shipping;
        taxPrice = model.orderTotalsModel.tax;
        totalAmount = model.orderTotalsModel.orderTotal;
        discountPrice = model.orderTotalsModel.orderTotalDiscount;
        if (model.listCart.discountBox.appliedDiscountsWithCodes.length == 0) {
          discountCoupon = '';
        } else {
          discountCoupon = model.listCart.discountBox
                      .appliedDiscountsWithCodes[0]['CouponCode'] ==
                  null
              ? ''
              : model.listCart.discountBox.appliedDiscountsWithCodes[0]
                  ['CouponCode'];
          discountController.text = discountCoupon;
        }

        if (model.orderTotalsModel.giftCards.length != 0) {
          giftCoupon = model.orderTotalsModel.giftCards[0]['CouponCode'] == null
              ? ''
              : model.orderTotalsModel.giftCards[0]['CouponCode'];
          giftCardController.text = giftCoupon;
          if (giftCardController.text.trim() == null) {
            removeGiftCard = false;
          } else {
            removeGiftCard = true;
          }
        } else {
          giftCoupon = '';
          removeGiftCard = false;
        }
        print('Refresh Trigger');
        setState(() {
          _refreshController.refreshCompleted();
        });
        if (discountPrice == null || discountPrice == '') {
          setState(() {
            discountPrice = 'No Discount Available';
            showDiscount = false;
            removeCouponCode = false;
          });
        } else {
          setState(() {
            showDiscount = true;
            removeCouponCode = true;
          });
        }

        /* if no shipping on the product but have discount and total amount both*/
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (connectionStatus = true) {
      if (cartItems.isNotEmpty) {
        return SafeArea(
          top: true,
          bottom: true,
          maintainBottomViewPadding: true,
          child: Scaffold(
            appBar: new AppBar(
              leading: widget.isOtherScren == true ? setBackIcon() : null,
              backgroundColor: ConstantsVar.appColor,
              toolbarHeight: 18.w,
              centerTitle: true,
              title: InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => MyHomePage(
                                pageIndex: 0,
                              )),
                    );
                  },
                  child: Image.asset('MyAssets/logo.png',
                      width: 15.w, height: 15.w)),
            ),
            body: Visibility(
              visible: visibility,
              child: SmartRefresher(
                controller: _refreshController,
                enablePullDown: true,
                enablePullUp: false,
                onRefresh: showAndUpdateUi,
                header: WaterDropHeader(),
                child: Stack(
                  children: [
                    Container(
                      child: ListView(
                        children: [
                          Container(
                            padding: EdgeInsets.all(20.0),
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: AutoSizeText(
                                'My Cart'.toUpperCase(),
                                style: TextStyle(
                                    fontSize: 6.w, fontWeight: FontWeight.w900),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Color(0xFFEEEEEE),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: AutoSizeText(
                                    'price details'.toUpperCase(),
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      AutoSizeText(
                                        'Sub-Total:',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 15,
                                        ),
                                      ),
                                      AutoSizeText(
                                        subTotal,
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      AutoSizeText(
                                        'Shipping:',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 15,
                                        ),
                                      ),
                                      AutoSizeText(
                                        shipping == null
                                            ? 'No Shipping Available for now '
                                            : shipping,
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 15,
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Visibility(
                                    visible: showDiscount,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        AutoSizeText(
                                          'Discount:',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 14,
                                          ),
                                        ),
                                        AutoSizeText(
                                          discountPrice,
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 4.0, right: 4.0),
                                  child: Row(
                                    // mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      AutoSizeText(
                                        'Tax 5%:',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 14,
                                        ),
                                      ),
                                      AutoSizeText(
                                        taxPrice == null ? '' : taxPrice,
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Divider(
                              thickness: 2,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 15, 8, 15),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AutoSizeText(
                                  'Total Amount ',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                AutoSizeText(
                                  totalAmount,
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Divider(
                              thickness: 2,
                            ),
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.all(8.0),
                              itemCount: cartItems.length,
                              itemBuilder: (context, index) {
                                return CartItem(
                                  itemID: cartItems[index].itemId,
                                  quantity: cartItems[index].quantity,
                                  title: cartItems[index].productName,
                                  sku: '${cartItems[index].sku}',
                                  price: cartItems[index].subTotal,
                                  imageUrl: cartItems[index].picture.imageUrl,
                                  updateUi: () {
                                    showAndUpdateUi();
                                    _refreshController.requestRefresh();
                                  },
                                  reload: () {
                                    showAndUpdateUi();
                                    _refreshController.requestRefresh();
                                  },
                                  id: guestCustomerID,
                                  productId: cartItems[index].productId,
                                  quantity2: cartItems[index].quantity,
                                  unitPrice: cartItems[index].unitPrice,
                                );
                              }),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Divider(
                              thickness: 2,
                            ),
                          ),

                          /******* Discount layout started **********/
                          Container(
                              margin: EdgeInsets.all(12.0),
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: AutoSizeText(
                                      'Discount Code',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 5.4.w),
                                    ),
                                  ),

                                  /******* Apply coupon Code design *************/
                                  Visibility(
                                    visible: applyCouponCode,
                                    child: Container(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            width: 67.w,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black),
                                                borderRadius:
                                                    BorderRadius.circular(6)),
                                            child: new TextFormField(
                                              autofocus: false,
                                              controller: discountController,
                                              decoration: InputDecoration(
                                                suffixIcon: InkWell(
                                                  onTap: () {
                                                    if (discountController.text
                                                                .trim() !=
                                                            '' &&
                                                        discountController.text
                                                                .toString()
                                                                .trim()
                                                                .length >=
                                                            4) {
                                                      ApiCalls.removeCoupon(
                                                              context,
                                                              ConstantsVar
                                                                  .apiTokken!,
                                                              guestCustomerID,
                                                              discountCoupon,
                                                              _refreshController)
                                                          .then((value) => value
                                                                  .toString()
                                                                  .contains(
                                                                      'true')
                                                              ? setState(() {
                                                                  discountController
                                                                      .text = '';
                                                                })
                                                              : null);
                                                    } else {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              'No Discount Coupon Applied');
                                                    }
                                                  },
                                                  child: Icon(HeartIcon.cross),
                                                ),
                                                focusedBorder: InputBorder.none,
                                                // enabledBorder:
                                                //     OutlineInputBorder(
                                                //         borderSide: BorderSide(
                                                //             color: Colors
                                                //                 .black)),
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.black)),
                                                contentPadding:
                                                    EdgeInsets.all(12.0),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            color: Colors.black,
                                            width: 25.w,
                                            height: 51,
                                            child: Center(
                                              child: LoadingButton(
                                                loadingWidget: SpinKitCircle(
                                                  color: Colors.white,
                                                  size: 30,
                                                ),
                                                width: 25.w,
                                                height: 50,
                                                onPressed: () async {
                                                  if (discountController.text
                                                              .toString()
                                                              .trim()
                                                              .length ==
                                                          0 ||
                                                      discountController.text
                                                              .toString()
                                                              .trim()
                                                              .length <=
                                                          4) {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            'Enter coupon code');
                                                  } else {
                                                    await ApiCalls.applyCoupon(
                                                            ConstantsVar
                                                                .apiTokken
                                                                .toString(),
                                                            ConstantsVar
                                                                .customerID,
                                                            discountController
                                                                .text
                                                                .toString(),
                                                            _refreshController)
                                                        .then((value) {
                                                      setState(() {
                                                        if (value == 'true') {
                                                          removeCouponCode =
                                                              true;
                                                        }
                                                      });
                                                    });
                                                  }
                                                },
                                                color: Colors.black,
                                                defaultWidget: Center(
                                                  child: AutoSizeText(
                                                    'Apply Coupon',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        fontSize: 4.w,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  /****************Gift cards design ************/
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: AutoSizeText(
                                        'Gift Cards',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 5.4.w),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: applyGiftCard,
                                    child: Container(
                                      width: 100.w,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            width: 67.w,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black),
                                                borderRadius:
                                                    BorderRadius.circular(6)),
                                            // height: 5.h,
                                            child: new TextFormField(
                                                autofocus: false,
                                                controller: giftCardController,
                                                decoration: InputDecoration(
                                                    suffixIcon: InkWell(
                                                      onTap: () {
                                                        if (giftCardController
                                                                    .text
                                                                    .trim() !=
                                                                '' &&
                                                            giftCardController
                                                                    .text
                                                                    .trim()
                                                                    .length >=
                                                                4) {
                                                          ApiCalls.removeGiftCoupon(
                                                                  ConstantsVar
                                                                      .apiTokken!,
                                                                  guestCustomerID,
                                                                  giftCardController
                                                                      .text
                                                                      .trim(),
                                                                  _refreshController)
                                                              .then((value) =>
                                                                  setState(() =>
                                                                      giftCardController
                                                                              .text =
                                                                          ''));
                                                        } else {
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  'No Gift Coupon Applied');
                                                        }
                                                      },
                                                      child:
                                                          Icon(HeartIcon.cross),
                                                    ),
                                                    focusedBorder:
                                                        InputBorder.none,
                                                    contentPadding:
                                                        EdgeInsets.all(12.0))),
                                          ),
                                          Container(
                                            width: 25.w,
                                            height: 51,
                                            color: Colors.black,
                                            child: LoadingButton(
                                              width: 25.w,
                                              height: 50,
                                              loadingWidget: SpinKitCircle(
                                                color: Colors.white,
                                                size: 30,
                                              ),
                                              color: Colors.black,
                                              onPressed: () async {
                                                if (giftCardController.text
                                                        .toString()
                                                        .length ==
                                                    0) {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          'Please enter gift card number');
                                                } else {
                                                  await ApiCalls.applyGiftCard(
                                                          ConstantsVar.apiTokken
                                                              .toString(),
                                                          ConstantsVar
                                                              .customerID,
                                                          giftCardController
                                                              .text
                                                              .toString())
                                                      .then((value) {
                                                    print('val $value');
                                                    if (value == 'false') {
                                                      setState(() {
                                                        giftCardController
                                                            .clear();
                                                      });
                                                    } else {}
                                                  });
                                                }
                                                print('clicked');
                                              },
                                              defaultWidget: AutoSizeText(
                                                'Add Gift Card',
                                                style: TextStyle(
                                                    fontSize: 4.w,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Divider(
                              thickness: 2,
                            ),
                          ),
                          SizedBox(
                            height: 10.w,
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: showLoading,
                      child: Positioned.fill(
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: showloader()),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: bottomButtons(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      } else if (isCartAvail == true) {
        return Scaffold(
          appBar: new AppBar(
            centerTitle: true,
            backgroundColor: ConstantsVar.appColor,
            toolbarHeight: 18.w,
            title: Image.asset(
              'MyAssets/logo.png',
              width: 15.w,
              height: 15.w,
            ),
          ),
          body: Container(
            child: Center(
                child: Container(
              child: Center(
                child: SpinKitRipple(
                  color: Colors.primaries.first.shade900,
                  size: 90,
                ),
              ),
            )),
          ),
        );
      } else if (cartItems.length == 0) {
        return SafeArea(
          top: true,
          child: Scaffold(
            appBar: new AppBar(
              backgroundColor: ConstantsVar.appColor,
              toolbarHeight: 18.w,
              centerTitle: true,
              title: InkWell(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => MyHomePage(
                                pageIndex: 0,
                              )),
                      (route) => false);
                },
                child: Image.asset(
                  'MyAssets/logo.png',
                  width: 15.w,
                  height: 15.w,
                ),
              ),
            ),
            body: Container(
              child: Center(
                child: AutoSizeText(
                  'NO ITEMS IN CART.\n \n \n WHOEVER SAID THAT MONEY CANNOT BUY HAPPINESS, DID NOT KNOW WHERE TO DO SHOPPING.\n\n\n ENJOY SHOPPING ON THE One!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      letterSpacing: 1,
                      height: 2,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.dp),
                ),
              ),
            ),
          ),
        );
      } else {
        return Scaffold(body: Container());
      }
    } else {
      return Scaffold(
          body: Container(
              child:
                  Center(child: AutoSizeText('No Internet Connetion Found'))));
    }
  }

  Future getCustomerId() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
    customerId = ConstantsVar.prefs.getString('userId');
    return customerId;
  }

  Widget bottomButtons(BuildContext context) {
    return InkWell(
      onTap: () async {
        print(customerId);

        if (guestCustomerID != '${customerId}' || customerId == null) {
          print('Merging process ');
          // setState((){
          //   cartItems.clear();
          //   visibility = false;
          //   indVisibility = true;
          // });
          var result = await Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => LoginScreen(
                        screenKey: widget.isOtherScren == true
                            ? widget.otherScreenName
                            : 'Cart Screen',
                      )));
          if (result == true) {
            setState(() {
              guestCustomerID = ConstantsVar.prefs.getString('guestCustomerID');
              _refreshController.requestRefresh();
              // showAndUpdateUi();
            });
          }
        } else {
          Navigator.push(context, CupertinoPageRoute(builder: (context) {
            return BillingDetails();
          }));
        }
      },
      child: Container(
        height: 11.w,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2.0),
            color: ConstantsVar.appColor),
        child: Center(
          child: AutoSizeText(
            'checkout'.toUpperCase(),
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Future getCustomerIdxx() async {
    customerId = ConstantsVar.customerID;
    gUId = ConstantsVar.prefs.getString('guestGUID');
  }

  Future refresh() async {
    _refreshController.refreshCompleted();
  }

  Widget setBackIcon() {
    if (Platform.isAndroid) {
      return InkWell(
          onTap: () {
            if (widget.otherScreenName.contains('Cart Screen2')) {
              Navigator.pushAndRemoveUntil(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => MyHomePage(pageIndex: 4),
                  ),
                  (route) => false);
            } else {
              Navigator.pop(context, true);
            }
          },
          child: Icon(Icons.arrow_back));
      // Android-specific code
    } else {
      return InkWell(
        onTap: () {
          if (widget.otherScreenName.contains('Cart Screen2')) {
            Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(
                  builder: (context) => MyHomePage(pageIndex: 4),
                ),
                (route) => false);
          } else {
            Navigator.pop(context, true);
          }
        },
        child: Icon(Icons.arrow_back),
      ); // iOS-specific code
    }
  }
}
