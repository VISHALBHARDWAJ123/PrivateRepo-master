// To parse this JSON data, do
//
//     final searchResponse = searchResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

SearchResponse searchResponseFromJson(String str) => SearchResponse.fromJson(json.decode(str));

String searchResponseToJson(SearchResponse data) => json.encode(data.toJson());

class SearchResponse {
  SearchResponse({
    required this.totalproducts,
    required this.products,
    required this.error,
  });

  int totalproducts;
  List<Product> products;
  dynamic error;

  factory SearchResponse.fromJson(Map<String, dynamic> json) => SearchResponse(
    totalproducts: json["totalproducts"],
    products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {
    "totalproducts": totalproducts,
    "products": List<dynamic>.from(products.map((x) => x.toJson())),
    "error": error,
  };
}

class Product {
  Product({
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
  dynamic discountedPrice;
  dynamic discountPercent;
  int priceValue;
  bool isDisable;
  bool isAvailable;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["Id"],
    name: json["Name"],
    stockQuantity: json["StockQuantity"],
    productPicture: json["ProductPicture"],
    price: json["Price"],
    discountedPrice: json["DiscountedPrice"],
    discountPercent: json["DiscountPercent"],
    priceValue: json["PriceValue"],
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
