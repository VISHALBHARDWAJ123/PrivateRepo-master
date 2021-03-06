// To parse this JSON data, do
//
//     final recentlyViewProductResponse = recentlyViewProductResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

RecentlyViewProductResponse recentlyViewProductResponseFromJson(String str) => RecentlyViewProductResponse.fromJson(json.decode(str));

String recentlyViewProductResponseToJson(RecentlyViewProductResponse data) => json.encode(data.toJson());

class RecentlyViewProductResponse {
  RecentlyViewProductResponse({
    required this.products,
    required this.status,
    required this.message,
  });

  List<Product> products;
  String status;
  String message;

  factory RecentlyViewProductResponse.fromJson(Map<String, dynamic> json) => RecentlyViewProductResponse(
    products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "products": List<dynamic>.from(products.map((x) => x.toJson())),
    "status": status,
    "message": message,
  };
}

class Product {
  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.discountPercent,
  });

  int id;
  String name;
  List<String> imageUrl;
  String price;
  dynamic discountPercent;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["Id"],
    name: json["Name"],
    imageUrl: List<String>.from(json["ImageUrl"].map((x) => x)),
    price: json["price"],
    discountPercent: json["DiscountPercent"],
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "Name": name,
    "ImageUrl": List<dynamic>.from(imageUrl.map((x) => x)),
    "price": price,
    "DiscountPercent": discountPercent,
  };
}
