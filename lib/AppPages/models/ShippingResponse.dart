import 'dart:convert';

ShippingResponse addressModelFromJson(String str) =>
    ShippingResponse.fromJson(json.decode(str));

String addressModelToJson(ShippingResponse data) => json.encode(data.toJson());

class ShippingResponse {
  ShippingResponse({required this.shippingaddresses});

  ShippingAddress shippingaddresses;

  factory ShippingResponse.fromJson(Map<String, dynamic> json) =>
      ShippingResponse(
          shippingaddresses:
              ShippingAddress.fromJson(json["shippingaddresses"]));

  Map<String, dynamic> toJson() => {
        "shippingaddresses": shippingaddresses,
      };
}

class ShippingAddress {
  ShippingAddress(
      {required this.existingAddress,
      required this.shippingNewAddress,
      required this.newAddressPreSelected,
      required this.pickUpPoints});
  List<ExistingAddresses> existingAddress = [];
  ShippingNewAddress shippingNewAddress;
  bool newAddressPreSelected;
  List<PickupPoints> pickUpPoints;

  factory ShippingAddress.fromJson(Map<String, dynamic> json) =>
      ShippingAddress(
          existingAddress: List<ExistingAddresses>.from(
              json["ExistingAddresses"]
                  .map((x) => ExistingAddresses.fromJson(x))),
          shippingNewAddress:
              ShippingNewAddress.fromJson(json["ShippingNewAddress"]),
          newAddressPreSelected: json["newAddressPreSelected"],
          pickUpPoints: List<PickupPoints>.from(
              json["PickupPoints"].map((x) => PickupPoints.fromJson(x))));

  Map<String, dynamic> toJson() => {
        "ExistingAddresses": List<ExistingAddresses>.from(
            existingAddress.map((x) => x.toJson())),
        "ShippingNewAddress": shippingNewAddress.toJson(),
        "NewAddressPreselected": newAddressPreSelected
      };
}

class PickupPoints {
  PickupPoints(
      {required this.id,
      required this.name,
      required this.description,
      required this.providerSystemName,
      required this.address,
      required this.city,
      required this.stateName,
      required this.countryName,
      required this.zipPostalCode,
      required this.latitude,
      required this.longitude});
  String id;
  String name;
  String description;
  String providerSystemName;
  String address;
  String city;
  String stateName;
  String countryName;
  String zipPostalCode;
  double latitude;
  double longitude;

  factory PickupPoints.fromJson(Map<String, dynamic> json) => PickupPoints(
      id: json["Id"],
      name: json["Name"],
      description: json["Description"],
      providerSystemName: json["ProviderSystemName"],
      address: json["Address"],
      city: json["City"],
      stateName: json["StateName"],
      countryName: json["CountryName"],
      zipPostalCode: json["ZipPostalCode"],
      latitude: json["Latitude"],
      longitude: json["Longitude"]);
}

class ShippingNewAddress {
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

  ShippingNewAddress(
      {required this.firstName,
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
      this.zipPostalCode,
      required this.phoneEnabled,
      required this.phoneRequired,
      required this.phoneNumber,
      required this.faxEnabled,
      required this.faxRequired,
      required this.faxNumber,
      required this.id});

  factory ShippingNewAddress.fromJson(Map<String, dynamic> json) =>
      ShippingNewAddress(
          firstName: json["FirstName"],
          lastName: json["LastName"],
          email: json["Email"],
          companyEnabled: json["CompanyEnabled"],
          companyRequired: json["CompanyRequired"],
          countryEnabled: json["CountryEnabled"],
          countryId: json["CountryId"],
          countryName: json["CountryName"],
          stateProvinceEnabled: json["StateProvinceEnabled"],
          cityEnabled: json["CityEnabled"],
          cityRequired: json["CityRequired"],
          city: json["City"],
          streetAddressEnabled: json["StreetAddressEnabled"],
          streetAddressRequired: json["StreetAddressRequired"],
          address1: json["Address1"],
          streetAddress2Enabled: json["StreetAddress2Enabled"],
          streetAddress2Required: json["StreetAddress2Required"],
          zipPostalCodeEnabled: json["ZipPostalCodeEnabled"],
          zipPostalCodeRequired: json["ZipPostalCodeRequired"],
          zipPostalCode: json["ZipPostalCode"],
          phoneEnabled: json["PhoneEnabled"],
          phoneRequired: json["PhoneRequired"],
          phoneNumber: json["PhoneNumber"],
          faxEnabled: json["FaxEnabled"],
          faxRequired: json["FaxRequired"],
          faxNumber: json["FaxNumber"],
          id: json["Id"]);

  Map<String, dynamic> toJson() => {
        // final Map<String, dynamic> data = new Map<String, dynamic>();
        "FirstName": firstName,
        "LastName": lastName,
        "Email": email,
        "CompanyEnabled": companyEnabled,
        "CompanyRequired": companyRequired,
        "CountryEnabled": countryEnabled,
        "CountryId": countryId,
        "CountryName": countryName,
        "StateProvinceEnabled": stateProvinceEnabled,
        "CityEnabled": cityEnabled,
        "CityRequired": cityRequired,
        "City": city,
        "StreetAddressEnabled": streetAddressEnabled,
        "StreetAddressRequired": streetAddressRequired,
        "Address1": address1,
        "StreetAddress2Enabled": streetAddress2Enabled,
        "StreetAddress2Required": streetAddress2Required,
        "ZipPostalCodeEnabled": zipPostalCodeEnabled,
        "ZipPostalCodeRequired": zipPostalCodeRequired,
        "PhoneEnabled": phoneEnabled,
        "PhoneRequired": phoneRequired,
        "PhoneNumber": phoneNumber,
        "FaxEnabled": faxEnabled,
        "FaxRequired": faxRequired,
        "FaxNumber": faxNumber,
        "Id": id
      };
}

class ExistingAddresses {
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

  ExistingAddresses(
      {required this.firstName,
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
      this.zipPostalCode,
      required this.phoneEnabled,
      required this.phoneRequired,
      required this.phoneNumber,
      required this.faxEnabled,
      required this.faxRequired,
      required this.faxNumber,
      required this.id});

  factory ExistingAddresses.fromJson(Map<String, dynamic> json) =>
      ExistingAddresses(
          firstName: json["FirstName"],
          lastName: json["LastName"],
          email: json["Email"],
          companyEnabled: json["CompanyEnabled"],
          companyRequired: json["CompanyRequired"],
          countryEnabled: json["CountryEnabled"],
          countryId: json["CountryId"],
          countryName: json["CountryName"],
          stateProvinceEnabled: json["StateProvinceEnabled"],
          cityEnabled: json["CityEnabled"],
          cityRequired: json["CityRequired"],
          city: json["City"],
          streetAddressEnabled: json["StreetAddressEnabled"],
          streetAddressRequired: json["StreetAddressRequired"],
          address1: json["Address1"],
          streetAddress2Enabled: json["StreetAddress2Enabled"],
          streetAddress2Required: json["StreetAddress2Required"],
          zipPostalCodeEnabled: json["ZipPostalCodeEnabled"],
          zipPostalCodeRequired: json["ZipPostalCodeRequired"],
          zipPostalCode: json["ZipPostalCode"],
          phoneEnabled: json["PhoneEnabled"],
          phoneRequired: json["PhoneRequired"],
          phoneNumber: json["PhoneNumber"],
          faxEnabled: json["FaxEnabled"],
          faxRequired: json["FaxRequired"],
          faxNumber: json["FaxNumber"],
          id: json["Id"]);

  Map<String, dynamic> toJson() => {
        // final Map<String, dynamic> data = new Map<String, dynamic>();
        "FirstName": firstName,
        "LastName": lastName,
        "Email": email,
        "CompanyEnabled": companyEnabled,
        "CompanyRequired": companyRequired,
        "CountryEnabled": countryEnabled,
        "CountryId": countryId,
        "CountryName": countryName,
        "StateProvinceEnabled": stateProvinceEnabled,
        "CityEnabled": cityEnabled,
        "CityRequired": cityRequired,
        "City": city,
        "StreetAddressEnabled": streetAddressEnabled,
        "StreetAddressRequired": streetAddressRequired,
        "Address1": address1,
        "StreetAddress2Enabled": streetAddress2Enabled,
        "StreetAddress2Required": streetAddress2Required,
        "ZipPostalCodeEnabled": zipPostalCodeEnabled,
        "ZipPostalCodeRequired": zipPostalCodeRequired,
        "PhoneEnabled": phoneEnabled,
        "PhoneRequired": phoneRequired,
        "PhoneNumber": phoneNumber,
        "FaxEnabled": faxEnabled,
        "FaxRequired": faxRequired,
        "FaxNumber": faxNumber,
        "Id": id

        // return data;
      };
}
