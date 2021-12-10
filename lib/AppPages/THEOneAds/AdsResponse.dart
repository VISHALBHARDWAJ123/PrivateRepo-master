// To parse this JSON data, do
//
//     final adsResponse = adsResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

AdsResponse adsResponseFromJson(String str) =>
    AdsResponse.fromJson(json.decode(str));

String adsResponseToJson(AdsResponse data) => json.encode(data.toJson());

class AdsResponse {
  AdsResponse({
    required this.status,
    required this.message,
    required this.active,
    required this.responseData,
  });

  String status;
  dynamic message;
  bool active;
  String responseData;

  factory AdsResponse.fromJson(Map<String, dynamic> json) => AdsResponse(
        status: json["Status"],
        message: json["Message"],
        active: json["Active"],
        responseData: json["ResponseData"] == null
            ? 'No Data Available'
            : json["ResponseData"],
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Message": message,
        "Active": active,
        "ResponseData": responseData,
      };
}
