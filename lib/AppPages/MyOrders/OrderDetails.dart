import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:untitled2/AppPages/CartxxScreen/CartScreen2.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';

// import 'package:untitled2/AppPages/MyOrders/Response/OrderDetailsResponse.dart';
import 'package:untitled2/AppPages/StreamClass/NewPeoductPage/NewProductScreen.dart';
import 'package:untitled2/AppPages/WebxxViewxx/PaymentWebView.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/Widgets/CustomButton.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';
import 'package:untitled2/utils/utils/build_config.dart';
import 'package:untitled2/utils/utils/general_functions.dart';

import 'Response/ReorderResponse.dart';

class OrderDetails extends StatefulWidget {
  OrderDetails({
    Key? key,
    required this.orderNumber,
    required this.orderDate,
    required this.orderProgress,
    required this.orderTotal,
    required this.color,
    required this.resultas,
    required this.apiToken,
    required this.customerId,
    required this.orderId,
  }) : super(key: key);
  final String orderNumber,
      orderDate,
      orderProgress,
      orderTotal,
      apiToken,
      customerId,
      orderId;

  Color color;
  dynamic resultas;

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails>
    with WidgetsBindingObserver {
  List<ReorderResponse> _reOrderResponse = [];
  String firstName = '';

  String email = '';

  String lastName = '';

  String address1 = '';
  bool isRetryPayment = false;
  var phoneNumber = '';
  var city = '';
  var countryName = '';

  // dynamic resultas = {};
  bool isPickUpStore = false;
  var sFirstName = '';

  var sLastName = '';

  var sEmail = '';
  var sPhone = '';

  var sAddress1 = '';

  var sCity = '';

  var scountryName = '';

  String sCountryName = '';
  String shippingMethod = '';
  String shippingStatus = '';

  String subTotal = '';

  String taxPrice = '';
  String totalPrice = '';

  var shipping = '';

  Widget orderItem({
    required String productId,
    required String imageUrl,
    required String title,
    required String sku,
    required String unitPrice,
    required String price,
    required String quantity,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => NewProductDetails(
                      productId: productId.toString(),
                      screenName: 'Order Details',
                    )));
      },
      child: Stack(
        children: <Widget>[
          Container(
            height: 20.h,
            margin: EdgeInsets.only(left: 10, right: 10, top: 10),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(.1),
                borderRadius: BorderRadius.all(Radius.circular(16))),
            child: Row(
              children: <Widget>[
                Container(
                    margin:
                        EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8),
                    width: 80,
                    height: 80,
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                    )),
                Expanded(
                  child: Container(
                    height: 19.h,
                    padding: EdgeInsets.all(4),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(right: 8, top: 4),
                          child: AutoSizeText(
                            'Name: ' + title,
                            softWrap: true,
                            style: CustomTextStyle.textFormFieldSemiBold
                                .copyWith(fontSize: 3.8.w),
                          ),
                        ),
                        Utils.getSizedBox(null, 4),
                        Flexible(
                          child: AutoSizeText(
                            "SKU : $sku",
                            style: CustomTextStyle.textFormFieldRegular
                                .copyWith(color: Colors.grey, fontSize: 15),
                          ),
                        ),
                        Utils.getSizedBox(null, 3),
                        Flexible(
                          child: AutoSizeText(
                            'Unit Price: ' + unitPrice,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Utils.getSizedBox(null, 3),
                        Flexible(
                          child: AutoSizeText(
                            'Sub Total: ' + price,
                            overflow: TextOverflow.ellipsis,
                            style: CustomTextStyle.textFormFieldBlack
                                .copyWith(color: Colors.green),
                          ),
                        ),
                        Utils.getSizedBox(null, 3),
                        Flexible(
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                AutoSizeText(
                                  'Quantity: ' + quantity,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 3.5.w),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  flex: 100,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);

    if (widget.orderProgress.contains('Pending')) {
      setState(() => widget.color = Colors.amberAccent);
    } else if (widget.orderProgress.contains('Cancelled')) {
      setState(() => widget.color = Colors.red);
    } else {
      setState(() => widget.color = Colors.green);
    }

    setState(() {
      if (mounted) {
        firstName = widget.resultas!['orderdetail']['orderDetailsModel']
            ['BillingAddress']['FirstName'];
        lastName = widget.resultas!['orderdetail']['orderDetailsModel']
            ['BillingAddress']['LastName'];
        address1 = widget.resultas!['orderdetail']['orderDetailsModel']
            ['BillingAddress']['Address1'];
        phoneNumber = widget.resultas!['orderdetail']['orderDetailsModel']
            ['BillingAddress']['PhoneNumber'];
        countryName = widget.resultas!['orderdetail']['orderDetailsModel']
            ['BillingAddress']['CountryName'];
        email = widget.resultas!['orderdetail']['orderDetailsModel']
            ['BillingAddress']['Email'];
        city = widget.resultas!['orderdetail']['orderDetailsModel']
            ['BillingAddress']['City'];
        isPickUpStore = widget.resultas!['orderdetail']['orderDetailsModel']
            ['PickUpInStore'];
        shippingMethod = widget.resultas!['orderdetail']['orderDetailsModel']
            ['ShippingMethod'];
        shippingStatus = widget.resultas!['orderdetail']['orderDetailsModel']
            ['ShippingStatus'];
        shipping = widget.resultas!['orderdetail']['orderDetailsModel']
            ['OrderShipping'];
        taxPrice = widget.resultas!['orderdetail']['orderDetailsModel']['Tax'];
        totalPrice =
            widget.resultas!['orderdetail']['orderDetailsModel']['OrderTotal'];
        subTotal = widget.resultas!['orderdetail']['orderDetailsModel']
            ['OrderSubtotal'];
        isRetryPayment = widget.resultas!['orderdetail']['RetryButton'];
        if (isPickUpStore == true) {
        } else {
          sFirstName = widget.resultas!['orderdetail']['orderDetailsModel']
              ['ShippingAddress']['FirstName'];
          sLastName = widget.resultas!['orderdetail']['orderDetailsModel']
              ['ShippingAddress']['LastName'];
          sAddress1 = widget.resultas!['orderdetail']['orderDetailsModel']
              ['ShippingAddress']['Address1'];
          sPhone = widget.resultas!['orderdetail']['orderDetailsModel']
              ['ShippingAddress']['PhoneNumber'];
          sCountryName = widget.resultas!['orderdetail']['orderDetailsModel']
              ['ShippingAddress']['CountryName'];
          sEmail = widget.resultas!['orderdetail']['orderDetailsModel']
              ['ShippingAddress']['Email'];
          sCity = widget.resultas!['orderdetail']['orderDetailsModel']
              ['ShippingAddress']['City'];
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: new AppBar(
          backgroundColor: ConstantsVar.appColor,
          centerTitle: true,
          toolbarHeight: 18.w,
          title: InkWell(
            child: Image.asset(
              'MyAssets/logo.png',
              width: 15.w,
              height: 15.w,
            ),
            onTap: () =>
                Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(
              builder: (context) {
                return MyApp();
              },
            ), (route) => false),
          ),
        ),
        body: Container(
          width: 100.w,
          height: 100.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                color: Colors.white60,
                width: 100.w,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(4.5.w),
                    child: AutoSizeText(
                      'My Order Details'.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 6.5.w,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Visibility(
                  visible: widget
                              .resultas!['orderdetail']['orderDetailsModel']
                                  ['Items']
                              .length ==
                          0
                      ? false
                      : true,
                  child: ListView(
                    children: [
                      Container(
                        width: 100.w,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Center(
                                  child: AutoSizeText(
                                    widget.orderNumber,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    style: CustomTextStyle.textFormFieldBold
                                        .copyWith(fontSize: 5.5.w),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 3.0, vertical: 20),
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    height: 25.w,
                                    width: 100.w,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          child: RichText(
                                            text: TextSpan(
                                                text: 'Order Status: ',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 5.w,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text: widget.orderProgress
                                                          .toUpperCase(),
                                                      style: TextStyle(
                                                          color: widget.color,
                                                          fontSize: 5.w,
                                                          fontWeight:
                                                              FontWeight.bold))
                                                ]),
                                          ),
                                        ),
                                        Utils.getSizedBox(null, 3),
                                        Container(
                                          width: 100.w,
                                          child: AutoSizeText(
                                            widget.orderDate,
                                            style: TextStyle(
                                              fontSize: 5.w,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: AppButton(
                            color: ConstantsVar.appColor,
                            child: Container(
                              width: 100.w,
                              height: 2.7.h,
                              child: Center(
                                child: AutoSizeText(
                                  widget.orderProgress.contains('Pending')
                                      ? 'Retry Payment'.toUpperCase()
                                      : 're-order'.toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 4.4.w,
                                  ),
                                ),
                              ),
                            ),
                            onTap: () async {
                              widget.orderProgress.contains('Pending')
                                  ? repayment()
                                  : reorder();
                            },
                          ),
                        ),
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
                                'Price Details',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 5.w,
                                  fontWeight: FontWeight.bold,
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
                                      fontSize: 5.w,
                                    ),
                                  ),
                                  AutoSizeText(
                                    subTotal,
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 5.w,
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
                                      fontSize: 5.w,
                                    ),
                                  ),
                                  AutoSizeText(
                                    shipping == null
                                        ? 'No Shipping Available for now '
                                        : shipping,
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 5.w,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 4.0, right: 4.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AutoSizeText(
                                    'Tax 5%:',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 5.w,
                                    ),
                                  ),
                                  AutoSizeText(
                                    taxPrice,
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 5.w,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 4.0, right: 4.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AutoSizeText(
                                    'Order Total:',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 5.w,
                                    ),
                                  ),
                                  AutoSizeText(
                                    totalPrice,
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 5.w,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Card(
                        child: Container(
                          color: Colors.white60,
                          width: 100.w,
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(3.5.w),
                              child: AutoSizeText(
                                'PRODUCT(S)'.toUpperCase(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 5.5.w,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.white60,
                        child: ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: List.generate(
                              widget
                                          .resultas!['orderdetail']
                                              ['orderDetailsModel']['Items']
                                          .length ==
                                      0
                                  ? 0
                                  : widget
                                      .resultas!['orderdetail']
                                          ['orderDetailsModel']['Items']
                                      .length, (index) {
                            var title = widget.resultas!['orderdetail']
                                    ['orderDetailsModel']['Items'][index]
                                ['ProductName'];
                            String productId = widget.resultas!['orderdetail']
                                    ['orderDetailsModel']['Items'][index]
                                    ['ProductId']
                                .toString();

                            String sku = widget.resultas!['orderdetail']
                                ['orderDetailsModel']['Items'][index]['Sku'];
                            String unitPrice = widget.resultas!['orderdetail']
                                    ['orderDetailsModel']['Items'][index]
                                ['UnitPrice'];
                            String price = widget.resultas!['orderdetail']
                                    ['orderDetailsModel']['Items'][index]
                                ['SubTotal'];
                            String quantity = widget.resultas!['orderdetail']
                                    ['orderDetailsModel']['Items'][index]
                                    ['Quantity']
                                .toString();
                            String id = widget.resultas!['orderdetail']
                                    ['orderDetailsModel']['Items'][index]
                                    ['ProductId']
                                .toString();

                            String imageUrl = widget.resultas!['orderdetail']
                                ['PictureList'][id];
                            print(imageUrl);
                            setState(() {});
                            return orderItem(
                                productId: productId,
                                title: title,
                                sku: sku,
                                unitPrice: unitPrice,
                                price: price,
                                quantity: quantity,
                                imageUrl: imageUrl);
                          }),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Card(
                        child: Container(
                          color: Colors.white60,
                          width: 100.w,
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(3.5.w),
                              child: AutoSizeText(
                                'Billing address'.toUpperCase(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 5.5.w,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: 10.0, right: 10.0, top: 6.0, bottom: 6.0),
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: Colors.white,
                          child: Container(
                            height: 25.h,
                            margin: EdgeInsets.only(
                              left: 10,
                              right: 10,
                              bottom: 3.2,
                            ),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          padding:
                                              EdgeInsets.only(right: 8, top: 4),
                                          child: AutoSizeText(
                                            firstName + ' ' + lastName,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true,
                                            style: CustomTextStyle
                                                .textFormFieldBold
                                                .copyWith(
                                              fontSize: 4.w,
                                            ),
                                          ),
                                        ),
                                        Utils.getSizedBox(null, 6),
                                        Container(
                                            child: AutoSizeText(
                                          'Email - ' + email,
                                          style: TextStyle(
                                            fontSize: 4.w,
                                          ),
                                        )),
                                        Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Flexible(
                                                child: AutoSizeText(
                                                  'Address -' + address1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 4.w,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                            child: AutoSizeText(
                                          'Phone -' + ' ' + phoneNumber,
                                          style: TextStyle(
                                            fontSize: 4.w,
                                          ),
                                        )),
                                        Container(
                                          child: AutoSizeText(
                                            'Country -' + ' ' + countryName,
                                            style: TextStyle(
                                              fontSize: 4.w,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: AutoSizeText(
                                            'City -' + ' ' + city,
                                            style: TextStyle(
                                              fontSize: 4.w,
                                            ),
                                          ),
                                        ),
                                        addVerticalSpace(12),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: !isPickUpStore,
                        child: Card(
                          child: Container(
                            color: Colors.white60,
                            width: 100.w,
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(3.5.w),
                                child: AutoSizeText(
                                  'Shipping address'.toUpperCase(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 5.5.w,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: !isPickUpStore,
                        child: Container(
                          margin: EdgeInsets.only(
                              left: 10.0, right: 10.0, top: 6.0, bottom: 6.0),
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: Colors.white,
                            child: Container(
                              height: 24.h,
                              margin: EdgeInsets.only(
                                left: 10,
                                right: 10,
                                bottom: 3.2,
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.only(
                                                right: 8, top: 4),
                                            child: AutoSizeText(
                                              sFirstName + ' ' + sLastName,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                              style: CustomTextStyle
                                                  .textFormFieldBold
                                                  .copyWith(fontSize: 4.w),
                                            ),
                                          ),
                                          Utils.getSizedBox(null, 6),
                                          Container(
                                              child: AutoSizeText(
                                            'Email - ' + sEmail,
                                            style: TextStyle(
                                              fontSize: 4.w,
                                            ),
                                          )),
                                          Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Flexible(
                                                  child: AutoSizeText(
                                                    'Address -' + sAddress1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 4.w),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            child: AutoSizeText(
                                              'Phone -' + ' ' + sPhone,
                                              style: TextStyle(
                                                fontSize: 4.w,
                                              ),
                                            ),
                                          ),
                                          Container(
                                              child: AutoSizeText(
                                            'Country -' + ' ' + sCountryName,
                                            style: TextStyle(
                                              fontSize: 4.w,
                                            ),
                                          )),
                                          Container(
                                              child: AutoSizeText(
                                            'City -' + ' ' + sCity,
                                            style: TextStyle(
                                              fontSize: 4.w,
                                            ),
                                          )),
                                          addVerticalSpace(12),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Card(
                        child: Container(
                          color: Colors.white60,
                          width: 100.w,
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(3.8.w),
                              child: AutoSizeText(
                                'Shipping Method'.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 5.5.w,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Card(
                        child: Container(
                          color: Colors.white60,
                          width: 100.w,
                          child: Padding(
                            padding: EdgeInsets.all(3.5.w),
                            child: Center(
                              child: AutoSizeText(
                                shippingMethod,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 4.w,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Card(
                        child: Container(
                          color: Colors.white60,
                          width: 100.w,
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(3.8.w),
                              child: AutoSizeText(
                                'Shipping Status'.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 5.5.w,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Card(
                        child: Container(
                          color: Colors.white60,
                          width: 100.w,
                          child: Padding(
                            padding: EdgeInsets.all(3.5.w),
                            child: Center(
                              child: AutoSizeText(
                                shippingStatus,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 4.w,
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
            ],
          ),
        ),
      ),
    );
  }

  Future reorder() async {
    final uri = Uri.parse(BuildConfig.base_url +
        'apis/CustomerReOrder?OrderId=${widget.orderId}&CustomerId=${widget.customerId}&apiToken=${widget.apiToken}');
    var response = await get(uri, headers: ApiCalls.header);
    try {
      List<dynamic> result = jsonDecode(response.body);
      // ReorderResponse resp = ReorderResponse.fromJson(result);
      _reOrderResponse =
          result.map((r) => ReorderResponse.fromJson(r)).toList();
      for (int i = 0; i < _reOrderResponse.length; i++) {
        if (_reOrderResponse[i].status.contains('Failed')) {
          Fluttertoast.showToast(
              msg:
                  'This product is Out of Stock.\n${_reOrderResponse[i].responseData}');
        }
      }
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => CartScreen2(
            otherScreenName: '',
            isOtherScren: false,
          ),
        ),
      );
      print(response.body);
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }

  repayment() {
    final String paymentUrl = BuildConfig.base_url +
        'apis/RePayment?OrderId=${widget.orderId}&CustomerId=${widget.customerId}&apiToken=${widget.apiToken}';
    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(
        builder: (context) => PaymentPage(
          paymentUrl: paymentUrl,
        ),
      ),
    );
  }
}
