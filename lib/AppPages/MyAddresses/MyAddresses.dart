import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/MyAddresses/MyAddressItem.dart';
import 'package:untitled2/AppPages/ShippingxxxScreen/AddressForm.dart';
import 'package:untitled2/AppPages/models/AddressResponse.dart';
import 'package:untitled2/AppPages/models/OrderSummaryResponse.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
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
  late AppLifecycleState applifecycleState;

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
            .then((value) {
          print(value);
          setState(() {
            addressResponse = AddressResponse.fromJson(value);
            existingAddress =
                addressResponse.billingaddresses.existingAddresses;
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
        addressResponse = AddressResponse.fromJson(value);
        existingAddress = addressResponse.billingaddresses.existingAddresses;
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
            addressResponse = AddressResponse.fromJson(value);
            existingAddress =
                addressResponse.billingaddresses.existingAddresses;
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

  // FutureOr refreshPage(dynamic value) {
  //   print('refresd');
  //   setState(() {
  //     ApiCalls.allAddresses(
  //             ConstantsVar.apiTokken.toString(), guestCustomerId, context)
  //         .then((value) {
  //       print('refresh>>>  $value');
  //       setState(() {
  //         addressResponse = AddressResponse.fromJson(value);
  //         existingAddress = addressResponse.billingaddresses.existingAddresses;
  //         print('refreshaddress>>> $addressResponse');
  //         showAddresses = true;
  //       });
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
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
          body: Stack(children: [
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
                                countryName: existingAddress[index].countryName,
                                stateProvinceEnabled:
                                    existingAddress[index].stateProvinceEnabled,
                                cityEnabled: existingAddress[index].cityEnabled,
                                cityRequired:
                                    existingAddress[index].cityRequired,
                                company: existingAddress[index].companyName,
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
                                callback: () {
                                  //call api for all addresses
                                  callApiAllAddresses();
                                },
                                guestId: guestCustomerId,
                                // isLoading: isLoading,
                              )),
                    ),
                  ),
                ],
              ),
            ),
            // Container(child: isLoading ? Loader() : Container()),
            Visibility(
              visible: showLoading,
              child: Positioned(
                child: Align(alignment: Alignment.center, child: showloader()),
              ),
            ),
          ])),
    );
  }

  Future getCustomerId() async {
    guestCustomerId = ConstantsVar.prefs.getString('guestCustomerID');
    return guestCustomerId;
  }
}
