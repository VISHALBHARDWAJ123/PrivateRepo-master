// To parse this JSON data, do
//
//     final myOrderResponse = myOrderResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class MyOrderResponse {
  MyOrderResponse({
    required this.customerorders,
    required this.error,
  });

  Customerorders customerorders;
  dynamic error;

  factory MyOrderResponse.fromRawJson(String str) => MyOrderResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MyOrderResponse.fromJson(Map<String, dynamic> json) => MyOrderResponse(
    customerorders: Customerorders.fromJson(json["customerorders"]),
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {
    "customerorders": customerorders.toJson(),
    "error": error,
  };
}

class Customerorders {
  Customerorders({
    required this.orders,
    required this.recurringOrders,
    required this.recurringPaymentErrors,
    required this.customProperties,
  });

  List<Order> orders;
  List<dynamic> recurringOrders;
  List<dynamic> recurringPaymentErrors;
  CustomProperties customProperties;

  factory Customerorders.fromRawJson(String str) => Customerorders.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Customerorders.fromJson(Map<String, dynamic> json) => Customerorders(
    orders: List<Order>.from(json["Orders"].map((x) => Order.fromJson(x))),
    recurringOrders: List<dynamic>.from(json["RecurringOrders"].map((x) => x)),
    recurringPaymentErrors: List<dynamic>.from(json["RecurringPaymentErrors"].map((x) => x)),
    customProperties: CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "Orders": List<Order>.from(orders.map((x) => x.toJson())),
    "RecurringOrders": List<dynamic>.from(recurringOrders.map((x) => x)),
    "RecurringPaymentErrors": List<dynamic>.from(recurringPaymentErrors.map((x) => x)),
    "CustomProperties": customProperties.toJson(),
  };
}

class CustomProperties {
  CustomProperties();

  factory CustomProperties.fromRawJson(String str) => CustomProperties.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CustomProperties.fromJson(Map<String, dynamic> json) => CustomProperties(
  );

  Map<String, dynamic> toJson() => {
  };
}

class Order {
  Order({
    required this.customOrderNumber,
    required this.orderTotal,
    required this.isReturnRequestAllowed,
    required this.orderStatusEnum,
    required this.orderStatus,
    required this.paymentStatus,
    required this.shippingStatus,
    required this.createdOn,
    required this.id,
    required this.customProperties,
  });

  String customOrderNumber;
  String orderTotal;
  bool isReturnRequestAllowed;
  int orderStatusEnum;
  String orderStatus;
  String paymentStatus;
  String shippingStatus;
  DateTime createdOn;
  int id;
  CustomProperties customProperties;

  factory Order.fromRawJson(String str) => Order.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    customOrderNumber: json["CustomOrderNumber"],
    orderTotal: json["OrderTotal"],
    isReturnRequestAllowed: json["IsReturnRequestAllowed"],
    orderStatusEnum: json["OrderStatusEnum"],
    orderStatus: json["OrderStatus"],
    paymentStatus: json["PaymentStatus"],
    shippingStatus: json["ShippingStatus"],
    createdOn: DateTime.parse(json["CreatedOn"]),
    id: json["Id"],
    customProperties: CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "CustomOrderNumber": customOrderNumber,
    "OrderTotal": orderTotal,
    "IsReturnRequestAllowed": isReturnRequestAllowed,
    "OrderStatusEnum": orderStatusEnum,
    "OrderStatus": orderStatus,
    "PaymentStatus": paymentStatus,
    "ShippingStatus": shippingStatus,
    "CreatedOn": createdOn.toIso8601String(),
    "Id": id,
    "CustomProperties": customProperties.toJson(),
  };
}





class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap={};

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
