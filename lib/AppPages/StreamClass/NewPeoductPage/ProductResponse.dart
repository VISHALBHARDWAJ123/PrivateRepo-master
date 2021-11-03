// To parse this JSON data, do
//
//     final productResponse = productResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ProductResponse productResponseFromJson(String str) =>
    ProductResponse.fromJson(json.decode(str));

String productResponseToJson(ProductResponse data) =>
    json.encode(data.toJson());

class ProductResponse {
  ProductResponse({
    required this.defaultPictureModel,
    required this.pictureModels,
    required this.name,
    required this.shortDescription,
    required this.fullDescription,
    required this.sku,
    required this.giftCard,
    required this.stockAvailability,
    required this.emailAFriendEnabled,
    required this.compareProductsEnabled,
    required this.productPrice,
    required this.productTags,
    required this.productAttributes,
    required this.productSpecifications,
    required this.productReviewOverview,
    required this.associatedProducts,
    required this.id,
    required this.discountPercentage,
    required this.subscribedToBackInStockSubscription,
    required this.displayBackInStockSubscription,
  });

  PictureModel defaultPictureModel;
  List<PictureModel> pictureModels;
  String name;
  String shortDescription;
  String fullDescription;
  String sku;
  GiftCard giftCard;
  String stockAvailability;
  bool emailAFriendEnabled;
  bool compareProductsEnabled;
  ProductPrice productPrice;
  List<ProductTag> productTags;
  List<ProductAttribute>? productAttributes;
  List<ProductSpecification> productSpecifications;
  ProductReviewOverview productReviewOverview;
  List<dynamic> associatedProducts;
  int id;
  String discountPercentage;
  bool subscribedToBackInStockSubscription;
  bool displayBackInStockSubscription;

  factory ProductResponse.fromJson(Map<String, dynamic> json) =>
      ProductResponse(
        defaultPictureModel: PictureModel.fromJson(json["DefaultPictureModel"]),
        pictureModels: List<PictureModel>.from(
            json["PictureModels"].map((x) => PictureModel.fromJson(x))),
        name: json["Name"],
        shortDescription: json["ShortDescription"],
        fullDescription: json["FullDescription"],
        sku: json["Sku"],
        giftCard: GiftCard.fromJson(json["GiftCard"]),
        stockAvailability: json["StockAvailability"],
        emailAFriendEnabled: json["EmailAFriendEnabled"],
        compareProductsEnabled: json["CompareProductsEnabled"],
        productPrice: ProductPrice.fromJson(json["ProductPrice"]),
        productTags: List<ProductTag>.from(
            json["ProductTags"].map((x) => ProductTag.fromJson(x))),
        productAttributes: List<ProductAttribute>.from(
            json["ProductAttributes"].map((x) => ProductAttribute.fromJson(x))),
        productSpecifications: List<ProductSpecification>.from(
            json["ProductSpecifications"]
                .map((x) => ProductSpecification.fromJson(x))),
        productReviewOverview:
            ProductReviewOverview.fromJson(json["ProductReviewOverview"]),
        associatedProducts:
            List<dynamic>.from(json["AssociatedProducts"].map((x) => x)),
        id: json["id"],
        discountPercentage: json["DiscountPercentage"] == null
            ? ''
            : json["DiscountPercentage"],
        displayBackInStockSubscription: json['displayBackInStockSubscription'],
        subscribedToBackInStockSubscription:
            json['subscribedToBackInStockSubscription'],
      );

  Map<String, dynamic> toJson() => {
        "DefaultPictureModel": defaultPictureModel.toJson(),
        "PictureModels":
            List<dynamic>.from(pictureModels.map((x) => x.toJson())),
        "Name": name,
        "ShortDescription": shortDescription,
        "FullDescription": fullDescription,
        "Sku": sku,
        "GiftCard": giftCard.toJson(),
        "StockAvailability": stockAvailability,
        "EmailAFriendEnabled": emailAFriendEnabled,
        "CompareProductsEnabled": compareProductsEnabled,
        "ProductPrice": productPrice.toJson(),
        "ProductTags": List<dynamic>.from(productTags.map((x) => x.toJson())),
        "ProductAttributes":
            List<dynamic>.from(productAttributes!.map((x) => x.toJson())),
        "ProductSpecifications":
            List<dynamic>.from(productSpecifications.map((x) => x.toJson())),
        "ProductReviewOverview": productReviewOverview.toJson(),
        "AssociatedProducts":
            List<dynamic>.from(associatedProducts.map((x) => x)),
        "id": id,
        "DiscountPercentage": discountPercentage,
        "subscribedToBackInStockSubscription":
            subscribedToBackInStockSubscription,
        "displayBackInStockSubscription": displayBackInStockSubscription,
      };
}

class PictureModel {
  PictureModel({
    required this.imageUrl,
    required this.thumbImageUrl,
    required this.fullSizeImageUrl,
    required this.title,
    required this.alternateText,
    required this.customProperties,
  });

  String imageUrl;
  String thumbImageUrl;
  String fullSizeImageUrl;
  String title;
  String alternateText;
  CustomProperties customProperties;

  factory PictureModel.fromJson(Map<String, dynamic> json) => PictureModel(
        imageUrl: json["ImageUrl"] == null ? null : json["ImageUrl"],
        thumbImageUrl:
            json["ThumbImageUrl"] == null ? null : json["ThumbImageUrl"],
        fullSizeImageUrl:
            json["FullSizeImageUrl"] == null ? null : json["FullSizeImageUrl"],
        title: json["Title"] == null ? null : json["Title"],
        alternateText:
            json["AlternateText"] == null ? null : json["AlternateText"],
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "ImageUrl": imageUrl == null ? null : imageUrl,
        "ThumbImageUrl": thumbImageUrl == null ? null : thumbImageUrl,
        "FullSizeImageUrl": fullSizeImageUrl == null ? null : fullSizeImageUrl,
        "Title": title == null ? null : title,
        "AlternateText": alternateText == null ? null : alternateText,
        "CustomProperties": customProperties.toJson(),
      };
}

class CustomProperties {
  CustomProperties();

  factory CustomProperties.fromJson(Map<String, dynamic> json) =>
      CustomProperties();

  Map<String, dynamic> toJson() => {};
}

class GiftCard {
  GiftCard({
    required this.isGiftCard,
    required this.recipientName,
    required this.recipientEmail,
    required this.senderName,
    required this.senderEmail,
    required this.message,
    required this.giftCardType,
    required this.customProperties,
  });

  bool isGiftCard;
  dynamic recipientName;
  dynamic recipientEmail;
  dynamic senderName;
  dynamic senderEmail;
  dynamic message;
  int giftCardType;
  CustomProperties customProperties;

  factory GiftCard.fromJson(Map<String, dynamic> json) => GiftCard(
        isGiftCard: json["IsGiftCard"],
        recipientName: json["RecipientName"],
        recipientEmail: json["RecipientEmail"],
        senderName: json["SenderName"],
        senderEmail: json["SenderEmail"],
        message: json["Message"],
        giftCardType: json["GiftCardType"],
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "IsGiftCard": isGiftCard,
        "RecipientName": recipientName,
        "RecipientEmail": recipientEmail,
        "SenderName": senderName,
        "SenderEmail": senderEmail,
        "Message": message,
        "GiftCardType": giftCardType,
        "CustomProperties": customProperties.toJson(),
      };
}

class ProductAttribute {
  ProductAttribute({
    required this.productId,
    required this.productAttributeId,
    required this.name,
    required this.description,
    required this.textPrompt,
    required this.isRequired,
    required this.defaultValue,
    required this.selectedDay,
    required this.selectedMonth,
    required this.selectedYear,
    required this.hasCondition,
    required this.allowedFileExtensions,
    required this.attributeControlType,
    required this.values,
    required this.id,
    required this.customProperties,
  });

  int productId;
  int productAttributeId;
  String name;
  dynamic description;
  String textPrompt;
  bool isRequired;
  dynamic defaultValue;
  dynamic selectedDay;
  dynamic selectedMonth;
  dynamic selectedYear;
  bool hasCondition;
  List<dynamic> allowedFileExtensions;
  int attributeControlType;
  List<Value> values;
  int id;
  CustomProperties customProperties;

  factory ProductAttribute.fromJson(Map<String, dynamic> json) =>
      ProductAttribute(
        productId: json["ProductId"],
        productAttributeId: json["ProductAttributeId"],
        name: json["Name"],
        description: json["Description"],
        textPrompt: json["TextPrompt"],
        isRequired: json["IsRequired"],
        defaultValue: json["DefaultValue"],
        selectedDay: json["SelectedDay"],
        selectedMonth: json["SelectedMonth"],
        selectedYear: json["SelectedYear"],
        hasCondition: json["HasCondition"],
        allowedFileExtensions:
            List<dynamic>.from(json["AllowedFileExtensions"].map((x) => x)),
        attributeControlType: json["AttributeControlType"],
        values: List<Value>.from(json["Values"].map((x) => Value.fromJson(x))),
        id: json["Id"],
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "ProductId": productId,
        "ProductAttributeId": productAttributeId,
        "Name": name,
        "Description": description,
        "TextPrompt": textPrompt,
        "IsRequired": isRequired,
        "DefaultValue": defaultValue,
        "SelectedDay": selectedDay,
        "SelectedMonth": selectedMonth,
        "SelectedYear": selectedYear,
        "HasCondition": hasCondition,
        "AllowedFileExtensions":
            List<dynamic>.from(allowedFileExtensions.map((x) => x)),
        "AttributeControlType": attributeControlType,
        "Values": List<dynamic>.from(values.map((x) => x.toJson())),
        "Id": id,
        "CustomProperties": customProperties.toJson(),
      };
}

class Value {
  Value({
    required this.name,
    required this.colorSquaresRgb,
    required this.imageSquaresPictureModel,
    required this.priceAdjustment,
    required this.priceAdjustmentValue,
    required this.isPreSelected,
    required this.pictureId,
    required this.customerEntersQty,
    required this.quantity,
    required this.id,
    required this.customProperties,
  });

  String name;
  dynamic colorSquaresRgb;
  PictureModel imageSquaresPictureModel;
  String priceAdjustment;
  double priceAdjustmentValue;
  bool isPreSelected;
  int pictureId;
  bool customerEntersQty;
  int quantity;
  int id;
  CustomProperties customProperties;

  factory Value.fromJson(Map<String, dynamic> json) => Value(
        name: json["Name"],
        colorSquaresRgb: json["ColorSquaresRgb"],
        imageSquaresPictureModel:
            PictureModel.fromJson(json["ImageSquaresPictureModel"]),
        priceAdjustment: json["PriceAdjustment"],
        priceAdjustmentValue: json["PriceAdjustmentValue"],
        isPreSelected: json["IsPreSelected"],
        pictureId: json["PictureId"],
        customerEntersQty: json["CustomerEntersQty"],
        quantity: json["Quantity"],
        id: json["Id"],
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "Name": name,
        "ColorSquaresRgb": colorSquaresRgb,
        "ImageSquaresPictureModel": imageSquaresPictureModel.toJson(),
        "PriceAdjustment": priceAdjustment,
        "PriceAdjustmentValue": priceAdjustmentValue,
        "IsPreSelected": isPreSelected,
        "PictureId": pictureId,
        "CustomerEntersQty": customerEntersQty,
        "Quantity": quantity,
        "Id": id,
        "CustomProperties": customProperties.toJson(),
      };
}

class ProductPrice {
  ProductPrice({
    required this.currencyCode,
    required this.oldPrice,
    required this.price,
    required this.priceWithDiscount,
    required this.priceValue,
    required this.customerEntersPrice,
    required this.callForPrice,
    required this.productId,
    required this.hidePrices,
    required this.isRental,
    required this.rentalPrice,
    required this.displayTaxShippingInfo,
    required this.basePricePAngV,
    required this.customProperties,
  });

  String currencyCode;
  dynamic oldPrice;
  String price;
  dynamic priceWithDiscount;
  double priceValue;
  bool customerEntersPrice;
  bool callForPrice;
  int productId;
  bool hidePrices;
  bool isRental;
  dynamic rentalPrice;
  bool displayTaxShippingInfo;
  dynamic basePricePAngV;
  CustomProperties customProperties;

  factory ProductPrice.fromJson(Map<String, dynamic> json) => ProductPrice(
        currencyCode: json["CurrencyCode"],
        oldPrice: json["OldPrice"],
        price: json["Price"],
        priceWithDiscount: json["PriceWithDiscount"],
        priceValue: json["PriceValue"],
        customerEntersPrice: json["CustomerEntersPrice"],
        callForPrice: json["CallForPrice"],
        productId: json["ProductId"],
        hidePrices: json["HidePrices"],
        isRental: json["IsRental"],
        rentalPrice: json["RentalPrice"],
        displayTaxShippingInfo: json["DisplayTaxShippingInfo"],
        basePricePAngV: json["BasePricePAngV"],
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "CurrencyCode": currencyCode,
        "OldPrice": oldPrice,
        "Price": price,
        "PriceWithDiscount": priceWithDiscount,
        "PriceValue": priceValue,
        "CustomerEntersPrice": customerEntersPrice,
        "CallForPrice": callForPrice,
        "ProductId": productId,
        "HidePrices": hidePrices,
        "IsRental": isRental,
        "RentalPrice": rentalPrice,
        "DisplayTaxShippingInfo": displayTaxShippingInfo,
        "BasePricePAngV": basePricePAngV,
        "CustomProperties": customProperties.toJson(),
      };
}

class ProductReviewOverview {
  ProductReviewOverview({
    required this.productId,
    required this.ratingSum,
    required this.totalReviews,
    required this.allowCustomerReviews,
    required this.customProperties,
  });

  int productId;
  int ratingSum;
  int totalReviews;
  bool allowCustomerReviews;
  CustomProperties customProperties;

  factory ProductReviewOverview.fromJson(Map<String, dynamic> json) =>
      ProductReviewOverview(
        productId: json["ProductId"],
        ratingSum: json["RatingSum"],
        totalReviews: json["TotalReviews"],
        allowCustomerReviews: json["AllowCustomerReviews"],
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "ProductId": productId,
        "RatingSum": ratingSum,
        "TotalReviews": totalReviews,
        "AllowCustomerReviews": allowCustomerReviews,
        "CustomProperties": customProperties.toJson(),
      };
}

class ProductSpecification {
  ProductSpecification({
    required this.specificationAttributeId,
    required this.specificationAttributeName,
    required this.valueRaw,
    required this.colorSquaresRgb,
    required this.customProperties,
  });

  int specificationAttributeId;
  String specificationAttributeName;
  String valueRaw;
  dynamic colorSquaresRgb;
  CustomProperties customProperties;

  factory ProductSpecification.fromJson(Map<String, dynamic> json) =>
      ProductSpecification(
        specificationAttributeId: json["SpecificationAttributeId"],
        specificationAttributeName: json["SpecificationAttributeName"],
        valueRaw: json["ValueRaw"],
        colorSquaresRgb: json["ColorSquaresRgb"],
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "SpecificationAttributeId": specificationAttributeId,
        "SpecificationAttributeName": specificationAttributeName,
        "ValueRaw": valueRaw,
        "ColorSquaresRgb": colorSquaresRgb,
        "CustomProperties": customProperties.toJson(),
      };
}

class ProductTag {
  ProductTag({
    required this.name,
    required this.seName,
    required this.productCount,
    required this.id,
    required this.customProperties,
  });

  String name;
  String seName;
  int productCount;
  int id;
  CustomProperties customProperties;

  factory ProductTag.fromJson(Map<String, dynamic> json) => ProductTag(
        name: json["Name"],
        seName: json["SeName"],
        productCount: json["ProductCount"],
        id: json["Id"],
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "Name": name,
        "SeName": seName,
        "ProductCount": productCount,
        "Id": id,
        "CustomProperties": customProperties.toJson(),
      };
}
