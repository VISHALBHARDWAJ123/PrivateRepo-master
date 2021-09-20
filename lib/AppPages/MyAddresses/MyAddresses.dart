import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:untitled2/AppPages/CustomLoader/CustomLoader.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/MyAddresses/MyAddressItem.dart';
import 'package:untitled2/AppPages/ShippingxxxScreen/AddressForm.dart';
import 'package:untitled2/AppPages/models/AddressResponse.dart';
import 'package:untitled2/AppPages/models/OrderSummaryResponse.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/Widgets/CustomButton.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';
import 'package:untitled2/utils/utils/general_functions.dart';

class MyAddresses extends StatefulWidget {
  MyAddresses({Key? key}) : super(key: key);

  @override
  _MyAddressesState createState() => _MyAddressesState();
}

class _MyAddressesState extends State<MyAddresses> with WidgetsBindingObserver {
  var eController = TextEditingController();
  bool showLoading = false;
  bool showAddresses = false;
  late AddressResponse addressResponse;
  late List<ExistingAddresses> existingAddress = [];
  OrderSummaryResponse? orderSummaryResponse;
  bool showCartSummary = false;
  var guestCustomerId;
  var apiToken;

  RefreshController _myController = RefreshController();

  @override
  void initState() {
    context.loaderOverlay.show(
        widget: SpinKitRipple(
      color: Colors.red,
      size: 90,
    ));
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    getCustomerId().then((value) =>
        ApiCalls.allAddresses(ConstantsVar.apiTokken.toString(), value, context)
            .then((value) {
          print(value);
          setState(() {
            addressResponse = AddressResponse.fromJson(value);
            existingAddress =
                addressResponse.billingaddresses.existingAddresses;
            print('address>>> $addressResponse');
            showAddresses = true;

            /*************************Get all order summary*********************/
            ApiCalls.showOrderSummary(
                    ConstantsVar.apiTokken.toString(), guestCustomerId)
                .then((value) {
              print('ordersummary>>> $value');
              orderSummaryResponse = OrderSummaryResponse.fromJson(value);

              print('odrerv $orderSummaryResponse');
              setState(() {
                ConstantsVar.orderSummaryResponse =
                    jsonEncode(orderSummaryResponse);
                context.loaderOverlay.hide();
                String orderSummary = ConstantsVar.orderSummaryResponse;
                ConstantsVar.orderSummaryResponse = orderSummary;
                print('abc $orderSummary');
              });
            });
            /*********************** End of order summary ******************/
          });
        }));
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:

        break;

      case AppLifecycleState.paused:
        break;

      case AppLifecycleState.inactive:
        break;

      case AppLifecycleState.detached:
        break;
    }
  }

  bool isLoading = false;

  void _showLoadingIndicator() {
    print('isloading');
    setState(() {
      isLoading = true;
    });
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        isLoading = false;
      });
      print(isLoading);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (orderSummaryResponse == null) {
      return Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
      );
    } else {
      return SafeArea(
        top: true,
        child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 18.w,
              backgroundColor: ConstantsVar.appColor,
              title: InkWell(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => MyHomePage(),
                      ),
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
            body: SmartRefresher(
              header: WaterDropHeader(),

              enablePullDown: true,
              onRefresh: () async{
                print(isLoading);

                ApiCalls.allAddresses(
                    ConstantsVar.apiTokken.toString(), guestCustomerId, context)
                    .then((value) {
                  print('Resumed>>>  $value');
                  setState(() {
                    addressResponse = AddressResponse.fromJson(value);
                    existingAddress =
                        addressResponse.billingaddresses.existingAddresses;
                    print('address>>> $addressResponse');
                    showAddresses = true;
                  });
                });


              },
              controller: _myController,
              child: Stack(children: [
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Visibility(
                          visible: existingAddress.isEmpty ? false : true,
                          child: addVerticalSpace(12.0)),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              textStyle: TextStyle(
                                  fontSize: 26.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            onPressed: () async {
                              Navigator.push(context,
                                  CupertinoPageRoute(builder: (context) {
                                return AddressScreen(
                                  uri: 'MyAccount',
                                  isShippingAddress: false,
                                  isEditAddress: false,
                                  firstName: '',
                                  lastName: '',
                                  email: '',
                                  address1: '',
                                  countryName: '',
                                  city: '',
                                  phoneNumber: '',
                                  id: 0, myCallBack: () {ApiCalls.allAddresses(
                                    ConstantsVar.apiTokken.toString(), guestCustomerId, context)
                                    .then((value) {
                                  print('Resumed>>>  $value');
                                  setState(() {
                                    _myController.requestRefresh();
                                    addressResponse = AddressResponse.fromJson(value);
                                    existingAddress =
                                        addressResponse.billingaddresses.existingAddresses;
                                    print('address>>> $addressResponse');
                                    showAddresses = true;
                                    _myController.refreshCompleted();
                                  });
                                });  },
                                );
                              }));
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 50.0),
                              child: Container(
                                height: 5.h,
                                decoration: BoxDecoration(
                                    color: ConstantsVar.appColor,
                                    borderRadius: BorderRadius.circular(6.0)),
                                child: Center(
                                  child: Text(
                                    'Add New Address',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 4.w),
                                  ),
                                ),
                              ),
                            ),
                          )),

                      /************** Show Address List ******************/
                      Visibility(
                        visible: existingAddress.isEmpty ? false : true,
                        child: ListView(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          children: List.generate(
                              existingAddress.length,
                              (index) => MyAddressItem(
                                    // buttonName: "Bill To This Address",
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
                                    countryName:
                                        existingAddress[index].countryName,
                                    stateProvinceEnabled: existingAddress[index]
                                        .stateProvinceEnabled,
                                    cityEnabled:
                                        existingAddress[index].cityEnabled,
                                    cityRequired:
                                        existingAddress[index].cityRequired,
                                    city: existingAddress[index].city,
                                    streetAddressEnabled: existingAddress[index]
                                        .streetAddressEnabled,
                                    streetAddressRequired: existingAddress[index]
                                        .streetAddressRequired,
                                    address1: existingAddress[index].address1,
                                    streetAddress2Enabled: existingAddress[index]
                                        .streetAddress2Enabled,
                                    streetAddress2Required: existingAddress[index]
                                        .streetAddress2Required,
                                    zipPostalCodeEnabled: existingAddress[index]
                                        .zipPostalCodeEnabled,
                                    zipPostalCodeRequired: existingAddress[index]
                                        .zipPostalCodeRequired,
                                    zipPostalCode:
                                        existingAddress[index].zipPostalCode,
                                    phoneEnabled:
                                        existingAddress[index].phoneEnabled,
                                    phoneRequired:
                                        existingAddress[index].phoneRequired,
                                    phoneNumber:
                                        existingAddress[index].phoneNumber,
                                    faxEnabled: existingAddress[index].faxEnabled,
                                    faxRequired:
                                        existingAddress[index].faxRequired,
                                    faxNumber: existingAddress[index].faxNumber,
                                    id: existingAddress[index].id,
                                    callback: (String value) {},
                                    guestId: guestCustomerId,
                                    // isLoading: isLoading,
                                  )),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(child: isLoading ? Loader() : Container()),
                Visibility(
                  visible: showLoading,
                  child: Positioned(
                    child:
                        Align(alignment: Alignment.center, child: showloader()),
                  ),
                ),
              ]),
            )),
      );
    }
  }

  Future getCustomerId() async {
    guestCustomerId = ConstantsVar.prefs.getString('guestCustomerID');
    return guestCustomerId;
  }
}

Card cartItemView(Item item) {
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
                    child: Text(
                      item.picture.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: CustomTextStyle.textFormFieldSemiBold
                          .copyWith(fontSize: 16),
                    ),
                  ),
                  Utils.getSizedBox(null, 6),
                  Text(
                    "SKU : ${item.sku}",
                    style: CustomTextStyle.textFormFieldRegular
                        .copyWith(color: Colors.grey, fontSize: 15),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Text(
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
                                child: Text(
                                  "${item.quantity}",
                                  style: CustomTextStyle.textFormFieldSemiBold,
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
