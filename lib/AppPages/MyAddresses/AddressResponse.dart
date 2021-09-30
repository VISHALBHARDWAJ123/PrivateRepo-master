// To parse this JSON data, do
//
//     final allAddressesResponse = allAddressesResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

AllAddressesResponse allAddressesResponseFromJson(String str) => AllAddressesResponse.fromJson(json.decode(str));

String allAddressesResponseToJson(AllAddressesResponse data) => json.encode(data.toJson());

class AllAddressesResponse {
  AllAddressesResponse({
    required this.customeraddresslist,
    required this.error,
  });

  Customeraddresslist customeraddresslist;
  dynamic error;

  factory AllAddressesResponse.fromJson(Map<String, dynamic> json) => AllAddressesResponse(
    customeraddresslist: Customeraddresslist.fromJson(json["customeraddresslist"]),
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {
    "customeraddresslist": customeraddresslist.toJson(),
    "error": error,
  };
}

class Customeraddresslist {
  Customeraddresslist({
    required this.addresses,
    required this.customProperties,
  });

  List<Addressess> addresses;
  CustomProperties customProperties;

  factory Customeraddresslist.fromJson(Map<String, dynamic> json) => Customeraddresslist(
    addresses: List<Addressess>.from(json["Addresses"].map((x) => Addressess.fromJson(x))),
    customProperties: CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "Addresses": List<dynamic>.from(addresses.map((x) => x.toJson())),
    "CustomProperties": customProperties.toJson(),
  };
}

class Addressess {
  Addressess({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.companyEnabled,
    required this.companyRequired,
    required this.company,
    required this.countryEnabled,
    required this.countryId,
    required this.countryName,
    required this.stateProvinceEnabled,
    required this.stateProvinceId,
    required this.stateProvinceName,
    required this.cityEnabled,
    required this.cityRequired,
    required this.city,
    required this.streetAddressEnabled,
    required this.streetAddressRequired,
    required this.address1,
    required this.streetAddress2Enabled,
    required this.streetAddress2Required,
    required this.address2,
    required this.zipPostalCodeEnabled,
    required this.zipPostalCodeRequired,
    required this.zipPostalCode,
    required this.phoneEnabled,
    required this.phoneRequired,
    required this.phoneNumber,
    required this.faxEnabled,
    required this.faxRequired,
    required this.faxNumber,
    required this.availableCountries,
    required this.availableStates,
    required this.formattedCustomAddressAttributes,
    required this.customAddressAttributes,
    required this.id,
    required this.customProperties,
  });

  String firstName;
  String lastName;
  String email;
  bool companyEnabled;
  bool companyRequired;
  String company;
  bool countryEnabled;
  int countryId;
  String countryName;
  bool stateProvinceEnabled;
  dynamic stateProvinceId;
  dynamic stateProvinceName;
  bool cityEnabled;
  bool cityRequired;
  String city;
  bool streetAddressEnabled;
  bool streetAddressRequired;
  String address1;
  bool streetAddress2Enabled;
  bool streetAddress2Required;
  String address2;
  bool zipPostalCodeEnabled;
  bool zipPostalCodeRequired;
  String zipPostalCode;
  bool phoneEnabled;
  bool phoneRequired;
  String phoneNumber;
  bool faxEnabled;
  bool faxRequired;
  String faxNumber;
  List<Available> availableCountries;
  List<Available> availableStates;
  String formattedCustomAddressAttributes;
  List<dynamic> customAddressAttributes;
  int id;
  CustomProperties customProperties;

  factory Addressess.fromJson(Map<String, dynamic> json) => Addressess(
    firstName: json["FirstName"],
    lastName: json["LastName"],
    email: json["Email"],
    companyEnabled: json["CompanyEnabled"],
    companyRequired: json["CompanyRequired"],
    company: json["Company"],
    countryEnabled: json["CountryEnabled"],
    countryId: json["CountryId"],
    countryName: json["CountryName"],
    stateProvinceEnabled: json["StateProvinceEnabled"],
    stateProvinceId: json["StateProvinceId"],
    stateProvinceName: json["StateProvinceName"],
    cityEnabled: json["CityEnabled"],
    cityRequired: json["CityRequired"],
    city: json["City"],
    streetAddressEnabled: json["StreetAddressEnabled"],
    streetAddressRequired: json["StreetAddressRequired"],
    address1: json["Address1"],
    streetAddress2Enabled: json["StreetAddress2Enabled"],
    streetAddress2Required: json["StreetAddress2Required"],
    address2: json["Address2"],
    zipPostalCodeEnabled: json["ZipPostalCodeEnabled"],
    zipPostalCodeRequired: json["ZipPostalCodeRequired"],
    zipPostalCode: json["ZipPostalCode"],
    phoneEnabled: json["PhoneEnabled"],
    phoneRequired: json["PhoneRequired"],
    phoneNumber: json["PhoneNumber"],
    faxEnabled: json["FaxEnabled"],
    faxRequired: json["FaxRequired"],
    faxNumber: json["FaxNumber"],
    availableCountries: List<Available>.from(json["AvailableCountries"].map((x) => Available.fromJson(x))),
    availableStates: List<Available>.from(json["AvailableStates"].map((x) => Available.fromJson(x))),
    formattedCustomAddressAttributes: json["FormattedCustomAddressAttributes"],
    customAddressAttributes: List<dynamic>.from(json["CustomAddressAttributes"].map((x) => x)),
    id: json["Id"],
    customProperties: CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "FirstName": firstName,
    "LastName": lastName,
    "Email": email,
    "CompanyEnabled": companyEnabled,
    "CompanyRequired": companyRequired,
    "Company": company,
    "CountryEnabled": countryEnabled,
    "CountryId": countryId,
    "CountryName": countryName,
    "StateProvinceEnabled": stateProvinceEnabled,
    "StateProvinceId": stateProvinceId,
    "StateProvinceName": stateProvinceName,
    "CityEnabled": cityEnabled,
    "CityRequired": cityRequired,
    "City": city,
    "StreetAddressEnabled": streetAddressEnabled,
    "StreetAddressRequired": streetAddressRequired,
    "Address1": address1,
    "StreetAddress2Enabled": streetAddress2Enabled,
    "StreetAddress2Required": streetAddress2Required,
    "Address2": address2,
    "ZipPostalCodeEnabled": zipPostalCodeEnabled,
    "ZipPostalCodeRequired": zipPostalCodeRequired,
    "ZipPostalCode": zipPostalCode,
    "PhoneEnabled": phoneEnabled,
    "PhoneRequired": phoneRequired,
    "PhoneNumber": phoneNumber,
    "FaxEnabled": faxEnabled,
    "FaxRequired": faxRequired,
    "FaxNumber": faxNumber,
    "AvailableCountries": List<dynamic>.from(availableCountries.map((x) => x.toJson())),
    "AvailableStates": List<dynamic>.from(availableStates.map((x) => x.toJson())),
    "FormattedCustomAddressAttributes": formattedCustomAddressAttributes,
    "CustomAddressAttributes": List<dynamic>.from(customAddressAttributes.map((x) => x)),
    "Id": id,
    "CustomProperties": customProperties.toJson(),
  };
}

class Available {
  Available({
    required this.disabled,
    required this.group,
    required this.selected,
    required this.text,
    required this.value,
  });

  bool disabled;
  dynamic group;
  bool selected;
  String text;
  String value;

  factory Available.fromJson(Map<String, dynamic> json) => Available(
    disabled: json["Disabled"],
    group: json["Group"],
    selected: json["Selected"],
    text: json["Text"],
    value: json["Value"],
  );

  Map<String, dynamic> toJson() => {
    "Disabled": disabled,
    "Group": group,
    "Selected": selected,
    "Text": text,
    "Value": value,
  };
}

class CustomProperties {
  CustomProperties();

  factory CustomProperties.fromJson(Map<String, dynamic> json) => CustomProperties(
  );

  Map<String, dynamic> toJson() => {
  };
}
