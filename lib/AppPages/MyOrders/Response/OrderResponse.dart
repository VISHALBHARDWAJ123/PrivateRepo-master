// To parse this JSON data, do
//
//     final myOrderResponse = myOrderResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

MyOrderResponse myOrderResponseFromJson(String str) =>
    MyOrderResponse.fromJson(json.decode(str));

String myOrderResponseToJson(MyOrderResponse data) =>
    json.encode(data.toJson());

class MyOrderResponse {
  MyOrderResponse({
    required this.customerorders,
    required this.error,
  });

  Customerorders customerorders;
  dynamic error;

  factory MyOrderResponse.fromJson(Map<String, dynamic> json) =>
      MyOrderResponse(
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

  factory Customerorders.fromJson(Map<String, dynamic> json) => Customerorders(
        orders: List<Order>.from(json["Orders"].map((x) => Order.fromJson(x))),
        recurringOrders:
            List<dynamic>.from(json["RecurringOrders"].map((x) => x)),
        recurringPaymentErrors:
            List<dynamic>.from(json["RecurringPaymentErrors"].map((x) => x)),
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "Orders": List<dynamic>.from(orders.map((x) => x.toJson())),
        "RecurringOrders": List<dynamic>.from(recurringOrders.map((x) => x)),
        "RecurringPaymentErrors":
            List<dynamic>.from(recurringPaymentErrors.map((x) => x)),
        "CustomProperties": customProperties.toJson(),
      };
}

class CustomProperties {
  CustomProperties();

  factory CustomProperties.fromJson(Map<String, dynamic> json) =>
      CustomProperties();

  Map<String, dynamic> toJson() => {};
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
  OrderStatus? orderStatus;
  PaymentStatus? paymentStatus;
  ShippingStatus? shippingStatus;
  DateTime createdOn;
  int id;
  CustomProperties customProperties;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        customOrderNumber: json["CustomOrderNumber"],
        orderTotal: json["OrderTotal"],
        isReturnRequestAllowed: json["IsReturnRequestAllowed"],
        orderStatusEnum: json["OrderStatusEnum"],
        orderStatus: orderStatusValues.map[json["OrderStatus"]],
        paymentStatus: paymentStatusValues.map[json["PaymentStatus"]],
        shippingStatus: shippingStatusValues.map[json["ShippingStatus"]],
        createdOn: DateTime.parse(json["CreatedOn"]),
        id: json["Id"],
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "CustomOrderNumber": customOrderNumber,
        "OrderTotal": orderTotal,
        "IsReturnRequestAllowed": isReturnRequestAllowed,
        "OrderStatusEnum": orderStatusEnum,
        "OrderStatus": orderStatusValues.reverse[orderStatus],
        "PaymentStatus": paymentStatusValues.reverse[paymentStatus],
        "ShippingStatus": shippingStatusValues.reverse[shippingStatus],
        "CreatedOn": createdOn.toIso8601String(),
        "Id": id,
        "CustomProperties": customProperties.toJson(),
      };
}

enum OrderStatus { PROCESSING, PENDING }

final orderStatusValues = EnumValues(
    {"Pending": OrderStatus.PENDING, "Processing": OrderStatus.PROCESSING});

enum PaymentStatus { PAID, PENDING }

final paymentStatusValues =
    EnumValues({"Paid": PaymentStatus.PAID, "Pending": PaymentStatus.PENDING});

enum ShippingStatus { NOT_YET_SHIPPED }

final shippingStatusValues =
    EnumValues({"Not yet shipped": ShippingStatus.NOT_YET_SHIPPED});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap = {};

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
