// To parse this JSON data, do
//
//     final searchSuggestionResponse = searchSuggestionResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

SearchSuggestionResponse searchSuggestionResponseFromJson(String str) => SearchSuggestionResponse.fromJson(json.decode(str));

String searchSuggestionResponseToJson(SearchSuggestionResponse data) => json.encode(data.toJson());

class SearchSuggestionResponse {
  SearchSuggestionResponse({
    required this.status,
    required this.message,
    required this.responseData,
  });

  String status;
  dynamic message;
  List<ResponseDatum> responseData;

  factory SearchSuggestionResponse.fromJson(Map<String, dynamic> json) => SearchSuggestionResponse(
    status: json["Status"],
    message: json["Message"],
    responseData: List<ResponseDatum>.from(json["ResponseData"].map((x) => ResponseDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Status": status,
    "Message": message,
    "ResponseData": List<dynamic>.from(responseData.map((x) => x.toJson())),
  };
}

class ResponseDatum {
  ResponseDatum({
    required this.name,
    required this.totalProducts,
    required this.priority,
    required this.id,
  });

  String name;
  int totalProducts;
  int priority;
  int id;

  factory ResponseDatum.fromJson(Map<String, dynamic> json) => ResponseDatum(
    name: json["Name"],
    totalProducts: json["TotalProducts"],
    priority: json["Priority"],
    id: json["Id"],
  );

  Map<String, dynamic> toJson() => {
    "Name": name,
    "TotalProducts": totalProducts,
    "Priority": priority,
    "Id": id,
  };
}
