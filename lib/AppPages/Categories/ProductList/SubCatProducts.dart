import 'package:auto_size_text/auto_size_text.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_add_to_cart_button/flutter_add_to_cart_button.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:untitled2/AppPages/CartxxScreen/CartScreen2.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/NewSubCategoryPage/ModelClass/NewSubCatProductModel.dart';
import 'package:untitled2/AppPages/StreamClass/NewPeoductPage/AddToCartResponse/AddToCartResponse.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';
import 'package:untitled2/utils/CartBadgeCounter/CartBadgetLogic.dart';

import 'ProductListWidget/ProductListWid.dart';

class ProductList extends StatefulWidget {
  const ProductList({Key? key, required this.categoryId, required this.title})
      : super(key: key);
  final categoryId;
  final title;

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  AddToCartButtonStateId stateId = AddToCartButtonStateId.idle;
  var customerId;
  int pageIndex = 0;
  var color;
  int productCount = 0;
  List<ResponseDatum> products = [];
  var guestCustomerId;
  ProductListModel? inititalData;

  bool isShown = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getId().whenComplete(() =>
        ApiCalls.getCategoryById('${widget.categoryId}', context, 0)
            .then((value) {
          setState(() {
            inititalData = ProductListModel.fromJson(value);
            productCount = inititalData!.productCount;
            products = inititalData!.responseData;
          });
        }));
    print('${widget.categoryId}');
  }

  @override
  Widget build(BuildContext context) {
    if (products == null) {
      return SafeArea(
        top: true,
        child: Scaffold(
          appBar: new AppBar(
            actions: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
                child: InkWell(
                  child: Icon(Icons.search),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                child: InkWell(
                  // splashColor: Colors.amber,
                  radius: 48,
                  child: Consumer<cartCounter>(
                    builder: (context, value, child) {
                      return Badge(
                        badgeColor: Colors.white,
                        padding: EdgeInsets.all(5),
                        shape: BadgeShape.circle,
                        position: BadgePosition.topEnd(),
                        badgeContent: new AutoSizeText('${value.badgeNumber}'),
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
                        otherScreenName: '',
                        isOtherScren: true,
                      ),
                    ),
                  ),
                ),
              ),
            ],

            toolbarHeight: 18.w,
            backgroundColor: ConstantsVar.appColor,
            centerTitle: true,
            // leading: Icon(Icons.arrow_back_ios),
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
          body: Container(
            child: Center(
              child: SpinKitRipple(
                color: Colors.red,
                size: 90,
              ),
            ),
          ),
        ),
      );
    } else {
      return SafeArea(
          top: true,
          bottom: true,
          maintainBottomViewPadding: true,
          child: Scaffold(
              appBar: new AppBar(
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 8.0),
                    child: InkWell(
                      // splashColor: Colors.amber,
                      radius: 48,
                      child: Consumer<cartCounter>(
                        builder: (context, value, child) {
                          return Badge(
                            badgeColor: Colors.white,
                            padding: EdgeInsets.all(5),
                            shape: BadgeShape.circle,
                            position: BadgePosition.topEnd(),
                            badgeContent:
                                new AutoSizeText('${value.badgeNumber}'),
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
                            otherScreenName: 'Product List',
                            isOtherScren: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],

                toolbarHeight: 18.w,
                backgroundColor: ConstantsVar.appColor,
                centerTitle: true,
                // leading: Icon(Icons.arrow_back_ios),
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
              body: prodListWidget(
                products: products,
                title: widget.title.toString().toUpperCase(),
                // result: result,
                pageIndex: pageIndex,
                id: '${widget.categoryId}',
                productCount: productCount,
                guestCustomerId: guestCustomerId,
                isShown: isShown,
              )));
    }
  }

  Future getId() async {
    setState(() {
      guestCustomerId = ConstantsVar.prefs.getString('guestCustomerID');
    });
  }
}

class AddCartBtn extends StatefulWidget {
  AddCartBtn({
    Key? key,
    this.productId,
    required this.text,
    required this.isTrue,
    required this.guestCustomerId,
    required this.checkIcon,
    required this.color,
    required this.isProductAttributeAvail,
    required this.isGiftCard,
    required this.recipEmail,
    required this.attributeId,
    required this.message,
    required this.name,
    required this.email,
    required this.recipName,
  }) : super(key: key);
  final productId;
  final guestCustomerId;
  Icon checkIcon;
  String text;
  Color color;
  String attributeId, name, recipName, email, recipEmail, message;

  // double width;
  bool isTrue;

  bool isProductAttributeAvail;
  bool isGiftCard;

  // final fontSize;

  @override
  _AddCartBtnState createState() => _AddCartBtnState();
}

class _AddCartBtnState extends State<AddCartBtn> {
  late AddToCartButtonStateId stateId;

  // var checkedIcon;
  //This is for Cart Badge
  var warning;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stateId = AddToCartButtonStateId.idle;
    getGuid();
  }

  final cartCounte = cartCounter();

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    return Container(
      color: widget.color,
      child: AddToCartButton(
        backgroundColor: widget.color,
        stateId: stateId,
        trolley: widget.isTrue == true
            ? Icon(
                Icons.shopping_cart,
                size: 18,
              )
            : Container(color: Colors.black),
        text: AutoSizeText(
          widget.text,
          style: TextStyle(
            fontSize: 4.w,
          ),
        ),
        check: widget.checkIcon,
        onPressed: (id) => checkStateId(stateId,currentFocus),
      ),
    );
  }

  void checkStateId(AddToCartButtonStateId id,  FocusScopeNode currentFocus ) async {
    // bool giftCardAvail = false;


      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }


    if (id == AddToCartButtonStateId.idle) {
      //handle logic when pressed on idle state button.
      if (widget.guestCustomerId != null || widget.guestCustomerId != '') {

        if (widget.isGiftCard == true &&
            widget.recipEmail.trim().length == 0 &&
            widget.recipName.trim().length == 0 &&
            widget.name.trim().length == 0 &&
            widget.email.trim().length == 0) {
          Fluttertoast.showToast(
              msg:
              'Please Provide following Fields:\nRecipient\'s Name,\nRecipient\'s Email,\nSender Name,\nSender Email.');
        }else
        if (widget.isGiftCard == true && widget.recipName.trim().length == 0) {
          Fluttertoast.showToast(msg: 'Please Provide Recipient\'s Name.');
          // setState(()=>giftCardAvail =)
        } else if (widget.isGiftCard == true &&
            widget.recipEmail.trim().length == 0) {
          Fluttertoast.showToast(msg: 'Please Provide Recipient\'s Email.');
        }
        // if (widget.recipEmail.trim().length == 0) {}
        else if (widget.isGiftCard == true && widget.name.trim().length == 0) {
          Fluttertoast.showToast(msg: 'Please Provide Sender Name.');
        } else if (widget.isGiftCard == true &&
            widget.email.trim().length == 0) {
          Fluttertoast.showToast(msg: 'Please Provide Sender Email.');
        }  else if (widget.isGiftCard == true &&
            widget.recipEmail.trim().length != 0 &&
            widget.recipName.trim().length != 0 &&
            widget.name.trim().length != 0 &&
            widget.email.trim().length != 0) {
          setState(() {
            stateId = AddToCartButtonStateId.loading;
            AddToCartResponse result;
            ApiCalls.addToCart(
                    widget.guestCustomerId,
                    '${widget.productId}',
                    context,
                    widget.attributeId,
                    widget.name,
                    widget.recipName,
                    widget.email,
                    widget.recipEmail,
                    widget.message)
                .then((response) {
              setState(() {
                int val = 0;
                ApiCalls.readCounter(
                        customerGuid:
                            ConstantsVar.prefs.getString('guestGUID')!)
                    .then((value) {
                  setState(() {
                    val = value;
                  });
                  context.read<cartCounter>().changeCounter(val);
                });

                stateId = AddToCartButtonStateId.done;
                Future.delayed(Duration(seconds: 1), () {
                  setState(() {
                    stateId = AddToCartButtonStateId.idle;
                  });
                });
              });
            });
            // setState(() {
            //   stateId = AddToCartButtonStateId.done;
            // });
          });
        } else {
          setState(() {
            stateId = AddToCartButtonStateId.loading;
            AddToCartResponse result;
            ApiCalls.addToCart(
                    widget.guestCustomerId,
                    '${widget.productId}',
                    context,
                    widget.attributeId,
                    widget.name,
                    widget.recipName,
                    widget.email,
                    widget.recipEmail,
                    widget.message)
                .then((response) {
              setState(() {
                int val = 0;
                ApiCalls.readCounter(
                        customerGuid:
                            ConstantsVar.prefs.getString('guestGUID')!)
                    .then((value) {
                  setState(() {
                    val = value;
                  });
                  context.read<cartCounter>().changeCounter(val);
                });

                stateId = AddToCartButtonStateId.done;
                Future.delayed(Duration(seconds: 1), () {
                  setState(() {
                    stateId = AddToCartButtonStateId.idle;
                  });
                });
              });
            });
            // setState(() {
            //   stateId = AddToCartButtonStateId.done;
            // });
          });
        }
      } else {}
    } else if (id == AddToCartButtonStateId.done) {
      //handle logic when pressed on done state button.
      setState(() {
        stateId = AddToCartButtonStateId.idle;
      });
    }
  }

  void getGuid() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
  }
}
