// To parse this JSON data, do
//
//     final addToCartResponse = addToCartResponseFromJson(jsonString);

import 'dart:convert';

AddToCartResponse addToCartResponseFromJson(String str) =>
    AddToCartResponse.fromJson(json.decode(str));

String addToCartResponseToJson(AddToCartResponse data) =>
    json.encode(data.toJson());

class AddToCartResponse {
  AddToCartResponse({
    required this.warning,
    this.result,
    this.error,
  });

  List<dynamic> warning;
  String? result;
  dynamic error;

  factory AddToCartResponse.fromJson(Map<String, dynamic> json) =>
      AddToCartResponse(
        warning: json["warning"],
        result: json["result"] == null ? null : json["result"],
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "warning": warning,
        "result": result == null ? null : result,
        "error": error,
      };
}
