import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/AppPages/CartxxScreen/CartScreen2.dart';
import 'package:untitled2/AppPages/Categories/DiscountxxWidget.dart';
import 'package:untitled2/AppPages/Categories/ProductList/SubCatProducts.dart';
import 'package:untitled2/AppPages/CustomLoader/CustomDialog/ContactsUS/ContactsUS.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/LoginScreen/LoginScreen.dart';
import 'package:untitled2/AppPages/Registration/RegistrationPage.dart';
import 'package:untitled2/AppPages/SearchPage/SearchPage.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/Slider.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';
import 'package:untitled2/utils/CartBadgeCounter/CartBadgetLogic.dart';
import 'package:untitled2/utils/HeartIcon.dart';
import 'package:untitled2/utils/utils/colors.dart';
import 'package:checkbox_grouped/checkbox_grouped.dart';
// import 'package:loader_overlay/loader_overlay.dart';

import 'ProductResponse.dart';

class NewProductDetails extends StatefulWidget {
  NewProductDetails(
      {Key? key, required this.productId, required this.screenName})
      : super(key: key);
  final productId;

  final String screenName;

  @override
  _NewProductDetailsState createState() => _NewProductDetailsState();
}

class _NewProductDetailsState extends State<NewProductDetails> {
  var visible;
  var indVisibility;
  var snapshot;
  var customerId;
  var guestCustomerID;
  var productID;
  var name;
  var description;
  var price;
  double? priceValue;
  var discountedPrice;
  var isDiscountAvail;
  var sku;
  var stockAvailabilty;
  var image1;
  var image2;
  var image3;
  var id;
  String discountPercentage = '';
  List<String> imageList = [];
  List<String> largeImage = [];
  var connectionStatus;
  bool isScroll = true;
  var assemblyCharges;
  FocusNode yourfoucs = FocusNode();
  ProductResponse? initialData;
  bool showSubBtn = false;
  bool isSubAlready = false;
  String subBtnName = '';
  var apiToken;
  List<GiftCardModel> _giftCardPriceList = [];
  List<String> _selectedList = [];
  var customerGuid;
  bool isExtra = false;
  bool isListIdSelected = false;

  bool _isVisibility = false;

  bool isShown = false;

  TextEditingController _searchController = TextEditingController();
  var _focusNode = FocusNode();

  var isVisible = false;

  Color btnColor = Colors.black;

  var _suggestController = ScrollController();
  String productAttributeName = '';

  GroupController? _groupController;

  var data = '';

  bool _isGiftCard = false, _isProductAttributeAvailable = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getInstance();
    setState(() {
      _groupController = GroupController(
          isMultipleSelection: true, initSelectedItem: _selectedList);
      productID = widget.productId;
      guestCustomerID = ConstantsVar.prefs.getString('guestCustomerID');
      customerGuid = ConstantsVar.prefs.getString('guestGUID');
      apiToken = ConstantsVar.prefs.getString('apiTokken');
    });

    ApiCalls.readCounter(customerGuid: customerGuid)
        .then((value) => setState(() {
              context.read<cartCounter>().changeCounter(value);
            }));

    ApiCalls.getProductData('$productID').then((value) {
      ProductResponse myResponse = ProductResponse.fromJson(value);
      setState(() {
        initialData = myResponse;
        isSubAlready = initialData!.subscribedToBackInStockSubscription;

        showSubBtn = initialData!.displayBackInStockSubscription;
        if (isSubAlready == true) {
          subBtnName = 'Unsubscribe';
        } else {
          subBtnName = 'Notify Me\!';
        }
        // List<Value> value=[] ;
        for (int i = 0; i <= initialData!.pictureModels.length - 1; i++) {
          image1 = initialData!.pictureModels[i].imageUrl;
          image2 = initialData!.pictureModels[i].fullSizeImageUrl;
          imageList.add(image1);
          largeImage.add(image2);
          // setState((){value.addAll(initialData!.productAttributes[i].values);});
        }

        // image2 = initialData['PictureModels'][0]['FullSizeImageUrl'];
        discountedPrice = initialData!.productPrice.priceWithDiscount;
        discountedPrice != null
            ? isDiscountAvail = true
            : isDiscountAvail = false;
        id = initialData!.id;
        name = initialData!.name;
        description = initialData!.shortDescription;
        price = initialData!.productPrice.price;
        priceValue =
            double.parse(initialData!.productPrice.priceValue.toString());
        sku = initialData!.sku;
        stockAvailabilty = initialData!.stockAvailability;
        discountPercentage = initialData!.discountPercentage;
        if (initialData!.productAttributes!.length != 0) {
          setState(() {
            isExtra = true;
            productAttributeName = initialData!.productAttributes![0].name;
          });
          for (int i = 0;
              i < initialData!.productAttributes![0].values.length;
              i++) {
            setState(() {
              _giftCardPriceList.add(
                new GiftCardModel(
                  name: initialData!.productAttributes![0].values[i].name +
                      '\[${initialData!.productAttributes![0].values[i].priceAdjustment}\]',
                  id: initialData!.productAttributes![0].values[i].id
                      .toString(),
                ),
              );
              print(_giftCardPriceList[i].name);
            });
          }

          if (initialData!.giftCard.isGiftCard == true) {
            // setState(() {
            //   isExtra = true;
            //   productAttributeName =
            //       initialData!.productAttributes![0].name.toString();
            // });
          }
        } else {
          setState(() {
            _isVisibility = true;
            assemblyCharges = '';
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (initialData == null) {
      return SafeArea(
        child: Scaffold(
          body: Container(
              child: Center(child: SpinKitRipple(color: Colors.red, size: 90))),
        ),
      );
    } else {
      return SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            appBar: new AppBar(
              // backgroundColor: ConstantsVar.appColor,
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 10),
                  child: InkWell(
                    radius: 48,
                    child: Consumer<cartCounter>(
                      builder: (context, value, child) {
                        return Badge(
                          position: BadgePosition.topEnd(),
                          badgeColor: Colors.white,
                          badgeContent:
                              new AutoSizeText(value.badgeNumber.toString()),
                          child: Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                    onTap: () => Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => CartScreen2(
                          isOtherScren: true,
                          otherScreenName: 'Product Screen',
                        ),
                      ),
                    ),
                  ),
                )
              ],
              toolbarHeight: 18.w,
              backgroundColor: ConstantsVar.appColor,
              centerTitle: true,
              title: InkWell(
                onTap: () => Navigator.pushAndRemoveUntil(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => MyHomePage(
                              pageIndex: 0,
                            )),
                    (route) => false),
                child: Image.asset(
                  'MyAssets/logo.png',
                  width: 15.w,
                  height: 15.w,
                ),
              ),
            ),
            body: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: ConstantsVar.appColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: RawAutocomplete<String>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text == null ||
                              textEditingValue.text == '') {
                            return const Iterable<String>.empty();
                          }
                          return ConstantsVar.suggestionList
                              .where((String option) {
                            return option
                                .toLowerCase()
                                .contains(textEditingValue.text.toLowerCase());
                          });
                        },
                        onSelected: (String selection) {
                          debugPrint('$selection selected');
                        },
                        fieldViewBuilder: (BuildContext context,
                            TextEditingController textEditingController,
                            FocusNode focusNode,
                            VoidCallback onFieldSubmitted) {
                          _searchController = textEditingController;
                          _focusNode = focusNode;
                          // FocusScopeNode currentFocus = FocusScopeNode.of(context);
                          return TextFormField(
                            autocorrect: true,
                            enableSuggestions: true,
                            onFieldSubmitted: (val) {
                              focusNode.unfocus();
                              if (currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                              if (mounted)
                                setState(() {
                                  var value = _searchController.text;
                                  Navigator.of(context).push(
                                    CupertinoPageRoute(
                                      builder: (context) => SearchPage(
                                        isScreen: true,
                                        keyword: value,
                                      ),
                                    ),
                                  );
                                });

                              print('Pressed via keypad');
                            },
                            textInputAction: isVisible
                                ? TextInputAction.done
                                : TextInputAction.search,
                            // keyboardType: TextInputType.,
                            keyboardAppearance: Brightness.light,
                            // autofocus: true,
                            onChanged: (_) => setState(() {
                              btnColor = ConstantsVar.appColor;
                            }),
                            controller: _searchController,
                            style:
                                TextStyle(color: Colors.black, fontSize: 5.w),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 13, horizontal: 10),
                              hintText: 'Search here',
                              labelStyle:
                                  TextStyle(fontSize: 7.w, color: Colors.grey),
                              suffixIcon: InkWell(
                                onTap: () async {
                                  focusNode.unfocus();

                                  if (!currentFocus.hasPrimaryFocus) {
                                    currentFocus.unfocus();
                                  }
                                  if (mounted)
                                    setState(() {
                                      var value = _searchController.text;
                                      Navigator.of(context).push(
                                        CupertinoPageRoute(
                                          builder: (context) => SearchPage(
                                            isScreen: true,
                                            keyword: value,
                                          ),
                                        ),
                                      );
                                    });
                                },
                                child: Icon(Icons.search_sharp),
                              ),
                            ),
                            focusNode: _focusNode,
                          );
                        },
                        optionsViewBuilder: (BuildContext context,
                            AutocompleteOnSelected<String> onSelected,
                            Iterable<String> options) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              top: 8.0,
                              right: 10,
                            ),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Material(
                                child: Card(
                                  child: Container(
                                    height: 178,
                                    child: Scrollbar(
                                      controller: _suggestController,
                                      thickness: 5,
                                      isAlwaysShown: true,
                                      child: ListView.builder(
                                        // padding: EdgeInsets.all(8.0),
                                        itemCount: options.length + 1,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          if (index >= options.length) {
                                            return Align(
                                              alignment: Alignment.bottomCenter,
                                              child: TextButton(
                                                child: const Text(
                                                  'Clear',
                                                  style: TextStyle(
                                                    color:
                                                        ConstantsVar.appColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  _searchController.clear();
                                                },
                                              ),
                                            );
                                          }
                                          final String option =
                                              options.elementAt(index);
                                          return GestureDetector(
                                              onTap: () {
                                                onSelected(option);
                                                Navigator.push(context, CupertinoPageRoute(builder:(context)=>SearchPage(keyword: option, isScreen: true,)));
                                              },
                                              child: Container(
                                                height: 5.2.h,
                                                width: 95.w,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: 100.w,
                                                      child: AutoSizeText(
                                                        '  ' + option,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          wordSpacing: 2,
                                                          letterSpacing: 1,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 100.w,
                                                      child: Divider(
                                                        thickness: 1,
                                                        color: Colors
                                                            .grey.shade400,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ));
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  // flex: 9,
                  child: customList(
                    context: context,
                    name: name,
                    price: price,
                    descritption: description,
                    priceValue: '$priceValue',
                    sku: sku,
                    stockAvaialbility: stockAvailabilty,
                    imageList: imageList,
                    largeImage: largeImage,
                    assemblyCharges: assemblyCharges,
                    initialData: initialData,
                    isDiscountAvail: isDiscountAvail,
                    discountedPrice:
                        discountedPrice != null ? discountedPrice : '',
                    disPercentage: discountPercentage,
                    showSub: showSubBtn,
                    isSubAlready: isSubAlready,
                  ),
                ),
                Container(
                  width: 100.w,
                  child: AddCartBtn(
                    productId: id,
                    isTrue: false,
                    guestCustomerId: guestCustomerID,
                    checkIcon:
                        stockAvailabilty.toString().contains('Out of stock')
                            ? Icon(HeartIcon.cross)
                            : Icon(Icons.check),
                    text: stockAvailabilty.toString().contains('Out of stock')
                        ? 'out of stock'.toUpperCase()
                        : 'add to cart'.toUpperCase(),
                    color: stockAvailabilty.toString().contains('Out of stock')
                        ? Colors.grey.shade700
                        : ConstantsVar.appColor,
                    isGiftCard: _isGiftCard,
                    isProductAttributeAvail: _isProductAttributeAvailable,
                    recipEmail: '',
                    name: '',
                    message: '',
                    attributeId: data,
                    recipName: '',
                    email: '',
                  ),
                )
              ],
            )),
      );
    }
  }

  ListView customList({
    required BuildContext context,
    required String name,
    required bool isDiscountAvail,
    required String discountedPrice,
    required String descritption,
    required String sku,
    required String stockAvaialbility,
    required String price,
    required String priceValue,
    required List<String> imageList,
    required List<String> largeImage,
    required String assemblyCharges,
    required dynamic initialData,
    required String disPercentage,
    required bool showSub,
    required bool isSubAlready,
  }) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: Container(
              child: SliderImages(
                  imageList, largeImage, context, discountPercentage)),
        ),
        Container(
          height: 30.h,
          width: MediaQuery.of(context).size.width,
          color: Color.fromARGB(255, 234, 235, 235),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoSizeText(
                  name,
                  maxLines: 1,
                  style: TextStyle(
                    wordSpacing: .5,
                    letterSpacing: .4,
                    fontSize: 6.7.w,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.start,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      descritption,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 5.w,
                        color: Colors.grey.shade700,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    Container(
                      width: 100.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AutoSizeText(
                            'SKU: $sku',
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 5.w,
                              color: Colors.grey.shade700,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          Visibility(
                            visible: isExtra,
                            child: InkWell(
                              onTap: () async {
                                showModalBottomSheet<void>(
                                  // context and builder are
                                  // required properties in this widget
                                  context: context,
                                  builder: (BuildContext context) {
                                    // we set up a container inside which
                                    // we create center column and display text
                                    return Container(
                                      width: 100.w,
                                      height: 60.h,
                                      child: Stack(
                                        children: [
                                          Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 6.0),
                                                child: AutoSizeText(
                                                  productAttributeName,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: 40.h,
                                                child: Scrollbar(
                                                  isAlwaysShown: true,
                                                  child: ListView(
                                                    children: [
                                                      SimpleGroupedCheckbox<
                                                          String>(
                                                        isLeading: true,
                                                        itemsTitle:
                                                            _giftCardPriceList
                                                                .map((e) =>
                                                                    e.name)
                                                                .toList(),
                                                        controller:
                                                            _groupController!,
                                                        values:
                                                            _giftCardPriceList
                                                                .map(
                                                                    (e) => e.id)
                                                                .toList(),
                                                        onItemSelected: (val) {
                                                          _selectedList.clear();
                                                          _selectedList
                                                              .addAll(val);
                                                          data = '';
                                                          data =
                                                              _groupController!
                                                                  .selectedItem
                                                                  .join(",");

                                                          print(data);
                                                          setState(() {});
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Positioned(
                                            bottom: 50,
                                            right: 3,
                                            child: Row(
                                              children: [
                                                AppButton(
                                                  onTap: () {
                                                    if (mounted)
                                                      Future.delayed(
                                                              Duration.zero)
                                                          .then((value) =>
                                                              setState(() {
                                                                _groupController!
                                                                    .deselectAll();
                                                                data = '';
                                                                _selectedList
                                                                    .clear();
                                                              }));
                                                    Navigator.pop(context);
                                                  },
                                                  child: Container(
                                                    width: 25.w,
                                                    height: 2.5.h,
                                                    child: Center(
                                                        child: Text('Cancel')),
                                                  ),
                                                  // color: Colors.transparent,
                                                ),
                                                AppButton(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Container(
                                                    width: 25.w,
                                                    height: 2.5.h,
                                                    child: Center(
                                                        child: Text('Apply')),
                                                  ),
                                                  // color: Colors.transparent,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                height: 4.6.h,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4.0,
                                  ),
                                  child:
                                      Center(child: Text(productAttributeName)),
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: ConstantsVar.appColor,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: 'Availability: ',
                              style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 5.w,
                                  fontWeight: FontWeight.w400),
                              children: <TextSpan>[
                                TextSpan(
                                    text: stockAvaialbility,
                                    style: TextStyle(
                                        fontSize: 5.w,
                                        color: stockAvailabilty.contains('In')
                                            ? Colors.green
                                            : Colors.grey,
                                        fontWeight: FontWeight.w400))
                              ],
                            ),
                          ),
                          Visibility(
                            visible: showSubBtn,
                            child: InkWell(
                              focusColor: ConstantsVar.appColor,
                              radius: 48,
                              highlightColor: Colors.transparent,
                              splashColor: ConstantsVar.appColor,
                              onTap: () {
                                ApiCalls.subscribeProdcut(
                                        productId: widget.productId,
                                        customerId: guestCustomerID,
                                        apiToken: apiToken)
                                    .then((value) => setState(() {
                                          if (value
                                              .toString()
                                              .contains('Subscribed')) {
                                            value = 'Notify Me\!';
                                            subBtnName = value;
                                          } else {
                                            subBtnName = value;
                                          }
                                        }));
                              },
                              child: Ink(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(subBtnName),
                                      )),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Visibility(
                      visible: assemblyCharges == null ? false : true,
                      child: AutoSizeText(
                        assemblyCharges == null ? '' : assemblyCharges,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 5.w,
                          color: Colors.grey.shade700,
                          letterSpacing: 1,
                          wordSpacing: 2,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: isDiscountAvail,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 3.0),
                        child: discountWidget(
                            actualPrice: price,
                            fontSize: 3.6.w,
                            width: 50.w,
                            isSpace: !isDiscountAvail),
                      ),
                    ),
                    AutoSizeText(
                      discountedPrice == '' ? price : discountedPrice,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 7.w,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                        letterSpacing: 1,
                        wordSpacing: 2,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          child: Divider(
            thickness: 2,
          ),
        ),
        ExpandablePanel(
          header: Padding(
            padding: const EdgeInsets.all(14.0),
            child: AutoSizeText('OVERVIEW', style: TextStyle(fontSize: 4.w)),
          ),
          collapsed: Text(
            '',
            softWrap: true,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          expanded: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: AutoSizeText(
                  name,
                  style: TextStyle(
                    fontSize: 6.w,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () => Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) =>
                      ContactUS(id: sku, name: name, desc: descritption))),
          child: Container(
            decoration: BoxDecoration(
                border: Border.symmetric(
                    horizontal: BorderSide(width: 1, color: Colors.black))),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 13.0),
              child: Text('CONTACT US'),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  void getInstance() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
  }
}

void showDialog1(BuildContext context) {
  showGeneralDialog(
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: Duration(milliseconds: 400),
    context: context,
    pageBuilder: (_, __, ___) {
      return Card(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColor.PrimaryAccentColor, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          height: 5.8.h,
          child: CupertinoScrollbar(
            child: ListView(children: [
              ListTile(
                title: TextFormField(),
              ),
              ListTile(
                title: TextFormField(),
              ),
            ]),
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      return SlideTransition(
        position: Tween(begin: Offset(0, 1), end: Offset(0, .7)).animate(anim),
        child: child,
      );
    },
  );
}

class GiftCardModel {
  String name;
  String id;

  GiftCardModel({required this.name, required this.id});
}
