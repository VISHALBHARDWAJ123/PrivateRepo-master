import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/MyOrders/Response/OrderDetailsResponse.dart';
import 'package:untitled2/AppPages/StreamClass/NewPeoductPage/NewProductScreen.dart';
import 'package:untitled2/Widgets/CustomButton.dart';
import 'package:untitled2/utils/utils/build_config.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:untitled2/utils/utils/general_functions.dart';

class OrderDetails extends StatefulWidget {
  OrderDetails({
    Key? key,
    required this.orderNumber,
    required this.orderDate,
    required this.orderProgress,
    required this.orderTotal,
    required this.apiToken,
    required this.orderid,
    required this.customerId,
    required this.color,
  }) : super(key: key);
  final String orderNumber,
      orderDate,
      orderProgress,
      orderTotal,
      apiToken,
      orderid,
      customerId;
  Color color;

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails>
    with WidgetsBindingObserver {
  String firstName = '';

  String email = '';

  String lastName = '';

  String address1 = '';

  var phoneNumber = '';
  var city = '';
  var countryName = '';
  var resultas = {};
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
                builder: (context) =>
                    NewProductDetails(productId: productId.toString())));
      },
      child: Stack(
        children: <Widget>[
          Container(
            height: 16.5.h,
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
                    height: 14.h,
                    padding: EdgeInsets.all(4),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(right: 8, top: 4),
                          child: Text(
                            'Name: ' + title,
                            softWrap: true,
                            style: CustomTextStyle.textFormFieldSemiBold
                                .copyWith(fontSize: 3.8.w),
                          ),
                        ),
                        Utils.getSizedBox(null, 4),
                        Flexible(
                          child: Text(
                            "SKU : $sku",
                            style: CustomTextStyle.textFormFieldRegular
                                .copyWith(color: Colors.grey, fontSize: 15),
                          ),
                        ),
                        Utils.getSizedBox(null, 3),
                        Flexible(
                          child: Text(
                            'Unit Price: ' + unitPrice,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Utils.getSizedBox(null, 3),

                        Flexible(
                          child: Text(
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
                                Text(
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
    context.loaderOverlay.show(
        widget: SpinKitRipple(
      color: Colors.red,
      size: 90,
    ));
    print(widget.customerId);
    getOderDetails().then((value) => setState(() {
          resultas = value;
          firstName = resultas['orderdetail']['orderDetailsModel']
              ['BillingAddress']['FirstName'];
          lastName = resultas['orderdetail']['orderDetailsModel']
              ['BillingAddress']['LastName'];
          address1 = resultas['orderdetail']['orderDetailsModel']
              ['BillingAddress']['Address1'];
          phoneNumber = resultas['orderdetail']['orderDetailsModel']
              ['BillingAddress']['PhoneNumber'];
          countryName = resultas['orderdetail']['orderDetailsModel']
              ['BillingAddress']['CountryName'];
          email = resultas['orderdetail']['orderDetailsModel']['BillingAddress']
              ['Email'];
          city = resultas['orderdetail']['orderDetailsModel']['BillingAddress']
              ['City'];
          isPickUpStore =
              resultas['orderdetail']['orderDetailsModel']['PickUpInStore'];
          shippingMethod =
              resultas['orderdetail']['orderDetailsModel']['ShippingMethod'];
          shipping =
              resultas['orderdetail']['orderDetailsModel']['OrderShipping'];
          taxPrice = resultas['orderdetail']['orderDetailsModel']['Tax'];
          totalPrice =
              resultas['orderdetail']['orderDetailsModel']['OrderTotal'];
          subTotal =
              resultas['orderdetail']['orderDetailsModel']['OrderSubtotal'];
          if (isPickUpStore == true) {
          } else {
            sFirstName = resultas['orderdetail']['orderDetailsModel']
                ['ShippingAddress']['FirstName'];
            sLastName = resultas['orderdetail']['orderDetailsModel']
                ['ShippingAddress']['LastName'];
            sAddress1 = resultas['orderdetail']['orderDetailsModel']
                ['ShippingAddress']['Address1'];
            sPhone = resultas['orderdetail']['orderDetailsModel']
                ['ShippingAddress']['PhoneNumber'];
            sCountryName = resultas['orderdetail']['orderDetailsModel']
                ['ShippingAddress']['CountryName'];
            sEmail = resultas['orderdetail']['orderDetailsModel']
                ['ShippingAddress']['Email'];
            sCity = resultas['orderdetail']['orderDetailsModel']
                ['ShippingAddress']['City'];
          }
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: new AppBar(
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
                      child: Text(
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
                  child: ListView(
                    children: [
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
                                'Price Details',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 4.5.w,
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
                              padding:
                              const EdgeInsets.only(left: 4.0, right: 4.0),
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
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.only(left: 4.0, right: 4.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Order Total:',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    totalPrice,
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

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
                                  child: Text(
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
                                    height: 30.w,
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
                                                    fontSize: 4.w,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text:
                                                          widget.orderProgress,
                                                      style: TextStyle(
                                                          color: widget.color,
                                                          fontSize: 4.w,
                                                          fontWeight:
                                                              FontWeight.bold))
                                                ]),
                                          ),
                                        ),
                                        Utils.getSizedBox(null, 3),
                                        Container(
                                            child: Text(
                                          widget.orderDate,
                                          style: TextStyle(
                                            fontSize: 4.w,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )),
                                        Utils.getSizedBox(null, 3),
                                        Container(
                                          child: Text(
                                            widget.orderTotal,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 4.w,
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
                      Container(
                        color: Colors.white60,
                        width: 100.w,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(3.5.w),
                            child: Text(
                              'PRODUCT(S)'.toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 5.5.w,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: List.generate(
                              resultas['orderdetail']['orderDetailsModel']
                              ['Items']
                                  .length ==
                                  0
                                  ? 0
                                  : resultas['orderdetail']['orderDetailsModel']
                              ['Items']
                                  .length, (index) {
                            var title = resultas['orderdetail']
                            ['orderDetailsModel']['Items'][index]
                            ['ProductName'];
                            String productId = resultas['orderdetail']
                            ['orderDetailsModel']['Items'][index]
                            ['ProductId']
                                .toString();

                            String sku = resultas['orderdetail']
                            ['orderDetailsModel']['Items'][index]['Sku'];
                            String unitPrice = resultas['orderdetail']
                            ['orderDetailsModel']['Items'][index]
                            ['UnitPrice'];
                            String price = resultas['orderdetail']
                            ['orderDetailsModel']['Items'][index]
                            ['SubTotal'];
                            String quantity = resultas['orderdetail']
                            ['orderDetailsModel']['Items'][index]
                            ['Quantity']
                                .toString();
                            String id = resultas['orderdetail']
                            ['orderDetailsModel']['Items'][index]['Id']
                                .toString();

                            String imageUrl =
                            resultas['orderdetail']['PictureList'][id];
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
                        height: 15,),
                      Container(
                        color: Colors.white60,
                        width: 100.w,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(3.5.w),
                            child: Text(
                              'Billing address'.toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 5.5.w,
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
                                          child: Text(
                                            firstName + ' ' + lastName,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true,
                                            style: CustomTextStyle
                                                .textFormFieldBold
                                                .copyWith(fontSize: 16),
                                          ),
                                        ),
                                        Utils.getSizedBox(null, 6),
                                        Container(
                                            child: Text('Email - ' + email)),
                                        Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Flexible(
                                                child: Text(
                                                  'Address -' + address1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                            child: Text(
                                                'Phone -' + ' ' + phoneNumber)),
                                        Container(
                                            child: Text('Country -' +
                                                ' ' +
                                                countryName)),
                                        Container(
                                            child: Text('City -' + ' ' + city)),
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
                        child: Container(
                          color: Colors.white60,
                          width: 100.w,
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(3.5.w),
                              child: Text(
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
                                            padding: EdgeInsets.only(
                                                right: 8, top: 4),
                                            child: Text(
                                              sFirstName + ' ' + sLastName,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                              style: CustomTextStyle
                                                  .textFormFieldBold
                                                  .copyWith(fontSize: 16),
                                            ),
                                          ),
                                          Utils.getSizedBox(null, 6),
                                          Container(
                                              child: Text('Email - ' + sEmail)),
                                          Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Flexible(
                                                  child: Text(
                                                    'Address -' + sAddress1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        TextStyle(fontSize: 15),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                              child: Text(
                                                  'Phone -' + ' ' + sPhone)),
                                          Container(
                                              child: Text('Country -' +
                                                  ' ' +
                                                  sCountryName)),
                                          Container(
                                              child:
                                                  Text('City -' + ' ' + sCity)),
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
                          child: Padding(
                            padding: EdgeInsets.all(2.5.w),
                            child: Center(
                              child: Text(
                                'Shipping Method: '.toUpperCase() +
                                    shippingMethod,
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
              ],
            )),
      ),
    );
  }

  Future getOderDetails() async {
    print('Order Id =====>>>>>>> ' + widget.orderid);
    final uri = Uri.parse(BuildConfig.base_url +
        "apis/GetCustomerOrderDetail?apiToken=${widget.apiToken}&customerId=${widget.customerId}&orderid=${widget.orderid}");

    var response = await http.get(uri);

    try {
      var result = jsonDecode(response.body);
      print(result);

      context.loaderOverlay.hide();
      return result;
    } on Exception catch (e) {
      print(e.toString());

      context.loaderOverlay.hide();
    }
  }
}
