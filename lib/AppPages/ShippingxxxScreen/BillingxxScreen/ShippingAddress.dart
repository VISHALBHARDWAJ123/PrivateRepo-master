import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:progress_loading_button/progress_loading_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/ShippingxxxScreen/ShippingxxModel/ShippingxxModel.dart';
import 'package:untitled2/AppPages/WebxxViewxx/PaymentWebView.dart';
import 'package:untitled2/AppPages/models/OrderSummaryResponse.dart';
import 'package:untitled2/AppPages/models/ShippingResponse.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/Widgets/CustomButton.dart'; // import 'package:untitled2/models/OrderSummaryResponse.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';
import 'package:untitled2/utils/utils/build_config.dart';
import 'package:untitled2/utils/utils/general_functions.dart';

import '../AddressItem.dart';
import '../ShippingPage.dart';

class ShippingAddress extends StatefulWidget {
  @override
  _ShippingAddressState createState() => _ShippingAddressState();
}

class _ShippingAddressState extends State<ShippingAddress> {
  List<PickupPointsxx> myPickPoint = [];
  bool showLoading = false;
  bool showAddresses = false;
  late List<ExistingAddresses> existingAddress = [];
  OrderSummaryResponse? orderSummaryResponse;
  bool showCartSummary = false;
  var ID;
  bool isChecked = false, isVisible = true;
  String paymentUrl = '';

  List<String> _list = [];
  var addressString;
  bool isSelected = false;
  var selectedVal = '';

  var _willGo = true;

  /// this func is used to close dropDown (if open) when you tap or pandown anywhere in the screen

  Future<void> getPickupPoints(String? addressString) async {
    setState(() => _willGo = false);
    final pickUri = Uri.parse(BuildConfig.base_url +
        'apis/GetPickupPoints?apiToken=${ConstantsVar.apiTokken}&address=${addressString!}&CustomerId=$ID');
    try {
      var pickPointResponse = await http.get(pickUri);
      print('${pickPointResponse.body}');
      PickUpPointResponse myPickResponse =
          PickUpPointResponse.fromJson(jsonDecode(pickPointResponse.body));
      print(json.decode(pickPointResponse.body));
      setState(() {
        myPickPoint.addAll(myPickResponse.responseData);
        setState(() => _willGo = true);
        for (var i = 0; i < myPickPoint.length; i++) {
          print(myPickPoint[i].name);
          _list.add(myPickPoint[i].name);
        }
      });
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }

  /// this fu
  @override
  void initState() {
    super.initState();
    setState(() => _willGo = false);
    // _list = ["Abc", "DEF", "GHI", "JKL", "MNO", "PQR"];
    context.loaderOverlay.show(
      widget: SpinKitRipple(
        color: Colors.red,
        size: 90,
      ),
    );
    getId().then(
      (id) =>
          ApiCalls.getShippingAddresses(ConstantsVar.apiTokken.toString(), id)
              .then(
        (value) {
          setState(
            () {
              ID = id;
              print('shipping val $value');
              ShippingResponse response = ShippingResponse.fromJson(value);
              existingAddress = response.shippingaddresses.existingAddress;
              print('shippp>> $response');
              showAddresses = true;

              getPickupPoints(addressString);
              paymentUrl = BuildConfig.base_url +
                  'customer/CreateCustomerOrder?apiToken=${ConstantsVar.apiTokken.toString()}&CustomerId=$id&PaymentMethod=Payments.CyberSource';
              /*************************Get all order summary*********************/
              ApiCalls.showOrderSummary(ConstantsVar.apiTokken.toString(), id)
                  .then(
                (value) {
                  print('ordersummary>>> $value');
                  orderSummaryResponse = OrderSummaryResponse.fromJson(value);
                  context.loaderOverlay.hide();
                  print('odrerv $orderSummaryResponse');
                  setState(
                    () {
                      ConstantsVar.orderSummaryResponse =
                          jsonEncode(orderSummaryResponse);

                      String orderSummary = ConstantsVar.orderSummaryResponse;
                      ConstantsVar.orderSummaryResponse = orderSummary;
                      context.loaderOverlay.hide();
                      // print('abc $orderSummary');
                    },
                  );
                },
              );
              /*********************** End of order summary ******************/
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (orderSummaryResponse == null) {
      return Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          // child: Center(child: Text('No Orders')),
        ),
      );
    } else {
      return WillPopScope(
        onWillPop: _willGo ? null : () async => false,
        child: SafeArea(
          top: true,
          bottom: true,
          maintainBottomViewPadding: true,
          child: Scaffold(
              appBar: AppBar(
                toolbarHeight: 18.w,
                backgroundColor: ConstantsVar.appColor,
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
                centerTitle: true,
              ),
              body: buildStack(context)),
        ),
      );
    }
  }

  Widget buildStack(BuildContext context) {
    return ListView(children: [
      Column(
        children: <Widget>[
          Card(
            child: Container(
              width: 100.w,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Center(
                    child: AutoSizeText(
                  'Shipping Details'.toUpperCase(),
                  style: TextStyle(
                    fontSize: 6.w,
                    fontWeight: FontWeight.bold,
                  ),
                )),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100.w,
                  child: Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RoundCheckBox(
                          size: 30,
                          onTap: (selected) {
                            setState(() {
                              print('Tera kaam  bngya');
                              isChecked
                                  ? isChecked = selected!
                                  : isChecked = selected!;

                              isVisible ? isVisible = false : isVisible = true;
                            });
                          },
                          isChecked: isChecked,
                          checkedWidget: Icon(
                            Icons.check,
                            size: 25,
                            color: ConstantsVar.appColor,
                          ),
                          uncheckedWidget: null,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.w),
                          child: AutoSizeText(
                            'Click & Collect',
                            style: TextStyle(
                              fontSize: 5.7.w,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: AutoSizeText(
                    ConstantsVar.stringShipping,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 3.8.w,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Visibility(
                    visible: isChecked,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ListView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: List.generate(
                          myPickPoint.length,
                          (index) => Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: LoadingButton(
                              color: Colors.white,
                              defaultWidget: AutoSizeText(
                                  myPickPoint[index].name,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 4.6.w, color: Colors.black)),
                              width: 100.w,
                              height: 18.w,
                              onPressed: () async {
                                context.loaderOverlay.show(widget: Container());
                                await ApiCalls.addAndSelectShippingAddress(
                                        '${ConstantsVar.apiTokken}',
                                        ID,
                                        myPickPoint[index].id)
                                    .then(
                                  (value) {
                                    context.loaderOverlay.hide();
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        content: Container(
                                          height: 4.h,
                                          child: RichText(
                                            textAlign: TextAlign.center,
                                            text: TextSpan(
                                              text: 'You have selected:\n',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 3.5.w,
                                                  fontWeight: FontWeight.bold),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text:
                                                        '${myPickPoint[index].name}',
                                                    style: TextStyle(
                                                        fontSize: 3.w,
                                                        fontWeight:
                                                            FontWeight.bold))
                                              ],
                                            ),
                                          ),
                                        ),
                                        title: AutoSizeText(
                                          'This will lead you to payment page.',
                                          textAlign: TextAlign.center,
                                          softWrap: true,
                                          style: TextStyle(
                                            fontSize: 5.w,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: AutoSizeText(
                                              'Cancel'.toUpperCase(),
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                builder: (context) =>
                                                    PaymentPage(
                                                  paymentUrl: paymentUrl,
                                                  // customerId: ID,
                                                ),
                                              ),
                                            ),
                                            child: AutoSizeText(
                                              'Confirm'.toUpperCase(),
                                              style: TextStyle(
                                                  color: Colors.green),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    )),

                addVerticalSpace(12.0),
                Visibility(
                  visible: existingAddress.isEmpty ? false : true,
                  child: Visibility(
                    visible: isVisible,
                    child: Visibility(
                      visible: existingAddress.length == 0 ? false : true,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                            margin: EdgeInsets.only(left: 10.0),
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: AutoSizeText(
                                'Or Select a Shipping Address',
                                style: TextStyle(
                                    fontSize: 6.w, fontWeight: FontWeight.bold),
                              ),
                            )),
                      ),
                    ),
                  ),
                ),

                /************** Show Address List ******************/
                Visibility(
                  visible: existingAddress.isEmpty ? false : true,
                  child: Visibility(
                    visible: isVisible,
                    child: ListView(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      children: List.generate(
                          existingAddress.length,
                          (index) => AddressItem(
                                buttonName: "Ship To This Address",
                                firstName: existingAddress[index].firstName,
                                lastName: existingAddress[index].lastName,
                                email: existingAddress[index].email,
                                companyEnabled:
                                    existingAddress[index].companyEnabled,
                                companyRequired:
                                    existingAddress[index].companyRequired,
                                countryEnabled:
                                    existingAddress[index].countryEnabled,
                                countryId: existingAddress[index].countryId,
                                countryName: existingAddress[index].countryName,
                                stateProvinceEnabled:
                                    existingAddress[index].stateProvinceEnabled,
                                cityEnabled: existingAddress[index].cityEnabled,
                                cityRequired:
                                    existingAddress[index].cityRequired,
                                city: existingAddress[index].city,
                                streetAddressEnabled:
                                    existingAddress[index].streetAddressEnabled,
                                streetAddressRequired: existingAddress[index]
                                    .streetAddressRequired,
                                address1: existingAddress[index].address1,
                                streetAddress2Enabled: existingAddress[index]
                                    .streetAddress2Enabled,
                                streetAddress2Required: existingAddress[index]
                                    .streetAddress2Required,
                                zipPostalCodeEnabled:
                                    existingAddress[index].zipPostalCodeEnabled,
                                zipPostalCodeRequired: existingAddress[index]
                                    .zipPostalCodeRequired,
                                zipPostalCode:
                                    existingAddress[index].zipPostalCode,
                                phoneEnabled:
                                    existingAddress[index].phoneEnabled,
                                phoneRequired:
                                    existingAddress[index].phoneRequired,
                                phoneNumber: existingAddress[index].phoneNumber,
                                faxEnabled: existingAddress[index].faxEnabled,
                                faxRequired: existingAddress[index].faxRequired,
                                faxNumber: existingAddress[index].faxNumber,
                                id: existingAddress[index].id,
                                callback: (String value) {},
                                guestId: ID,
                                // isLoading: isLoading,
                              )),
                    ),
                  ),
                ),

                /**************** Show order summary here ****************/
                Visibility(
                  visible: isVisible,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 40.0,
                      bottom: 10,
                    ),
                    child: Container(
                        // margin: EdgeInsets.only(left: 10.0),
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: AutoSizeText(
                            'Or Add a New Shipping Address',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 6.w, fontWeight: FontWeight.bold),
                          ),
                        )),
                  ),
                ),
                Visibility(
                  visible: isVisible,
                  child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      width: MediaQuery.of(context).size.width,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          textStyle: TextStyle(
                              fontSize: 6.w,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        onPressed: () async {
                          Navigator.pushReplacement(context,
                              CupertinoPageRoute(builder: (context) {
                            return ShippingDetails(
                              customerId: ID,
                              tokken: ConstantsVar.apiTokken.toString(),
                            );
                          }));
                        },
                        child: Container(
                          height: 6.h,
                          decoration: BoxDecoration(
                              color: ConstantsVar.appColor,
                              borderRadius: BorderRadius.circular(6.0)),
                          child: Center(
                            child: AutoSizeText(
                              'Add New Address',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 4.w),
                            ),
                          ),
                        ),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Card(
                      color: Colors.white60,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Center(
                            child: AutoSizeText(
                              'Order Summary',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 6.4.w),
                            ),
                          ),
                        ),
                      )),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(8.0),
                    itemCount: orderSummaryResponse != null
                        ? orderSummaryResponse!.ordersummary.items.length
                        : 0,
                    itemBuilder: (context, index) {
                      // setState(() {
                      //   showCartSummary = true;
                      //   // This val is used to show the view at bottom(summary)
                      // });

                      return cartItemView(
                          orderSummaryResponse!.ordersummary.items[index]);
                    }),
                Card(
                  elevation: 10,
                  child: Container(
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
                        // Container(
                        //   width: MediaQuery.of(context).size.width,
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(6.0),
                        //     child: Center(
                        //       child: Text(
                        //         'Order Details'.toUpperCase(),
                        //         style: TextStyle(
                        //           fontWeight: FontWeight.bold,
                        //           fontFamily: 'Poppins',
                        //           fontSize: 20,
                        //           color: Colors.black,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AutoSizeText(
                                'Sub-Total:',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 15,
                                ),
                              ),
                              AutoSizeText(
                                orderSummaryResponse!.ordertotals.subTotal
                                    .toString(),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AutoSizeText(
                                'Shipping:',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 15,
                                ),
                              ),
                              AutoSizeText(
                                orderSummaryResponse!.ordertotals.shipping ==
                                        null
                                    ? 'During Checkout'
                                    : orderSummaryResponse!.ordertotals.shipping
                                        .toString(),
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
                            visible: true,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Visibility(
                                  visible: orderSummaryResponse!
                                              .ordertotals.orderTotalDiscount ==
                                          null
                                      ? false
                                      : true,
                                  child: AutoSizeText(
                                    'Discount:',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: orderSummaryResponse!
                                              .ordertotals.orderTotalDiscount ==
                                          null
                                      ? false
                                      : true,
                                  child: AutoSizeText(
                                    orderSummaryResponse!
                                        .ordertotals.orderTotalDiscount
                                        .toString(),
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AutoSizeText(
                                'Tax 5%:',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                ),
                              ),
                              AutoSizeText(
                                orderSummaryResponse!.ordertotals.tax,
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
                          child: Visibility(
                            visible: true,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AutoSizeText(
                                  'Total:',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                  ),
                                ),
                                AutoSizeText(
                                  orderSummaryResponse!
                                              .ordertotals.orderTotal ==
                                          null
                                      ? 'During Checkout'
                                      : orderSummaryResponse!
                                          .ordertotals.orderTotal,
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /******************* Show cart summary ********************/
                // Visibility(
                //     visible: showCartSummary,
                //     child: Container(
                //         child: orderSummaryResponse != null
                //             ? showCartSummaryView(orderSummaryResponse)
                //             : Text('No result found')))
              ],
            ),
          ),
          Visibility(
            visible: showLoading,
            child: Positioned(
              child: Align(alignment: Alignment.center, child: showloader()),
            ),
          ),
        ],
      )
    ]);
  }

  Card cartItemView(Item item) {
    // setState(() {
    //   showCartSummary = true;
    // });
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(16))),
        child: Row(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8),
                width: 80,
                height: 80,
                child: CachedNetworkImage(
                  imageUrl: item.picture.imageUrl,
                  fit: BoxFit.cover,
                )),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(right: 8, top: 4),
                      child: AutoSizeText(
                        item.picture.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: CustomTextStyle.textFormFieldSemiBold
                            .copyWith(fontSize: 3.w),
                      ),
                    ),
                    Utils.getSizedBox(null, 6),
                    AutoSizeText(
                      "SKU : ${item.sku}",
                      style: CustomTextStyle.textFormFieldRegular
                          .copyWith(color: Colors.grey, fontSize: 2.8.w),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: AutoSizeText(
                              item.unitPrice,
                              overflow: TextOverflow.ellipsis,
                              style: CustomTextStyle.textFormFieldBlack
                                  .copyWith(color: Colors.green),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  color: Colors.grey.shade200,
                                  padding: const EdgeInsets.only(
                                      bottom: 2, right: 12, left: 12),
                                  child: AutoSizeText(
                                    "${item.quantity}",
                                    style:
                                        CustomTextStyle.textFormFieldSemiBold,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // /*************** Show cart summary view ********************/
  Container showCartSummaryView(OrderSummaryResponse orderSummaryResponse) {
    bool showDiscount = false;
    if (orderSummaryResponse != null) {
      setState(() {
        if (orderSummaryResponse.ordertotals.subTotalDiscount == null ||
            orderSummaryResponse.ordertotals.subTotalDiscount.length == 0) {
          showDiscount = false;
        } else {
          showDiscount = true;
        }
      });

      return Container(
        child: Column(children: <Widget>[
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AutoSizeText(
                        'Sub-Total:',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                        ),
                      ),
                      AutoSizeText(
                        orderSummaryResponse.ordertotals.subTotal,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AutoSizeText(
                        'Shipping:',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                        ),
                      ),
                      AutoSizeText(
                        orderSummaryResponse.ordertotals.shipping == null
                            ? 'No Shipping Available for now '
                            : orderSummaryResponse.ordertotals.shipping,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AutoSizeText(
                          'Discount:',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                          ),
                        ),
                        AutoSizeText(
                          orderSummaryResponse.ordertotals.subTotalDiscount,
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
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
                  orderSummaryResponse.ordertotals.orderTotal == null
                      ? 'During Checkout'
                      : orderSummaryResponse.ordertotals.orderTotal,
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ]),
      );
    } else {
      return Container(child: AutoSizeText('No result found'));
    }
  }

  Future getId() async {
    String customerID = ConstantsVar.prefs.getString('guestCustomerID')!;
    setState(() {
      addressString = ConstantsVar.prefs.getString('addressJsonString')!;
    });
    return customerID;
  }

  Future<bool> hideCxt() async {
    return true;
  }

  Future showOverload() async {
    context.loaderOverlay.show(
        widget: SpinKitRipple(
      color: Colors.red,
      size: 90,
    ));
  }
}
