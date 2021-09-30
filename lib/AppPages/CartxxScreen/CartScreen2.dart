import 'dart:async';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/LoginScreen/LoginScreen.dart';
import 'package:untitled2/AppPages/Registration/RegistrationPage.dart';
import 'package:untitled2/AppPages/ShippingxxxScreen/BillingxxScreen/BillingScreen.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/PojoClass/NetworkModelClass/CartModelClass/CartModel.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';
import 'package:untitled2/utils/HeartIcon.dart';
import 'package:untitled2/utils/utils/colors.dart';
import 'package:untitled2/utils/utils/general_functions.dart';

import 'CartItems.dart';
// import 'NOxxLoginxxScreen/NoxxLoginxxScreen.dart';

class CartScreen2 extends StatefulWidget {
  @override
  _CartScreen2State createState() => _CartScreen2State();
}

class _CartScreen2State extends State<CartScreen2>
    with AutomaticKeepAliveClientMixin, InputValidationMixin {
  bool isCartAvail = true;
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

    getCustomerId().then((value) => setState(() => customerId = value));
    setState(() {
      guestCustomerID = ConstantsVar.prefs.getString('guestCustomerID');
      ConstantsVar.prefs.getString('discount') == null
          ? discountCoupon = ''
          : discountCoupon = ConstantsVar.prefs.getString('discount')!;
      if (discountCoupon == null || discountCoupon == '') {
        discountController.text = '';
      } else {
        discountController.text = discountCoupon;
      }
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
      removeCouponCode = true;
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
          child: Scaffold(
            appBar: new AppBar(
              backgroundColor: ConstantsVar.appColor,
              toolbarHeight: 18.w,
              centerTitle: true,
              title: InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      CupertinoPageRoute(builder: (context) => MyHomePage()),
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
                        child: SingleChildScrollView(
                      physics: ScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(20.0),
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: Text(
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
                                  child: Text(
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
                                      Text(
                                        'Sub-Total:',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 15,
                                        ),
                                      ),
                                      Text(
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
                                      Text(
                                        'Shipping:',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 15,
                                        ),
                                      ),
                                      Text(
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
                                        Text(
                                          'Discount:',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
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
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Tax 5%:',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        taxPrice,
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
                                Text(
                                  'Total Amount ',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
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
                                    child: Text(
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
                                          Flexible(
                                            flex: 4,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.black),
                                                  borderRadius:
                                                      BorderRadius.circular(6)),
                                              child: new TextField(
                                                  autofocus: false,
                                                  controller:
                                                      discountController,
                                                  decoration: InputDecoration(
                                                      suffixIcon: InkWell(
                                                        onTap: () {
                                                          if (discountController
                                                                      .text
                                                                      .trim() !=
                                                                  '' &&
                                                              discountController
                                                                      .text
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
                                                                    ? setState(
                                                                        () {
                                                                        discountController.text =
                                                                            '';
                                                                      })
                                                                    : null);
                                                          } else {
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    'No Discount Coupon Applied');
                                                          }
                                                        },
                                                        child: Icon(
                                                            HeartIcon.cross),
                                                      ),
                                                      focusedBorder:
                                                          InputBorder.none,
                                                      // enabledBorder:
                                                      //     OutlineInputBorder(
                                                      //         borderSide: BorderSide(
                                                      //             color: Colors
                                                      //                 .black)),
                                                      border: OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .black)),
                                                      contentPadding:
                                                          EdgeInsets.all(
                                                              12.0))),
                                            ),
                                          ),
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              textStyle: TextStyle(
                                                  // fontSize: 26.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
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
                                                    msg: 'Enter coupon code');
                                              } else {
                                                ApiCalls.applyCoupon(
                                                        ConstantsVar.apiTokken
                                                            .toString(),
                                                        ConstantsVar.customerID,
                                                        discountController.text
                                                            .toString(),
                                                        _refreshController)
                                                    .then((value) {
                                                  setState(() {
                                                    if (value == 'true') {
                                                      removeCouponCode = true;
                                                    }
                                                  });
                                                });
                                              }
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          6.0)),
                                              child: Center(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 4.w,
                                                      horizontal: 1.w),
                                                  child: Text(
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
                                  Visibility(
                                    visible: false,
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text('Entered coupon code - ' +
                                              discountController.text
                                                  .toString()),
                                          addHorizontalSpace(20),
                                          Align(
                                            alignment: Alignment.center,
                                            child: InkWell(
                                              onTap: () {
                                                ApiCalls.removeCoupon(
                                                        context,
                                                        ConstantsVar.apiTokken
                                                            .toString(),
                                                        ConstantsVar.customerID,
                                                        discountController.text
                                                            .toString(),
                                                        _refreshController)
                                                    .then((value) {
                                                  if (value == 'true') {
                                                    removeCouponCode = false;
                                                  }
                                                });
                                              },
                                              child: Container(
                                                width: 24,
                                                height: 24,
                                                alignment: Alignment.center,
                                                margin: EdgeInsets.only(
                                                    right: 10, top: 8),
                                                child: Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20)),
                                                    color:
                                                        ConstantsVar.appColor),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),

                                  /****** Remove coupon design *************/
                                  // Visibility(
                                  //   visible: removeCouponCode,
                                  //   child: Container(
                                  //     child: Row(
                                  //       mainAxisAlignment:
                                  //           MainAxisAlignment.spaceBetween,
                                  //       children: <Widget>[
                                  //         Flexible(
                                  //           child: Container(
                                  //               padding: EdgeInsets.all(4.0),
                                  //               width: MediaQuery.of(context)
                                  //                   .size
                                  //                   .width,
                                  //               height: 6.h,
                                  //               decoration: BoxDecoration(

                                  //                       BorderRadius.circular(6.0)),
                                  //               child: Center(
                                  //                 child: Text(
                                  //                   discountController.text
                                  //                           .toString() +
                                  //                       ' ' +
                                  //                       'coupon applied',
                                  //                   maxLines: 1,
                                  //                 ),
                                  //               )),
                                  //         ),
                                  //         TextButton(
                                  //           style: TextButton.styleFrom(
                                  //             textStyle: TextStyle(
                                  //                 fontSize: 26.sp,
                                  //                 fontWeight: FontWeight.bold,
                                  //                 color: Colors.black),
                                  //           ),
                                  //           onPressed: () async {
                                  //             print('remove button clicked');
                                  //                 .then((value) {
                                  //               if (value == 'true') {
                                  //                 applyCouponCode = true;
                                  //                 removeCouponCode = false;
                                  //               }
                                  //             });
                                  //           },
                                  //           child: Container(
                                  //             height: 6.h,
                                  //             padding: EdgeInsets.only(
                                  //                 left: 12.0, right: 12.0),
                                  //             decoration: BoxDecoration(
                                  //                 color: Colors.black,
                                  //                 borderRadius:
                                  //                     BorderRadius.circular(6.0)),
                                  //             child: Center(
                                  //               child: Text(
                                  //                 'Remove Coupon',
                                  //                 style: TextStyle(
                                  //                     color: Colors.white),
                                  //               ),
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),

                                  /****************Gift cards design ************/
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Text(
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
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Flexible(
                                            flex: 4,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.black),
                                                  borderRadius:
                                                      BorderRadius.circular(6)),
                                              // height: 5.h,
                                              child: new TextField(
                                                  autofocus: false,
                                                  controller:
                                                      giftCardController,
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
                                                                        giftCardController.text =
                                                                            ''));
                                                          } else {
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    'No Gift Coupon Applied');
                                                          }
                                                        },
                                                        child: Icon(
                                                            HeartIcon.cross),
                                                      ),
                                                      focusedBorder:
                                                          InputBorder.none,
                                                      contentPadding:
                                                          EdgeInsets.all(
                                                              12.0))),
                                            ),
                                          ),
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              textStyle: TextStyle(
                                                  fontSize: 4.w,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                            onPressed: () async {
                                              if (giftCardController.text
                                                      .toString()
                                                      .length ==
                                                  0) {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        'Please enter gift card number');
                                              } else {
                                                ApiCalls.applyGiftCard(
                                                        ConstantsVar.apiTokken
                                                            .toString(),
                                                        ConstantsVar.customerID,
                                                        giftCardController.text
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
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          6.0)),
                                              child: Center(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 4.w,
                                                      horizontal: 1.w),
                                                  child: Text(
                                                    'Add Gift Card',
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

                                  /**************** remove Gift card ***************/
                                  Visibility(
                                    visible: removeGiftCard,
                                    child: Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Flexible(
                                            child: Container(
                                                padding: EdgeInsets.all(4.0),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 6.h,
                                                decoration: BoxDecoration(
                                                    color:
                                                        AppColor.PrimaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6.0)),
                                                child: Center(
                                                  child: Text(
                                                    discountController.text
                                                            .toString() +
                                                        ' ' +
                                                        'gift applied',
                                                    maxLines: 1,
                                                  ),
                                                )),
                                          ),
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              textStyle: TextStyle(
                                                  fontSize: 26.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                            onPressed: () async {
                                              print(
                                                  'remove gift button clicked');
                                              ApiCalls.removeGiftCoupon(
                                                      ConstantsVar.apiTokken
                                                          .toString(),
                                                      ConstantsVar.customerID,
                                                      discountController.text
                                                          .toString(),
                                                      _refreshController)
                                                  .then((value) {
                                                if (value == 'true') {
                                                  applyGiftCard = true;
                                                  removeGiftCard = false;
                                                }
                                                child:
                                                Stack(
                                                  children: [
                                                    Container(
                                                        child:
                                                            SingleChildScrollView(
                                                      physics: ScrollPhysics(),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    20.0),
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            child: Center(
                                                              child: Text(
                                                                'My Cart'
                                                                    .toUpperCase(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        6.w,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w900),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 4,
                                                          ),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            width:
                                                                double.infinity,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Color(
                                                                  0xFFEEEEEE),
                                                            ),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          4.0),
                                                                  child: Text(
                                                                    'price details'
                                                                        .toUpperCase(),
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'Poppins',
                                                                      fontSize:
                                                                          18,
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          4.0),
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                        'Sub-Total:',
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              'Poppins',
                                                                          fontSize:
                                                                              15,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        subTotal,
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'Poppins',
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          4.0),
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                        'Shipping:',
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              'Poppins',
                                                                          fontSize:
                                                                              15,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        shipping ==
                                                                                null
                                                                            ? 'No Shipping Available for now '
                                                                            : shipping,
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'Poppins',
                                                                            fontSize:
                                                                                15,
                                                                            color:
                                                                                Colors.green,
                                                                            fontWeight: FontWeight.bold),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          4.0),
                                                                  child:
                                                                      Visibility(
                                                                    visible:
                                                                        showDiscount,
                                                                    child: Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          'Discount:',
                                                                          style:
                                                                              TextStyle(
                                                                            fontFamily:
                                                                                'Poppins',
                                                                            fontSize:
                                                                                14,
                                                                          ),
                                                                        ),
                                                                        Text(
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
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 4.0,
                                                                      right:
                                                                          4.0),
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                        'Tax 5%:',
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              'Poppins',
                                                                          fontSize:
                                                                              14,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        taxPrice,
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'Poppins',
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      )
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            child: Divider(
                                                              thickness: 2,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    8.0,
                                                                    15,
                                                                    8,
                                                                    15),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  'Total Amount ',
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Poppins',
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                Text(
                                                                  totalAmount,
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Poppins',
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            child: Divider(
                                                              thickness: 2,
                                                            ),
                                                          ),
                                                          ListView.builder(
                                                              shrinkWrap: true,
                                                              physics:
                                                                  NeverScrollableScrollPhysics(),
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8.0),
                                                              itemCount:
                                                                  cartItems
                                                                      .length,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                return CartItem(
                                                                  itemID: cartItems[
                                                                          index]
                                                                      .itemId,
                                                                  quantity: cartItems[
                                                                          index]
                                                                      .quantity,
                                                                  title: cartItems[
                                                                          index]
                                                                      .productName,
                                                                  sku:
                                                                      '${cartItems[index].sku}',
                                                                  price: cartItems[
                                                                          index]
                                                                      .subTotal,
                                                                  imageUrl: cartItems[
                                                                          index]
                                                                      .picture
                                                                      .imageUrl,
                                                                  updateUi: () {
                                                                    showAndUpdateUi();
                                                                    _refreshController
                                                                        .requestRefresh();
                                                                  },
                                                                  reload: () {
                                                                    showAndUpdateUi();
                                                                    _refreshController
                                                                        .requestRefresh();
                                                                  },
                                                                  id: guestCustomerID,
                                                                  productId: cartItems[
                                                                          index]
                                                                      .productId,
                                                                  quantity2: cartItems[
                                                                          index]
                                                                      .quantity,
                                                                  unitPrice: cartItems[
                                                                          index]
                                                                      .unitPrice,
                                                                );
                                                              }),
                                                          Container(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            child: Divider(
                                                              thickness: 2,
                                                            ),
                                                          ),

                                                          /******* Discount layout started **********/
                                                          Container(
                                                              margin: EdgeInsets
                                                                  .all(12.0),
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              child: Column(
                                                                children: <
                                                                    Widget>[
                                                                  Container(
                                                                    width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                    child: Text(
                                                                      'Discount Code',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              5.4.w),
                                                                    ),
                                                                  ),

                                                                  /******* Apply coupon Code design *************/
                                                                  Visibility(
                                                                    visible:
                                                                        applyCouponCode,
                                                                    child:
                                                                        Container(
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: <
                                                                            Widget>[
                                                                          Flexible(
                                                                            flex:
                                                                                4,
                                                                            child:
                                                                                Container(
                                                                              decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(6)),
                                                                              child: new TextField(
                                                                                  autofocus: false,
                                                                                  controller: discountController,
                                                                                  decoration: InputDecoration(
                                                                                      suffixIcon: InkWell(
                                                                                        onTap: () {
                                                                                          if (discountController.text.trim() != '' && discountController.text.toString().trim().length >= 4) {
                                                                                            ApiCalls.removeCoupon(context, ConstantsVar.apiTokken!, guestCustomerID, discountCoupon, _refreshController).then((value) => value.toString().contains('true')
                                                                                                ? setState(() {
                                                                                                    discountController.text = '';
                                                                                                  })
                                                                                                : null);
                                                                                          } else {
                                                                                            Fluttertoast.showToast(msg: 'No Discount Coupon Applied');
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
                                                                                      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                                                                                      contentPadding: EdgeInsets.all(12.0))),
                                                                            ),
                                                                          ),
                                                                          TextButton(
                                                                            style:
                                                                                TextButton.styleFrom(
                                                                              textStyle: TextStyle(
                                                                                  // fontSize: 26.sp,
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color: Colors.black),
                                                                            ),
                                                                            onPressed:
                                                                                () async {
                                                                              if (discountController.text.toString().trim().length == 0 || discountController.text.toString().trim().length <= 4) {
                                                                                Fluttertoast.showToast(msg: 'Enter coupon code');
                                                                              } else {
                                                                                ApiCalls.applyCoupon(ConstantsVar.apiTokken.toString(), ConstantsVar.customerID, discountController.text.toString(), _refreshController).then((value) {
                                                                                  setState(() {
                                                                                    if (value == 'true') {
                                                                                      removeCouponCode = true;
                                                                                    }
                                                                                  });
                                                                                });
                                                                              }
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(6.0)),
                                                                              child: Center(
                                                                                child: Padding(
                                                                                  padding: EdgeInsets.symmetric(vertical: 4.w, horizontal: 1.w),
                                                                                  child: Text(
                                                                                    'Apply Coupon',
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                    maxLines: 1,
                                                                                    style: TextStyle(fontSize: 4.w, color: Colors.white),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Visibility(
                                                                    visible:
                                                                        false,
                                                                    child:
                                                                        Container(
                                                                      margin: EdgeInsets.only(
                                                                          bottom:
                                                                              10),
                                                                      child:
                                                                          Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: <
                                                                            Widget>[
                                                                          Text('Entered coupon code - ' +
                                                                              discountController.text.toString()),
                                                                          addHorizontalSpace(
                                                                              20),
                                                                          Align(
                                                                            alignment:
                                                                                Alignment.center,
                                                                            child:
                                                                                InkWell(
                                                                              onTap: () {
                                                                                ApiCalls.removeCoupon(context, ConstantsVar.apiTokken.toString(), ConstantsVar.customerID, discountController.text.toString(), _refreshController).then((value) {
                                                                                  if (value == 'true') {
                                                                                    removeCouponCode = false;
                                                                                  }
                                                                                });
                                                                              },
                                                                              child: Container(
                                                                                width: 24,
                                                                                height: 24,
                                                                                alignment: Alignment.center,
                                                                                margin: EdgeInsets.only(right: 10, top: 8),
                                                                                child: Icon(
                                                                                  Icons.close,
                                                                                  color: Colors.white,
                                                                                  size: 20,
                                                                                ),
                                                                                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: ConstantsVar.appColor),
                                                                              ),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),

                                                                  /****** Remove coupon design *************/
                                                                  // Visibility(
                                                                  //   visible: removeCouponCode,
                                                                  //   child: Container(
                                                                  //     child: Row(
                                                                  //       mainAxisAlignment:
                                                                  //           MainAxisAlignment.spaceBetween,
                                                                  //       children: <Widget>[
                                                                  //         Flexible(
                                                                  //           child: Container(
                                                                  //               padding: EdgeInsets.all(4.0),
                                                                  //               width: MediaQuery.of(context)
                                                                  //                   .size
                                                                  //                   .width,
                                                                  //               height: 6.h,
                                                                  //               decoration: BoxDecoration(

                                                                  //                       BorderRadius.circular(6.0)),
                                                                  //               child: Center(
                                                                  //                 child: Text(
                                                                  //                   discountController.text
                                                                  //                           .toString() +
                                                                  //                       ' ' +
                                                                  //                       'coupon applied',
                                                                  //                   maxLines: 1,
                                                                  //                 ),
                                                                  //               )),
                                                                  //         ),
                                                                  //         TextButton(
                                                                  //           style: TextButton.styleFrom(
                                                                  //             textStyle: TextStyle(
                                                                  //                 fontSize: 26.sp,
                                                                  //                 fontWeight: FontWeight.bold,
                                                                  //                 color: Colors.black),
                                                                  //           ),
                                                                  //           onPressed: () async {
                                                                  //             print('remove button clicked');
                                                                  //                 .then((value) {
                                                                  //               if (value == 'true') {
                                                                  //                 applyCouponCode = true;
                                                                  //                 removeCouponCode = false;
                                                                  //               }
                                                                  //             });
                                                                  //           },
                                                                  //           child: Container(
                                                                  //             height: 6.h,
                                                                  //             padding: EdgeInsets.only(
                                                                  //                 left: 12.0, right: 12.0),
                                                                  //             decoration: BoxDecoration(
                                                                  //                 color: Colors.black,
                                                                  //                 borderRadius:
                                                                  //                     BorderRadius.circular(6.0)),
                                                                  //             child: Center(
                                                                  //               child: Text(
                                                                  //                 'Remove Coupon',
                                                                  //                 style: TextStyle(
                                                                  //                     color: Colors.white),
                                                                  //               ),
                                                                  //             ),
                                                                  //           ),
                                                                  //         ),
                                                                  //       ],
                                                                  //     ),
                                                                  //   ),
                                                                  // ),

                                                                  /****************Gift cards design ************/
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        vertical:
                                                                            8.0),
                                                                    child:
                                                                        Container(
                                                                      width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width,
                                                                      child:
                                                                          Text(
                                                                        'Gift Cards',
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.black,
                                                                            fontSize: 5.4.w),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Visibility(
                                                                    visible:
                                                                        applyGiftCard,
                                                                    child:
                                                                        Container(
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: <
                                                                            Widget>[
                                                                          Flexible(
                                                                            flex:
                                                                                4,
                                                                            child:
                                                                                Container(
                                                                              decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(6)),
                                                                              // height: 5.h,
                                                                              child: new TextField(
                                                                                  autofocus: false,
                                                                                  controller: giftCardController,
                                                                                  decoration: InputDecoration(
                                                                                      suffixIcon: InkWell(
                                                                                        onTap: () {
                                                                                          if (giftCardController.text.trim() != '' && giftCardController.text.trim().length >= 4) {
                                                                                            ApiCalls.removeGiftCoupon(ConstantsVar.apiTokken!, guestCustomerID, giftCardController.text.trim(), _refreshController).then((value) => setState(() => giftCardController.text = ''));
                                                                                          } else {
                                                                                            Fluttertoast.showToast(msg: 'No Gift Coupon Applied');
                                                                                          }
                                                                                        },
                                                                                        child: Icon(HeartIcon.cross),
                                                                                      ),
                                                                                      focusedBorder: InputBorder.none,
                                                                                      contentPadding: EdgeInsets.all(12.0))),
                                                                            ),
                                                                          ),
                                                                          TextButton(
                                                                            style:
                                                                                TextButton.styleFrom(
                                                                              textStyle: TextStyle(fontSize: 4.w, fontWeight: FontWeight.bold, color: Colors.black),
                                                                            ),
                                                                            onPressed:
                                                                                () async {
                                                                              if (giftCardController.text.toString().length == 0) {
                                                                                Fluttertoast.showToast(msg: 'Please enter gift card number');
                                                                              } else {
                                                                                ApiCalls.applyGiftCard(ConstantsVar.apiTokken.toString(), ConstantsVar.customerID, giftCardController.text.toString()).then((value) {
                                                                                  print('val $value');
                                                                                  if (value == 'false') {
                                                                                    setState(() {
                                                                                      giftCardController.clear();
                                                                                    });
                                                                                  } else {}
                                                                                });
                                                                              }
                                                                              print('clicked');
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(6.0)),
                                                                              child: Center(
                                                                                child: Padding(
                                                                                  padding: EdgeInsets.symmetric(vertical: 4.w, horizontal: 1.w),
                                                                                  child: Text(
                                                                                    'Add Gift Card',
                                                                                    style: TextStyle(fontSize: 4.w, color: Colors.white),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),

                                                                  /**************** remove Gift card ***************/
                                                                  Visibility(
                                                                    visible:
                                                                        removeGiftCard,
                                                                    child:
                                                                        Container(
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: <
                                                                            Widget>[
                                                                          Flexible(
                                                                            child: Container(
                                                                                padding: EdgeInsets.all(4.0),
                                                                                width: MediaQuery.of(context).size.width,
                                                                                height: 6.h,
                                                                                decoration: BoxDecoration(color: AppColor.PrimaryColor, borderRadius: BorderRadius.circular(6.0)),
                                                                                child: Center(
                                                                                  child: Text(
                                                                                    discountController.text.toString() + ' ' + 'gift applied',
                                                                                    maxLines: 1,
                                                                                  ),
                                                                                )),
                                                                          ),
                                                                          TextButton(
                                                                            style:
                                                                                TextButton.styleFrom(
                                                                              textStyle: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.bold, color: Colors.black),
                                                                            ),
                                                                            onPressed:
                                                                                () async {
                                                                              print('remove gift button clicked');
                                                                              ApiCalls.removeGiftCoupon(ConstantsVar.apiTokken.toString(), ConstantsVar.customerID, discountController.text.toString(), _refreshController).then((value) {
                                                                                if (value == 'true') {
                                                                                  applyGiftCard = true;
                                                                                  removeGiftCard = false;
                                                                                }
                                                                              });
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              height: 3.h,
                                                                              padding: EdgeInsets.only(left: 12.0, right: 12.0),
                                                                              decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(6.0)),
                                                                              child: Center(
                                                                                child: Text(
                                                                                  'Remove Gift',
                                                                                  style: TextStyle(fontSize: 4.w, color: Colors.white),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              )),
                                                          Container(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            child: Divider(
                                                              thickness: 2,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 10.w,
                                                          ),
                                                        ],
                                                      ),
                                                    )),
                                                    Visibility(
                                                      visible: showLoading,
                                                      child: Positioned.fill(
                                                        child: Align(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child:
                                                                showloader()),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      child: bottomButtons(
                                                          context),
                                                    ),
                                                  ],
                                                );
                                              });
                                            },
                                            child: Container(
                                              height: 3.h,
                                              padding: EdgeInsets.only(
                                                  left: 12.0, right: 12.0),
                                              decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          6.0)),
                                              child: Center(
                                                child: Text(
                                                  'Remove Gift',
                                                  style: TextStyle(
                                                      fontSize: 4.w,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
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
                    )),
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
                      CupertinoPageRoute(builder: (context) => MyHomePage()),
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
                child: Text(
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
              child: Center(child: Text('No Internet Connetion Found'))));
    }
  }

  Future getCustomerId() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
    customerId = ConstantsVar.prefs.getString('userId');
    return customerId;
  }

  Widget bottomButtons(BuildContext context) {
    return InkWell(
      onTap: () {
        print(customerId);

        if (guestCustomerID != '${customerId}') {
          print('Merging process ');
          Navigator.push(
              context, CupertinoPageRoute(builder: (context) => LoginScreen()));
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
          child: Text(
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
  }
}
