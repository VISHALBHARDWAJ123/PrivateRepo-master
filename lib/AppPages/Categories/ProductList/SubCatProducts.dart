import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_add_to_cart_button/flutter_add_to_cart_button.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
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
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  // int pageNumber = 1;
  var guestCustomerId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      guestCustomerId = ConstantsVar.prefs.getString('guestCustomerID');
    });
    print('${widget.categoryId}');
    // _myController.addStream(ApiCalls.getCategoryData('${widget.categoryId}',context));
  }

  void _onLoading() async {
    print('object');
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        appBar: new AppBar(
          actions: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
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
                      badgeContent: new Text('${value.badgeNumber}'),
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
                    builder: (context) => CartScreen2(),
                  ),
                ),
              ),
            )
          ],

          toolbarHeight: 18.w,
          backgroundColor: ConstantsVar.appColor,
          centerTitle: true,
          // leading: Icon(Icons.arrow_back_ios),
          title: InkWell(
            onTap: () => Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(builder: (context) => MyHomePage()),
                (route) => false),
            child: Image.asset(
              'MyAssets/logo.png',
              width: 15.w,
              height: 15.w,
            ),
          ),
        ),
        body: FutureBuilder<dynamic>(
          future: ApiCalls.getCategoryById('${widget.categoryId}', context, 0),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                  child: SpinKitRipple(
                    size: 90,
                    color: Colors.red,
                  ),
                );
              case ConnectionState.none:
                return Center(
                  child: Text('Please Check Your Connection'),
                );
              default:
                if (snapshot.hasError) {
                  return Scaffold(
                      body: Container(
                          child:
                              Center(child: Text(snapshot.error.toString()))));
                } else {
                  dynamic result = snapshot.data;
                  ProductListModel model = ProductListModel.fromJson(result);
                  // var title = result['Name'];
                  List<ResponseDatum> products = model.responseData;
                  int productCount = model.productCount;

                  if (products.length != 0) {
                    return prodListWidget(
                      products: products,
                      title: widget.title,
                      // result: result,
                      pageIndex: pageIndex,
                      id: '${widget.categoryId}',
                      productCount: productCount,
                      guestCustomerId: guestCustomerId,
                    );
                  } else {
                    return Scaffold(
                      body: Container(
                        child: Center(
                          child: Text('No Product Found'),
                        ),
                      ),
                    );
                  }
                }
            }
          },
        ),
      ),
    );
  }
}

class AddCartBtn extends StatefulWidget {
  AddCartBtn(
      {Key? key,
      this.productId,
      // required this.width,
      required this.isTrue,
      required this.guestCustomerId
      // required this.fontSize,
      })
      : super(key: key);
  final productId;
  final guestCustomerId;

  // double width;
  bool isTrue;

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
    return Container(
      color: ConstantsVar.appColor,
      child: AddToCartButton(
        backgroundColor: ConstantsVar.appColor,
        stateId: stateId,
        trolley: widget.isTrue == true
            ? Icon(
                Icons.shopping_cart,
                size: 18,
              )
            : Container(color: Colors.black),
        text: Text(
          'ADD TO cart'.toUpperCase(),
          style: TextStyle(
            fontSize: 4.w,
          ),
        ),
        check: Icon(Icons.check),
        onPressed: (id) => checkStateId(stateId),
      ),
    );
  }

  void checkStateId(AddToCartButtonStateId id) async {
    if (id == AddToCartButtonStateId.idle) {
      //handle logic when pressed on idle state button.
      if (widget.guestCustomerId != null || widget.guestCustomerId != '') {
        setState(() {
          stateId = AddToCartButtonStateId.loading;
          AddToCartResponse result;
          ApiCalls.addToCart(
                  widget.guestCustomerId, '${widget.productId}', context)
              .then((response) {
            setState(() {
              int val = 0;
              ApiCalls.readCounter(
                      customerGuid: ConstantsVar.prefs.getString('guestGUID')!)
                  .then((value) {
                    setState(() {
                      val =int.parse(value);
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
