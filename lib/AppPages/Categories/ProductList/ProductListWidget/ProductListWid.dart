// import 'dart:html';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// import 'package:untitled2/AppPages/CartxxScreen/ConstantVariables.dart';
import 'package:untitled2/AppPages/NewSubCategoryPage/ModelClass/NewSubCatProductModel.dart';
import 'package:untitled2/AppPages/StreamClass/NewPeoductPage/NewProductScreen.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';
import 'package:untitled2/utils/HeartIcon.dart';

import '../../DiscountxxWidget.dart';
import '../SubCatProducts.dart';

class prodListWidget extends StatefulWidget {
  prodListWidget({
    Key? key,
    required this.products,
    required this.title,
    // required this.result,
    required this.id,
    required this.pageIndex,
    required this.productCount,
    required this.guestCustomerId,
  }) : super(key: key);
  List<ResponseDatum> products;
  final title;

  // dynamic result;
  int pageIndex;
  String id;
  int productCount;
  final guestCustomerId;
  RefreshController myController = RefreshController();

  @override
  _prodListWidgetState createState() => _prodListWidgetState();
}

class _prodListWidgetState extends State<prodListWidget> {
  var pageIndex1 = 1;

  bool isLoading = true;

  void _onLoading() async {
    print('object');
    if (widget.products.length == widget.productCount) {
      widget.myController.loadComplete();
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = true;
        pageIndex1 = pageIndex1 + 1;
        print('$pageIndex1');
        ApiCalls.getCategoryById('${widget.id}', context, pageIndex1)
            .then((value) {
          ProductListModel model = ProductListModel.fromJson(value);
          if (widget.products.length == model.productCount) {
            Fluttertoast.showToast(msg: 'No More Products Available for now');
            widget.myController.loadComplete();
            // widget.myController.requestLoading();

          } else {
            widget.products.addAll(model.responseData);
          }

          setState(() {});
        });
      });

      // monitor network fetch

      // if failed,use loadFailed(),if no data return,use LoadNodata()
      //   if(widget.myController.)
      if (mounted) setState(() {});
      widget.myController.loadComplete();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    pageIndex1 = widget.pageIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ListTile(
          title: Center(
            child: Text(
              widget.title.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 6.w,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            width: 100.w,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: CupertinoScrollbar(
                isAlwaysShown: true,
                child: SmartRefresher(
                  onLoading: _onLoading,
                  controller: widget.myController,
                  footer: CustomFooter(
                    builder: (context, mode) {
                      Widget body;
                      if (mode == LoadStatus.idle) {
                        body = SpinKitRipple(
                          color: Colors.red,
                          size: 90,
                        );
                      } else if (mode == LoadStatus.loading) {
                        body = CupertinoActivityIndicator();
                      } else if (mode == LoadStatus.failed) {
                        body = Text("Load Failed!Click retry!");
                      } else if (mode == LoadStatus.canLoading) {
                        body = Text("release to load more");
                      } else {
                        body = Text("No more Data");
                      }
                      return Container(
                        height: 55.0,
                        child: Center(child: body),
                      );
                    },
                  ),
                  enablePullDown: false,
                  enablePullUp: isLoading,
                  enableTwoLevel: false,
                  physics: ClampingScrollPhysics(),
                  child: GridView.count(
                    shrinkWrap: false,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 6,
                    cacheExtent: 20,
                    children: List.generate(
                      widget.products.length,
                      (index) {
                        String name = widget.products[index].stockQuantity;
                        return InkWell(
                          onTap: () {
                            print(widget.products[index].id.toString());

                            //
                            SchedulerBinding.instance!
                                .addPostFrameCallback((timeStamp) {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) {
                                    return NewProductDetails(
                                      productId:
                                          widget.products[index].id.toString(),
                                      // customerId: ConstantsVar.customerID,
                                    );
                                  },
                                ),
                              );
                            });
                          },
                          child: Card(
                            // elevation: 2,
                            child: Container(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    color: Colors.white,
                                    padding: EdgeInsets.all(4.0),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          widget.products[index].productPicture,
                                      fit: BoxFit.cover,
                                      placeholder: (context, reason) =>
                                          new SpinKitRipple(
                                        color: Colors.red,
                                        size: 90,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 8.0),
                                    width: MediaQuery.of(context).size.width,
                                    // color: Color(0xFFe0e1e0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          widget.products[index].name,
                                          maxLines: 2,
                                          style: TextStyle(
                                              height: 1,
                                              color: Colors.black,
                                              fontSize: 5.w,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.start,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 6.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  top: 2.w,
                                                  left: 2,
                                                ),
                                                child: discountWidget(
                                                  actualPrice: widget
                                                      .products[index].price,
                                                  fontSize: 2.4.w,
                                                  width: 25.w,
                                                  isSpace: widget
                                                              .products[index]
                                                              .discountPrice ==
                                                          null
                                                      ? true
                                                      : false,
                                                ),
                                              ),
                                              Text(
                                                widget.products[index]
                                                            .discountPrice ==
                                                        null
                                                    ? widget
                                                        .products[index].price
                                                    : widget.products[index]
                                                        .discountPrice,
                                                maxLines: 1,
                                                style: TextStyle(
                                                    height: 1,
                                                    color: Colors.grey.shade600,
                                                    fontSize: 4.w,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign: TextAlign.start,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  top: 4,
                                                  bottom: 2,
                                                ),
                                                child: Text(
                                                  widget.products[index]
                                                      .stockQuantity,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      height: 1,
                                                      color: name.contains('In')
                                                          ? Colors.green
                                                          : Colors.red,
                                                      fontSize: 20.dp,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  AddCartBtn(
                                    productId: widget.products[index].id,
                                    // width: 2.w,
                                    isTrue: true,
                                    guestCustomerId: widget.guestCustomerId,
                                    checkIcon: widget
                                            .products[index].stockQuantity
                                            .contains('Out of stock')
                                        ? Icon(HeartIcon.cross)
                                        : Icon(Icons.check),
                                    text: widget.products[index].stockQuantity
                                            .contains('Out of stock')
                                        ? 'Out of Stock'.toUpperCase()
                                        : 'ADD TO CArt'.toUpperCase(),
                                    color: widget.products[index].stockQuantity
                                            .contains('Out of stock')
                                        ? Colors.grey
                                        : ConstantsVar.appColor,
                                    // fontSize: 12,
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
