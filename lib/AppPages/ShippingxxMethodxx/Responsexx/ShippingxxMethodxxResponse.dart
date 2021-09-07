// To parse this JSON data, do
//
//     final shippingMethodResponse = shippingMethodResponseFromJson(jsonString);

import 'dart:convert';

ShippingMethodResponse shippingMethodResponseFromJson(String str) =>
    ShippingMethodResponse.fromJson(json.decode(str));

String shippingMethodResponseToJson(ShippingMethodResponse data) =>
    json.encode(data.toJson());

class ShippingMethodResponse {
  ShippingMethodResponse({
    required this.shippingmethods,
    required this.error,
  });

  Shippingmethods shippingmethods;
  dynamic error;

  factory ShippingMethodResponse.fromJson(Map<String, dynamic> json) =>
      ShippingMethodResponse(
        shippingmethods: Shippingmethods.fromJson(json["shippingmethods"]),
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "shippingmethods": shippingmethods.toJson(),
        "error": error,
      };
}

class Shippingmethods {
  Shippingmethods({
    required this.shippingMethods,
    required this.notifyCustomerAboutShippingFromMultipleLocations,
    required this.warnings,
    required this.customProperties,
  });

  List<MethodList> shippingMethods;
  bool notifyCustomerAboutShippingFromMultipleLocations;
  List<dynamic> warnings;
  CustomProperties customProperties;

  factory Shippingmethods.fromJson(Map<String, dynamic> json) =>
      Shippingmethods(
        shippingMethods: List<MethodList>.from(
            json["ShippingMethods"].map((x) => MethodList.fromJson(x))),
        notifyCustomerAboutShippingFromMultipleLocations:
            json["NotifyCustomerAboutShippingFromMultipleLocations"],
        warnings: List<dynamic>.from(json["Warnings"].map((x) => x)),
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "ShippingMethods":
            List<dynamic>.from(shippingMethods.map((x) => x.toJson())),
        "NotifyCustomerAboutShippingFromMultipleLocations":
            notifyCustomerAboutShippingFromMultipleLocations,
        "Warnings": List<dynamic>.from(warnings.map((x) => x)),
        "CustomProperties": customProperties.toJson(),
      };
}

class CustomProperties {
  CustomProperties();

  factory CustomProperties.fromJson(Map<String, dynamic> json) =>
      CustomProperties();

  Map<String, dynamic> toJson() => {};
}

class MethodList {
  MethodList({
    required this.shippingRateComputationMethodSystemName,
    required this.name,
    required this.description,
    required this.fee,
    required this.selected,
    required this.shippingOption,
    required this.customProperties,
  });

  String shippingRateComputationMethodSystemName;
  String name;
  String description;
  String fee;
  bool selected;
  String shippingOption;
  CustomProperties customProperties;

  factory MethodList.fromJson(Map<String, dynamic> json) => MethodList(
        shippingRateComputationMethodSystemName:
            json["ShippingRateComputationMethodSystemName"],
        name: json["Name"],
        description: json["Description"],
        fee: json["Fee"],
        selected: json["Selected"],
        shippingOption: json["ShippingOption"],
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "ShippingRateComputationMethodSystemName":
            shippingRateComputationMethodSystemName,
        "Name": name,
        "Description": description,
        "Fee": fee,
        "Selected": selected,
        "ShippingOption": shippingOption,
        "CustomProperties": customProperties.toJson(),
      };
}
