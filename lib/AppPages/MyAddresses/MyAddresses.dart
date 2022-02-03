import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/MyAddresses/MyAddressItem.dart';
import 'package:untitled2/AppPages/ShippingxxxScreen/AddressForm.dart';
import 'package:untitled2/AppPages/models/AddressResponse.dart';
import 'package:untitled2/AppPages/models/OrderSummaryResponse.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/Widgets/CustomButton.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';
import 'package:untitled2/utils/utils/colors.dart';
import 'package:untitled2/utils/utils/general_functions.dart';

import 'AddressResponse.dart';

class MyAddresses extends StatefulWidget {
  MyAddresses({Key? key}) : super(key: key);

  @override
  _MyAddressesState createState() => _MyAddressesState();
}

class _MyAddressesState extends State<MyAddresses> with WidgetsBindingObserver {
  var eController = TextEditingController();
  bool showLoading = false;
  bool showAddresses = false;
  late AllAddressesResponse addressResponse;
  late List<Addressess> existingAddress = [];
  OrderSummaryResponse? orderSummaryResponse;
  bool showCartSummary = false;
  var guestCustomerId;
  var apiToken;
  late AppLifecycleState applifecycleState;

  bool _willGo = true;

  RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    // context.loaderOverlay.show(
    //     widget: SpinKitRipple(
    //   color: Colors.red,
    //   size: 90,
    // ));
    super.initState();
    setState(() {
      showLoading = true;
    });
    WidgetsBinding.instance!.addObserver(this);
    getCustomerId().then((value) =>
        ApiCalls.allAddresses(ConstantsVar.apiTokken.toString(), value, context)
            .then((values) {
          print(values);
          setState(() {
            addressResponse = AllAddressesResponse.fromJson(values);
            existingAddress = addressResponse.customeraddresslist.addresses;
            print('address>>> $addressResponse');
            showAddresses = true;
            showLoading = false;
          });
        }));
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  void callApiAllAddresses() {
    ApiCalls.allAddresses(
        ConstantsVar.apiTokken.toString(), guestCustomerId, context)
        .then((value) {
      print('Resumed>>>  $value');
      setState(() {
        addressResponse = AllAddressesResponse.fromJson(value);
        existingAddress = addressResponse.customeraddresslist.addresses;
        print('address>>> $addressResponse');
        showAddresses = true;
      });
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    applifecycleState = state;
    print('mystate $applifecycleState');
    switch (state) {
      case AppLifecycleState.resumed:
        ApiCalls.allAddresses(
            ConstantsVar.apiTokken.toString(), guestCustomerId, context)
            .then((value) {
          print('Resumed>>>  $value');
          setState(() {
            addressResponse = AllAddressesResponse.fromJson(value);
            existingAddress = addressResponse.customeraddresslist.addresses;
            print('address>>> $addressResponse');
            showAddresses = true;
          });
        });
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
                        ),
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
            body: Stack(children: [
              Column(
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
                          Route route = CupertinoPageRoute(
                              builder: (context) => AddressScreen(
                                uri: 'MyAccountAddAddress',
                                isShippingAddress: false,
                                isEditAddress: false,
                                firstName: '',
                                lastName: '',
                                email: '',
                                address1: '',
                                countryName: '',
                                city: '',
                                phoneNumber: '',
                                id: 0,
                                company: '',
                                faxNumber: '',
                                title: 'Add a new address',
                                btnTitle: 'Add new address',
                              ));

                          Navigator.pushReplacement(context, route);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 50.0),
                          child: Container(
                            height: 5.h,
                            decoration: BoxDecoration(
                                color: ConstantsVar.appColor,
                                borderRadius: BorderRadius.circular(6.0)),
                            child: Center(
                              child: AutoSizeText(
                                'Add New Address',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 4.w),
                              ),
                            ),
                          ),
                        ),
                      )),

                  /************** Show Address List ******************/
                  Expanded(
                    child: Visibility(
                      visible: existingAddress.isEmpty ? false : true,
                      child: Container(
                        height: 85.h,
                        child: SmartRefresher(
                          onRefresh: _onLoading,
                          header: ClassicHeader(),
                          controller: _refreshController,
                          child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            children: List.generate(
                              existingAddress.length,
                                  (index) {
                                return Container(
                                  margin: EdgeInsets.only(
                                      left: 10.0,
                                      right: 10.0,
                                      top: 6.0,
                                      bottom: 6.0),
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
                                              // padding: const EdgeInsets.all(4.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceEvenly,
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: <Widget>[
                                                      Container(
                                                        padding:
                                                        EdgeInsets.only(
                                                            right: 8,
                                                            top: 4),
                                                        child: AutoSizeText(
                                                          existingAddress[index]
                                                              .firstName +
                                                              ' ' +
                                                              existingAddress[
                                                              index]
                                                                  .lastName,
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          softWrap: true,
                                                          style: CustomTextStyle
                                                              .textFormFieldBold
                                                              .copyWith(
                                                              fontSize: 16),
                                                        ),
                                                      ),
                                                      Container(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                            children: <Widget>[
                                                              GestureDetector(
                                                                onTap: () async {
                                                                  print(
                                                                      'edit clicked');
                                                                  //open popup
                                                                  Navigator.pushReplacement(
                                                                      context,
                                                                      CupertinoPageRoute(
                                                                          builder:
                                                                              (context) {
                                                                            return AddressScreen(
                                                                              uri:
                                                                              'EditAddress',
                                                                              isShippingAddress:
                                                                              false,
                                                                              isEditAddress:
                                                                              true,
                                                                              firstName: existingAddress[
                                                                              index]
                                                                                  .firstName,
                                                                              lastName: existingAddress[
                                                                              index]
                                                                                  .lastName,
                                                                              email: existingAddress[
                                                                              index]
                                                                                  .email,
                                                                              address1: existingAddress[
                                                                              index]
                                                                                  .address1,
                                                                              countryName:
                                                                              existingAddress[
                                                                              index]
                                                                                  .countryName,
                                                                              city: existingAddress[
                                                                              index]
                                                                                  .city,
                                                                              phoneNumber:
                                                                              existingAddress[
                                                                              index]
                                                                                  .phoneNumber,
                                                                              id: existingAddress[
                                                                              index]
                                                                                  .id,
                                                                              company: existingAddress[index]
                                                                                  .company ==
                                                                                  null
                                                                                  ? ''
                                                                                  : existingAddress[
                                                                              index]
                                                                                  .company,
                                                                              faxNumber: existingAddress[index]
                                                                                  .faxNumber ==
                                                                                  null
                                                                                  ? ''
                                                                                  : existingAddress[
                                                                              index]
                                                                                  .faxNumber,
                                                                              title:
                                                                              'Edit Address',
                                                                              btnTitle:
                                                                              'Save Address',
                                                                            );
                                                                          }));
                                                                },
                                                                child: Icon(
                                                                  Icons.edit,
                                                                  color: AppColor
                                                                      .PrimaryAccentColor,
                                                                  size: 24.0,
                                                                ),
                                                              ),
                                                              addHorizontalSpace(
                                                                  10),
                                                              GestureDetector(
                                                                onTap: () async {
                                                                  setState(() =>
                                                                  _willGo =
                                                                  false);
                                                                  print(
                                                                      'delete clicked');
                                                                  ApiCalls.deleteAddress(
                                                                      context,
                                                                      ConstantsVar
                                                                          .apiTokken
                                                                          .toString(),
                                                                      ConstantsVar
                                                                          .prefs
                                                                          .getString(
                                                                          'userId')!,
                                                                      existingAddress[
                                                                      index]
                                                                          .id
                                                                          .toString())
                                                                      .then(
                                                                          (value) {
                                                                        _refreshController
                                                                            .requestRefresh();

                                                                        setState(() =>
                                                                        _willGo =
                                                                        true);
                                                                      });
                                                                },
                                                                child: Icon(
                                                                  Icons.delete,
                                                                  color: AppColor
                                                                      .PrimaryAccentColor,
                                                                  size: 24.0,
                                                                ),
                                                              ),
                                                            ],
                                                          )),
                                                    ],
                                                  ),
                                                  Utils.getSizedBox(null, 6),
                                                  Container(
                                                      child: AutoSizeText(
                                                          'Email - ' +
                                                              existingAddress[
                                                              index]
                                                                  .email)),
                                                  Container(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: <Widget>[
                                                        Flexible(
                                                          child: AutoSizeText(
                                                            'Address -' +
                                                                existingAddress[
                                                                index]
                                                                    .address1,
                                                            overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 15),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                      child: AutoSizeText(
                                                          'Phone -' +
                                                              ' ' +
                                                              existingAddress[
                                                              index]
                                                                  .phoneNumber)),
                                                  Container(
                                                      child: AutoSizeText(
                                                          'Country -' +
                                                              ' ' +
                                                              existingAddress[
                                                              index]
                                                                  .countryName)),
                                                  addVerticalSpace(12),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
              // Container(child: isLoading ? Loader() : Container()),
              Visibility(
                visible: showLoading,
                child: Positioned(
                  child:
                  Align(alignment: Alignment.center, child: showloader()),
                ),
              ),       Visibility(
                visible: !showLoading,
                child: Visibility(
                  visible: existingAddress.isEmpty ? true : false,
                  child: Center(
                    child: Container(
                      child: AutoSizeText(
                        'No Address found',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ])),
      ),
    );
  }

  Future getCustomerId() async {
    guestCustomerId = ConstantsVar.prefs.getString('guestCustomerID');
    return guestCustomerId;
  }

  Future<bool> _willGoBack() async {
    return _willGo;
  }

  void _onLoading() async {
    existingAddress.clear();
    ApiCalls.allAddresses(
        ConstantsVar.apiTokken.toString(), guestCustomerId, context)
        .then((value) {
      setState(() {
        addressResponse = AllAddressesResponse.fromJson(value);
        existingAddress.addAll(addressResponse.customeraddresslist.addresses);
        print('address>>> $addressResponse');
        showAddresses = true;
        _refreshController.refreshCompleted();
      });
    });
  }
}
