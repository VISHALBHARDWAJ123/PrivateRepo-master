// To parse this JSON data, do
//
//     final searchResponse = searchResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

SearchResponse searchResponseFromJson(String str) =>
    SearchResponse.fromJson(json.decode(str));

String searchResponseToJson(SearchResponse data) => json.encode(data.toJson());

class SearchResponse {
  SearchResponse({
    required this.status,
    required this.message,
    required this.responseData,
  });

  String status;
  dynamic message;
  ResponseData responseData;

  factory SearchResponse.fromJson(Map<String, dynamic> json) => SearchResponse(
        status: json["Status"],
        message: json["Message"],
        responseData: ResponseData.fromJson(json["ResponseData"]),
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Message": message,
        "ResponseData": responseData.toJson(),
      };
}

class ResponseData {
  ResponseData({
    required this.getProductsByCategoryIdClasses,
    required this.specificationAttributeFilters,
    required this.sorting,
    required this.totalCount,
    required this.priceRange,
  });

  List<GetProductsByCategoryIdClass> getProductsByCategoryIdClasses;
  List<SpecificationAttributeFilter> specificationAttributeFilters;
  List<Sorting> sorting;
  int totalCount;
  PriceRange priceRange;
  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
        getProductsByCategoryIdClasses: List<GetProductsByCategoryIdClass>.from(
            json["getProductsByCategoryIdClasses"]
                .map((x) => GetProductsByCategoryIdClass.fromJson(x))),
        specificationAttributeFilters: List<SpecificationAttributeFilter>.from(
            json["specificationAttributeFilters"]
                .map((x) => SpecificationAttributeFilter.fromJson(x))),
        sorting:
            List<Sorting>.from(json["sorting"].map((x) => Sorting.fromJson(x))),
        totalCount: json["TotalCount"],
    priceRange: PriceRange.fromJson(json["priceRange"]),      );


  Map<String, dynamic> toJson() => {
        "getProductsByCategoryIdClasses": List<dynamic>.from(
            getProductsByCategoryIdClasses.map((x) => x.toJson())),
        "specificationAttributeFilters": List<dynamic>.from(
            specificationAttributeFilters.map((x) => x.toJson())),
        "sorting": List<dynamic>.from(sorting.map((x) => x.toJson())),
        "TotalCount": totalCount,
      };
}

class GetProductsByCategoryIdClass {
  GetProductsByCategoryIdClass({
    required this.id,
    required this.name,
    required this.stockQuantity,
    required this.productPicture,
    required this.price,
    required this.discountedPrice,
    required this.discountPercent,
    required this.priceValue,
    required this.isDisable,
    required this.isAvailable,
  });

  int id;
  String name;
  String stockQuantity;
  String productPicture;
  String price;
  String discountedPrice;
  String discountPercent;
  double priceValue;
  bool isDisable;
  bool isAvailable;

  factory GetProductsByCategoryIdClass.fromJson(Map<String, dynamic> json) =>
      GetProductsByCategoryIdClass(
        id: json["Id"],
        name: json["Name"],
        stockQuantity: json["StockQuantity"],
        productPicture: json["ProductPicture"],
        price: json["Price"],
        discountedPrice:
            json["DiscountedPrice"] == null ? '' : json["DiscountPrice"],
        discountPercent:
            json["DiscountPercent"] == null ? '' : json["DiscountPercent"],
        priceValue: json["PriceValue"].toDouble(),
        isDisable: json["IsDisable"],
        isAvailable: json["IsAvailable"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Name": name,
        "StockQuantity": stockQuantity,
        "ProductPicture": productPicture,
        "Price": price,
        "DiscountedPrice": discountedPrice,
        "DiscountPercent": discountPercent,
        "PriceValue": priceValue,
        "IsDisable": isDisable,
        "IsAvailable": isAvailable,
      };
}

class Sorting {
  Sorting({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory Sorting.fromJson(Map<String, dynamic> json) => Sorting(
        id: json["Id"],
        name: json["Name"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Name": name,
      };
}

class SpecificationAttributeFilter {
  SpecificationAttributeFilter({
    required this.id,
    required this.name,
    required this.specificationoptions,
  });

  int id;
  String name;
  List<Specificationoption> specificationoptions;

  factory SpecificationAttributeFilter.fromJson(Map<String, dynamic> json) =>
      SpecificationAttributeFilter(
        id: json["id"],
        name: json["name"],
        specificationoptions: List<Specificationoption>.from(
            json["specificationoptions"]
                .map((x) => Specificationoption.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "specificationoptions":
            List<dynamic>.from(specificationoptions.map((x) => x.toJson())),
      };
}

class Specificationoption {
  Specificationoption({
    required this.id,
    required this.name,
  });

  String id;
  String name;

  factory Specificationoption.fromJson(Map<String, dynamic> json) =>
      Specificationoption(
        id: json["id"].toString() == null ? '' : json["id"].toString(),
        name: json["name"] == null ? '' : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
class PriceRange {
  PriceRange({
    required this.minPrice,
    required this.maxPrice,
  });

  double minPrice;
  double maxPrice;

  factory PriceRange.fromJson(Map<String, dynamic> json) => PriceRange(
    minPrice: json["minPrice"].toDouble(),
    maxPrice: json["maxPrice"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "minPrice": minPrice,
    "maxPrice": maxPrice,
  };
}
