import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:ndialog/ndialog.dart';
import 'package:progress_loading_button/progress_loading_button.dart';
import 'package:untitled2/AppPages/ShippingxxMethodxx/ShippingxxMethodxx.dart';
import 'package:untitled2/AppPages/ShippingxxxScreen/BillingxxScreen/SelectBillingAddressModel/SelectBillAdd.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/Widgets/CustomButton.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';
import 'package:untitled2/utils/utils/build_config.dart';
import 'package:untitled2/utils/utils/general_functions.dart';

import 'BillingxxScreen/ShippingAddress.dart';

class AddressItem extends StatefulWidget {
  AddressItem(
      {Key? key,
      // required this.isLoading,
      required this.guestId,
      required this.buttonName,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.companyEnabled,
      required this.companyRequired,
      required this.countryEnabled,
      required this.countryId,
      required this.countryName,
      required this.stateProvinceEnabled,
      required this.cityEnabled,
      required this.cityRequired,
      required this.city,
      required this.streetAddressEnabled,
      required this.streetAddressRequired,
      required this.address1,
      required this.streetAddress2Enabled,
      required this.streetAddress2Required,
      required this.zipPostalCodeEnabled,
      required this.zipPostalCodeRequired,
      required this.zipPostalCode,
      required this.phoneEnabled,
      required this.phoneRequired,
      required this.phoneNumber,
      required this.faxEnabled,
      required this.faxRequired,
      required this.faxNumber,
      required this.id,
      required this.callback})
      : super(key: key);

  String buttonName;
  String firstName;
  String lastName;
  String email;
  bool companyEnabled;
  bool companyRequired;
  bool countryEnabled;
  int countryId;
  String countryName;
  bool stateProvinceEnabled;
  bool cityEnabled;
  bool cityRequired;
  String city;
  bool streetAddressEnabled;
  bool streetAddressRequired;
  String address1;
  bool streetAddress2Enabled;
  bool streetAddress2Required;
  bool zipPostalCodeEnabled;
  bool zipPostalCodeRequired;
  dynamic zipPostalCode;
  bool phoneEnabled;
  bool phoneRequired;
  String phoneNumber;
  bool faxEnabled;
  bool faxRequired;
  dynamic faxNumber;
  int id;
  String guestId;
  ValueChanged<String> callback;

  // var
  @override
  _AddressItemState createState() => _AddressItemState();
}

class _AddressItemState extends State<AddressItem> {
  var guestId;
  var addressJsonString;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getGuestCustomer();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Colors.white,
        child: Container(
          // height: 30.h,
          margin: EdgeInsets.only(
            left: 10,
            right: 10,
            bottom: 3.2,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(right: 8, top: 4),
                child: AutoSizeText(
                  widget.firstName + ' ' + widget.lastName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style:
                      CustomTextStyle.textFormFieldBold.copyWith(fontSize: 16),
                ),
              ),
              Utils.getSizedBox(null, 6),
              Container(child: AutoSizeText('Email - ' + widget.email)),
              Utils.getSizedBox(null, 6),
              Container(
                child: AutoSizeText(
                  'Address -' + widget.address1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 15),
                ),
              ),
              Utils.getSizedBox(null, 6),
              Container(
                  child: AutoSizeText('Phone -' + ' ' + widget.phoneNumber)),
              Utils.getSizedBox(null, 6),
              Container(
                  child: AutoSizeText('Country -' + ' ' + widget.countryName)),
              addVerticalSpace(12),
              Container(
                color: ConstantsVar.appColor,
                width: 100.w,
                child: Center(
                  child: LoadingButton(
                    width: 100.w,
                    loadingWidget: SpinKitCircle(
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () async {
                      CustomProgressDialog _dialog = CustomProgressDialog(
                        context,
                        loadingWidget: SpinKitRipple(
                          color: Colors.red,
                          size: 40,
                        ),
                        dismissable: false,
                      );
                      print('button bill clicked');
                      if (widget.buttonName.contains('Bill')) {
                        _dialog.show();
                        await ApiCalls.selectBillingAddress(
                                ConstantsVar.apiTokken.toString(),
                                '$guestId',
                                widget.id.toString())
                            .then((value) {
                          _dialog.dismiss();
                          ConstantsVar.prefs.setString('addressJsonString', '');
                          SelectBillingAddress map =
                              SelectBillingAddress.fromJson(value);
                          // String
                          if (map.error == null) {
                            //means no error..
                            _dialog.dismiss();

                            var fName =
                                map.selectedaddress.firstName.toString();
                            var lName = map.selectedaddress.lastName.toString();
                            var email = map.selectedaddress.email.toString();
                            var company =
                                map.selectedaddress.company.toString();
                            var countryId =
                                map.selectedaddress.countryId.toString();
                            var city = map.selectedaddress.city.toString();
                            var stateProvincId = 12;
                            var address1 =
                                map.selectedaddress.address1.toString();
                            var address2 =
                                map.selectedaddress.address2.toString();
                            var postalCode =
                                map.selectedaddress.zipPostalCode.toString();
                            var phoneNumner =
                                map.selectedaddress.phoneNumber.toString();
                            var faxNumber =
                                map.selectedaddress.faxNumber.toString();

                            Map<String, dynamic> addressBody = {
                              'FirstName': fName,
                              'LastName': lName,
                              'Email': email,
                              'Company': company,
                              'CountryId': countryId,
                              'StateProvinceId': stateProvincId,
                              'City': city,
                              'Address1': address1,
                              'Address2': address2,
                              'ZipPostalCode': postalCode,
                              'PhoneNumber': phoneNumner,
                              'FaxNumber': faxNumber,
                            };

                            addressJsonString = jsonEncode(addressBody);
                            ConstantsVar.prefs
                                .setString(
                                    'addressJsonString', addressJsonString)
                                .whenComplete(
                                  () => Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) {
                                        return ShippingAddress();
                                      },
                                    ),
                                  ),
                                );
                          } else {
                            _dialog.dismiss();
                            Fluttertoast.showToast(msg: map.error.toString());
                          }
                        });
                      } else {
                        //Means shipping button is clicked on shipping screen
                        _dialog.show();
                        await ApiCalls.selectShippingAddress(
                                ConstantsVar.apiTokken.toString(),
                                widget.guestId,
                                widget.id.toString())
                            .then(
                          (value) {
                            print('$value');
                            _dialog.dismiss();
                            String paymentUrl = BuildConfig.base_url +
                                'AppCustomer/CreateCustomerOrder?apiToken=${ConstantsVar.apiTokken.toString()}&CustomerId=${widget.guestId.toString()}&PaymentMethod=Payments.CyberSource';

                            Navigator.pushReplacement(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => ShippingMethod(
                                  customerId: widget.guestId,
                                  paymentUrl: paymentUrl,
                                  // paymentUrl: paymentUrl),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                    defaultWidget: AutoSizeText(
                      widget.buttonName,
                      style: TextStyle(
                          fontSize: 4.w,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    color: ConstantsVar.appColor,
                  ),
                ),
              ),
              Utils.getSizedBox(null, 6),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getGuestCustomer() async {
    guestId = ConstantsVar.prefs.getString('guestCustomerID');
  }
}
