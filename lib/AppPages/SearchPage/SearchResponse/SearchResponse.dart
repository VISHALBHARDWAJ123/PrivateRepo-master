// To parse this JSON data, do
//
//     final searchResponse = searchResponseFromJson(jsonString);

import 'dart:convert';

SearchResponse searchResponseFromJson(String str) =>
    SearchResponse.fromJson(json.decode(str));

String searchResponseToJson(SearchResponse data) => json.encode(data.toJson());

class SearchResponse {
  SearchResponse({
    required this.totalproducts,
    required this.products,
    this.error,
  });

  String totalproducts;
  List<Product> products;
  dynamic error;

  factory SearchResponse.fromJson(Map<String, dynamic> json) => SearchResponse(
        totalproducts: '${json["totalproducts"]}',
        products: List<Product>.from(
            json["products"].map((x) => Product.fromJson(x))),
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
    required this.defaultPictureZoomEnabled,
    required this.defaultPictureModel,
    required this.pictureModels,
    required this.name,
    required this.shortDescription,
    required this.fullDescription,
    this.metaKeywords,
    required this.metaDescription,
    this.metaTitle,
    required this.seName,
    required this.productType,
    required this.showSku,
    required this.sku,
    required this.showManufacturerPartNumber,
    this.manufacturerPartNumber,
    required this.showGtin,
    this.gtin,
    required this.showVendor,
    required this.vendorModel,
    required this.hasSampleDownload,
    required this.giftCard,
    required this.isShipEnabled,
    required this.isFreeShipping,
    required this.freeShippingNotificationEnabled,
    this.deliveryDate,
    required this.isRental,
    this.rentalStartDate,
    this.rentalEndDate,
    required this.manageInventoryMethod,
    required this.stockAvailability,
    required this.displayBackInStockSubscription,
    required this.emailAFriendEnabled,
    required this.compareProductsEnabled,
    required this.pageShareCode,
    required this.productPrice,
    required this.addToCart,
    required this.breadcrumb,
    this.productTags,
    required this.productAttributes,
    this.productSpecifications,
    this.productManufacturers,
    required this.productReviewOverview,
    this.tierPrices,
    this.associatedProducts,
    required this.displayDiscontinuedMessage,
    required this.currentStoreName,
    required this.id,
    this.customProperties,
  });

  bool defaultPictureZoomEnabled;
  PictureModel defaultPictureModel;
  List<PictureModel> pictureModels;
  String name;
  String shortDescription;
  String fullDescription;
  String? metaKeywords;
  String metaDescription;
  String? metaTitle;
  String seName;
  int productType;
  bool showSku;
  String sku;
  bool showManufacturerPartNumber;
  String? manufacturerPartNumber;
  bool showGtin;
  String? gtin;
  bool showVendor;
  VendorModel vendorModel;
  bool hasSampleDownload;
  GiftCard giftCard;
  bool isShipEnabled;
  bool isFreeShipping;
  bool freeShippingNotificationEnabled;
  dynamic deliveryDate;
  bool isRental;
  dynamic rentalStartDate;
  dynamic rentalEndDate;
  int manageInventoryMethod;
  String stockAvailability;
  bool displayBackInStockSubscription;
  bool emailAFriendEnabled;
  bool compareProductsEnabled;
  String pageShareCode;
  ProductPrice productPrice;
  AddToCart addToCart;
  Breadcrumb breadcrumb;
  List<VendorModel>? productTags;
  List<ProductAttribute> productAttributes;
  List<ProductSpecification>? productSpecifications;
  List<dynamic>? productManufacturers;
  ProductReviewOverview productReviewOverview;
  List<dynamic>? tierPrices;
  List<dynamic>? associatedProducts;
  bool displayDiscontinuedMessage;
  CurrentStoreName? currentStoreName;
  int id;
  CustomProperties? customProperties;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        defaultPictureZoomEnabled: json["DefaultPictureZoomEnabled"],
        defaultPictureModel: PictureModel.fromJson(json["DefaultPictureModel"]),
        pictureModels: List<PictureModel>.from(
            json["PictureModels"].map((x) => PictureModel.fromJson(x))),
        name: json["Name"],
        shortDescription: json["ShortDescription"],
        fullDescription: json["FullDescription"],
        metaKeywords:
            json["MetaKeywords"] == null ? null : json["MetaKeywords"],
        metaDescription: json["MetaDescription"],
        metaTitle: json["MetaTitle"] == null ? null : json["MetaTitle"],
        seName: json["SeName"],
        productType: json["ProductType"],
        showSku: json["ShowSku"],
        sku: json["Sku"],
        showManufacturerPartNumber: json["ShowManufacturerPartNumber"],
        manufacturerPartNumber: json["ManufacturerPartNumber"] == null
            ? null
            : json["ManufacturerPartNumber"],
        showGtin: json["ShowGtin"],
        gtin: json["Gtin"] == null ? null : json["Gtin"],
        showVendor: json["ShowVendor"],
        vendorModel: VendorModel.fromJson(json["VendorModel"]),
        hasSampleDownload: json["HasSampleDownload"],
        giftCard: GiftCard.fromJson(json["GiftCard"]),
        isShipEnabled: json["IsShipEnabled"],
        isFreeShipping: json["IsFreeShipping"],
        freeShippingNotificationEnabled:
            json["FreeShippingNotificationEnabled"],
        deliveryDate: json["DeliveryDate"],
        isRental: json["IsRental"],
        rentalStartDate: json["RentalStartDate"],
        rentalEndDate: json["RentalEndDate"],
        manageInventoryMethod: json["ManageInventoryMethod"],
        stockAvailability: json["StockAvailability"],
        displayBackInStockSubscription: json["DisplayBackInStockSubscription"],
        emailAFriendEnabled: json["EmailAFriendEnabled"],
        compareProductsEnabled: json["CompareProductsEnabled"],
        pageShareCode: json["PageShareCode"],
        productPrice: ProductPrice.fromJson(json["ProductPrice"]),
        addToCart: AddToCart.fromJson(json["AddToCart"]),
        breadcrumb: Breadcrumb.fromJson(json["Breadcrumb"]),
        productTags: List<VendorModel>.from(
            json["ProductTags"].map((x) => VendorModel.fromJson(x))),
        productAttributes: List<ProductAttribute>.from(
            json["ProductAttributes"].map((x) => ProductAttribute.fromJson(x))),
        productSpecifications: List<ProductSpecification>.from(
            json["ProductSpecifications"]
                .map((x) => ProductSpecification.fromJson(x))),
        productManufacturers:
            List<dynamic>.from(json["ProductManufacturers"].map((x) => x)),
        productReviewOverview:
            ProductReviewOverview.fromJson(json["ProductReviewOverview"]),
        tierPrices: List<dynamic>.from(json["TierPrices"].map((x) => x)),
        associatedProducts:
            List<dynamic>.from(json["AssociatedProducts"].map((x) => x)),
        displayDiscontinuedMessage: json["DisplayDiscontinuedMessage"],
        currentStoreName: currentStoreNameValues.map[json["CurrentStoreName"]],
        id: json["Id"],
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "DefaultPictureZoomEnabled": defaultPictureZoomEnabled,
        "DefaultPictureModel": defaultPictureModel.toJson(),
        "PictureModels":
            List<dynamic>.from(pictureModels.map((x) => x.toJson())),
        "Name": name,
        "ShortDescription": shortDescription,
        "FullDescription": fullDescription,
        "MetaKeywords": metaKeywords == null ? null : metaKeywords,
        "MetaDescription": metaDescription,
        "MetaTitle": metaTitle == null ? null : metaTitle,
        "SeName": seName,
        "ProductType": productType,
        "ShowSku": showSku,
        "Sku": sku,
        "ShowManufacturerPartNumber": showManufacturerPartNumber,
        "ManufacturerPartNumber":
            manufacturerPartNumber == null ? null : manufacturerPartNumber,
        "ShowGtin": showGtin,
        "Gtin": gtin == null ? null : gtin,
        "ShowVendor": showVendor,
        "VendorModel": vendorModel.toJson(),
        "HasSampleDownload": hasSampleDownload,
        "GiftCard": giftCard.toJson(),
        "IsShipEnabled": isShipEnabled,
        "IsFreeShipping": isFreeShipping,
        "FreeShippingNotificationEnabled": freeShippingNotificationEnabled,
        "DeliveryDate": deliveryDate,
        "IsRental": isRental,
        "RentalStartDate": rentalStartDate,
        "RentalEndDate": rentalEndDate,
        "ManageInventoryMethod": manageInventoryMethod,
        "StockAvailability": stockAvailability,
        "DisplayBackInStockSubscription": displayBackInStockSubscription,
        "EmailAFriendEnabled": emailAFriendEnabled,
        "CompareProductsEnabled": compareProductsEnabled,
        "PageShareCode": pageShareCode,
        "ProductPrice": productPrice.toJson(),
        "AddToCart": addToCart.toJson(),
        "Breadcrumb": breadcrumb.toJson(),
        "ProductTags": List<dynamic>.from(productTags!.map((x) => x.toJson())),
        "ProductAttributes":
            List<dynamic>.from(productAttributes.map((x) => x.toJson())),
        "ProductSpecifications":
            List<dynamic>.from(productSpecifications!.map((x) => x.toJson())),
        "ProductManufacturers":
            List<dynamic>.from(productManufacturers!.map((x) => x)),
        "ProductReviewOverview": productReviewOverview.toJson(),
        "TierPrices": List<dynamic>.from(tierPrices!.map((x) => x)),
        "AssociatedProducts":
            List<dynamic>.from(associatedProducts!.map((x) => x)),
        "DisplayDiscontinuedMessage": displayDiscontinuedMessage,
        "CurrentStoreName": currentStoreNameValues.reverse[currentStoreName],
        "Id": id,
        "CustomProperties": customProperties!.toJson(),
      };
}

class AddToCart {
  AddToCart({
    required this.productId,
    required this.enteredQuantity,
    this.minimumQuantityNotification,
    this.allowedQuantities,
    required this.customerEntersPrice,
    required this.customerEnteredPrice,
    this.customerEnteredPriceRange,
    required this.disableBuyButton,
    required this.disableWishlistButton,
    required this.isRental,
    required this.availableForPreOrder,
    this.preOrderAvailabilityStartDateTimeUtc,
    required this.updatedShoppingCartItemId,
    this.updateShoppingCartItemType,
    this.customProperties,
  });

  int productId;
  int enteredQuantity;
  dynamic minimumQuantityNotification;
  List<dynamic>? allowedQuantities;
  bool customerEntersPrice;
  String customerEnteredPrice;
  dynamic customerEnteredPriceRange;
  bool disableBuyButton;
  bool disableWishlistButton;
  bool isRental;
  bool availableForPreOrder;
  dynamic preOrderAvailabilityStartDateTimeUtc;
  int updatedShoppingCartItemId;
  dynamic updateShoppingCartItemType;
  CustomProperties? customProperties;

  factory AddToCart.fromJson(Map<String, dynamic> json) => AddToCart(
        productId: json["ProductId"],
        enteredQuantity: json["EnteredQuantity"],
        minimumQuantityNotification: json["MinimumQuantityNotification"],
        allowedQuantities:
            List<dynamic>.from(json["AllowedQuantities"].map((x) => x)),
        customerEntersPrice: json["CustomerEntersPrice"],
        customerEnteredPrice: '${json["CustomerEnteredPrice"]}',
        customerEnteredPriceRange: json["CustomerEnteredPriceRange"],
        disableBuyButton: json["DisableBuyButton"],
        disableWishlistButton: json["DisableWishlistButton"],
        isRental: json["IsRental"],
        availableForPreOrder: json["AvailableForPreOrder"],
        preOrderAvailabilityStartDateTimeUtc:
            json["PreOrderAvailabilityStartDateTimeUtc"],
        updatedShoppingCartItemId: json["UpdatedShoppingCartItemId"],
        updateShoppingCartItemType: json["UpdateShoppingCartItemType"],
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "ProductId": productId,
        "EnteredQuantity": enteredQuantity,
        "MinimumQuantityNotification": minimumQuantityNotification,
        "AllowedQuantities":
            List<dynamic>.from(allowedQuantities!.map((x) => x)),
        "CustomerEntersPrice": customerEntersPrice,
        "CustomerEnteredPrice": customerEnteredPrice,
        "CustomerEnteredPriceRange": customerEnteredPriceRange,
        "DisableBuyButton": disableBuyButton,
        "DisableWishlistButton": disableWishlistButton,
        "IsRental": isRental,
        "AvailableForPreOrder": availableForPreOrder,
        "PreOrderAvailabilityStartDateTimeUtc":
            preOrderAvailabilityStartDateTimeUtc,
        "UpdatedShoppingCartItemId": updatedShoppingCartItemId,
        "UpdateShoppingCartItemType": updateShoppingCartItemType,
        "CustomProperties": customProperties!.toJson(),
      };
}

class CustomProperties {
  CustomProperties();

  factory CustomProperties.fromJson(Map<String, dynamic> json) =>
      CustomProperties();

  Map<String, dynamic> toJson() => {};
}

class Breadcrumb {
  Breadcrumb({
    required this.enabled,
    required this.productId,
    required this.productName,
    required this.productSeName,
    required this.categoryBreadcrumb,
    this.customProperties,
  });

  bool enabled;
  int productId;
  String productName;
  String productSeName;
  List<CategoryBreadcrumb> categoryBreadcrumb;
  CustomProperties? customProperties;

  factory Breadcrumb.fromJson(Map<String, dynamic> json) => Breadcrumb(
        enabled: json["Enabled"],
        productId: json["ProductId"],
        productName: json["ProductName"],
        productSeName: json["ProductSeName"],
        categoryBreadcrumb: List<CategoryBreadcrumb>.from(
            json["CategoryBreadcrumb"]
                .map((x) => CategoryBreadcrumb.fromJson(x))),
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "Enabled": enabled,
        "ProductId": productId,
        "ProductName": productName,
        "ProductSeName": productSeName,
        "CategoryBreadcrumb":
            List<dynamic>.from(categoryBreadcrumb.map((x) => x.toJson())),
        "CustomProperties": customProperties!.toJson(),
      };
}

class CategoryBreadcrumb {
  CategoryBreadcrumb({
    required this.name,
    required this.seName,
    this.numberOfProducts,
    required this.includeInTopMenu,
    this.subCategories,
    required this.id,
    this.customProperties,
  });

  String name;
  String seName;
  dynamic numberOfProducts;
  bool includeInTopMenu;
  List<dynamic>? subCategories;
  int id;
  CustomProperties? customProperties;

  factory CategoryBreadcrumb.fromJson(Map<String, dynamic> json) =>
      CategoryBreadcrumb(
        name: json["Name"],
        seName: json["SeName"],
        numberOfProducts: json["NumberOfProducts"],
        includeInTopMenu: json["IncludeInTopMenu"],
        subCategories: List<dynamic>.from(json["SubCategories"].map((x) => x)),
        id: json["Id"],
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "Name": name,
        "SeName": seName,
        "NumberOfProducts": numberOfProducts,
        "IncludeInTopMenu": includeInTopMenu,
        "SubCategories": List<dynamic>.from(subCategories!.map((x) => x)),
        "Id": id,
        "CustomProperties": customProperties!.toJson(),
      };
}

enum CurrentStoreName { THE_ONE_UAE }

final currentStoreNameValues =
    EnumValues({"THE One UAE": CurrentStoreName.THE_ONE_UAE});

class PictureModel {
  PictureModel({
    required this.imageUrl,
    required this.thumbImageUrl,
    required this.fullSizeImageUrl,
    required this.title,
    required this.alternateText,
    this.customProperties,
  });

  String imageUrl;
  String thumbImageUrl;
  String fullSizeImageUrl;
  String title;
  String alternateText;
  CustomProperties? customProperties;

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
        "CustomProperties": customProperties!.toJson(),
      };
}

class GiftCard {
  GiftCard({
    required this.isGiftCard,
    this.recipientName,
    this.recipientEmail,
    this.senderName,
    this.senderEmail,
    this.message,
    required this.giftCardType,
    this.customProperties,
  });

  bool isGiftCard;
  dynamic recipientName;
  dynamic recipientEmail;
  dynamic senderName;
  dynamic senderEmail;
  dynamic message;
  int giftCardType;
  CustomProperties? customProperties;

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
        "CustomProperties": customProperties!.toJson(),
      };
}

class ProductAttribute {
  ProductAttribute({
    required this.productId,
    required this.productAttributeId,
    required this.name,
    this.description,
    this.textPrompt,
    required this.isRequired,
    this.defaultValue,
    this.selectedDay,
    this.selectedMonth,
    this.selectedYear,
    required this.hasCondition,
    required this.allowedFileExtensions,
    required this.attributeControlType,
    required this.values,
    required this.id,
    this.customProperties,
  });

  int productId;
  int productAttributeId;
  String name;
  dynamic description;
  dynamic textPrompt;
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
  CustomProperties? customProperties;

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
        "CustomProperties": customProperties!.toJson(),
      };
}

class Value {
  Value({
    required this.name,
    this.colorSquaresRgb,
    required this.imageSquaresPictureModel,
    required this.priceAdjustment,
    required this.priceAdjustmentValue,
    required this.isPreSelected,
    required this.pictureId,
    required this.customerEntersQty,
    required this.quantity,
    required this.id,
    this.customProperties,
  });

  String name;
  dynamic colorSquaresRgb;
  PictureModel imageSquaresPictureModel;
  String priceAdjustment;
  String priceAdjustmentValue;
  bool isPreSelected;
  int pictureId;
  bool customerEntersQty;
  int quantity;
  int id;
  CustomProperties? customProperties;

  factory Value.fromJson(Map<String, dynamic> json) => Value(
        name: json["Name"],
        colorSquaresRgb: json["ColorSquaresRgb"],
        imageSquaresPictureModel:
            PictureModel.fromJson(json["ImageSquaresPictureModel"]),
        priceAdjustment: json["PriceAdjustment"],
        priceAdjustmentValue: '${json["PriceAdjustmentValue"]}',
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
        "CustomProperties": customProperties!.toJson(),
      };
}

class ProductPrice {
  ProductPrice({
    required this.currencyCode,
    this.oldPrice,
    required this.price,
    this.priceWithDiscount,
    required this.priceValue,
    required this.customerEntersPrice,
    required this.callForPrice,
    required this.productId,
    required this.hidePrices,
    required this.isRental,
    this.rentalPrice,
    required this.displayTaxShippingInfo,
    this.basePricePAngV,
    this.customProperties,
  });

  CurrencyCode? currencyCode;
  dynamic oldPrice;
  String price;
  dynamic priceWithDiscount;
  double priceValue;
  bool customerEntersPrice;
  bool callForPrice;
  String productId;
  bool hidePrices;
  bool isRental;
  dynamic rentalPrice;
  bool displayTaxShippingInfo;
  dynamic basePricePAngV;
  CustomProperties? customProperties;

  factory ProductPrice.fromJson(Map<String, dynamic> json) => ProductPrice(
        currencyCode: currencyCodeValues.map[json["CurrencyCode"]],
        oldPrice: json["OldPrice"],
        price: json["Price"],
        priceWithDiscount: json["PriceWithDiscount"],
        priceValue: json["PriceValue"],
        customerEntersPrice: json["CustomerEntersPrice"],
        callForPrice: json["CallForPrice"],
        productId: '${json["ProductId"]}',
        hidePrices: json["HidePrices"],
        isRental: json["IsRental"],
        rentalPrice: json["RentalPrice"],
        displayTaxShippingInfo: json["DisplayTaxShippingInfo"],
        basePricePAngV: json["BasePricePAngV"],
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "CurrencyCode": currencyCodeValues.reverse[currencyCode],
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
        "CustomProperties": customProperties!.toJson(),
      };
}

enum CurrencyCode { AED }

final currencyCodeValues = EnumValues({"AED": CurrencyCode.AED});

class ProductReviewOverview {
  ProductReviewOverview({
    required this.productId,
    required this.ratingSum,
    required this.totalReviews,
    required this.allowCustomerReviews,
    this.customProperties,
  });

  int productId;
  int ratingSum;
  int totalReviews;
  bool allowCustomerReviews;
  CustomProperties? customProperties;

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
        "CustomProperties": customProperties!.toJson(),
      };
}

class ProductSpecification {
  ProductSpecification({
    this.specificationAttributeId,
    this.specificationAttributeName,
    this.valueRaw,
    this.colorSquaresRgb,
    this.customProperties,
  });

  int? specificationAttributeId;
  SpecificationAttributeName? specificationAttributeName;
  String? valueRaw;
  dynamic colorSquaresRgb;
  CustomProperties? customProperties;

  factory ProductSpecification.fromJson(Map<String, dynamic> json) =>
      ProductSpecification(
        specificationAttributeId: json["SpecificationAttributeId"],
        specificationAttributeName: specificationAttributeNameValues
            .map[json["SpecificationAttributeName"]],
        valueRaw: json["ValueRaw"],
        colorSquaresRgb: json["ColorSquaresRgb"],
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "SpecificationAttributeId": specificationAttributeId,
        "SpecificationAttributeName": specificationAttributeNameValues
            .reverse[specificationAttributeName],
        "ValueRaw": valueRaw,
        "ColorSquaresRgb": colorSquaresRgb,
        "CustomProperties": customProperties!.toJson(),
      };
}

enum SpecificationAttributeName { NUMBER_OF_SEATS, COLOUR, FAMILY, MEASUREMENT }

final specificationAttributeNameValues = EnumValues({
  "Colour": SpecificationAttributeName.COLOUR,
  "Family": SpecificationAttributeName.FAMILY,
  "Measurement": SpecificationAttributeName.MEASUREMENT,
  "Number of Seats": SpecificationAttributeName.NUMBER_OF_SEATS
});

class VendorModel {
  VendorModel({
    this.name,
    this.seName,
    this.id,
    this.customProperties,
  });

  String? name;
  String? seName;
  int? id;
  CustomProperties? customProperties;

  factory VendorModel.fromJson(Map<String, dynamic> json) => VendorModel(
        name: json["Name"] == null ? null : json["Name"],
        seName: json["SeName"] == null ? null : json["SeName"],
        id: json["Id"],
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "Name": name == null ? null : name,
        "SeName": seName == null ? null : seName,
        "Id": id,
        "CustomProperties": customProperties!.toJson(),
      };
}

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
