import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:untitled2/AppPages/StreamClass/NewPeoductPage/NewProductScreen.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/Widgets/CustomButton.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';
import 'package:untitled2/utils/CartBadgeCounter/CartBadgetLogic.dart';
import 'package:provider/provider.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class CartItem extends StatefulWidget {
  String unitPrice;

  CartItem(
      {Key? key,
      required this.unitPrice,
      required this.quantity2,
      required this.id,
      required this.itemID,
      required this.imageUrl,
      required this.title,
      required this.sku,
      required this.price,
      required this.quantity,
      required this.updateUi,
      required this.reload,
      required this.productId})
      : super(key: key);
  final int itemID;
  final productId;
  final String imageUrl;
  final String title;
  final String sku;
  final String price;
  int quantity, quantity2;
  final VoidCallback updateUi, reload;
  final id;

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) =>
                    NewProductDetails(productId: widget.productId.toString(), screenName: 'Cart Screen2',)));
      },
      child: Container(
        height: 24.h,
        child: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: Row(
                children: <Widget>[
                  Container(
                      margin:
                          EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8),
                      width: 80,
                      height: 80,
                      child: CachedNetworkImage(
                        imageUrl: widget.imageUrl,
                        fit: BoxFit.cover,
                      )),
                  Expanded(
                    child: Container(
                      height: 23.h,
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            // padding: EdgeInsets.only(right: 8, top: 4),
                            child: AutoSizeText(
                              widget.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              style: CustomTextStyle.textFormFieldSemiBold
                                  .copyWith(fontSize: 16),
                            ),
                          ),
                          // Utils.getSizedBox(null, 6),
                          AutoSizeText(
                            "SKU : ${widget.sku}",
                            style: CustomTextStyle.textFormFieldRegular
                                .copyWith(color: Colors.grey, fontSize: 15),
                          ),
                          // Utils.getSizedBox(null, 6),
                          AutoSizeText(
                            widget.unitPrice,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Flexible(
                                  child: AutoSizeText(
                                    widget.price,
                                    overflow: TextOverflow.ellipsis,
                                    style: CustomTextStyle.textFormFieldBlack
                                        .copyWith(color: Colors.green),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      InkWell(
                                        radius: 36,
                                        onTap: () async {
                                          print('SomeOne Tap on Me');
                                          print(widget.id);
                                          setState(() {
                                            if (widget.quantity < 1) {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      'Quantity cannot be zero.'
                                                      ' The product will be removed from cart');
                                              ApiCalls.deleteCartItem(
                                                      ConstantsVar.customerID,
                                                      widget.itemID,
                                                      context)
                                                  .then((value) {
                                                //TODO need to refresh the data in the cart

                                                var val = 0;

                                                ApiCalls.readCounter(
                                                        customerGuid: ConstantsVar
                                                            .prefs
                                                            .getString(
                                                                'guestGUID')!)
                                                    .then((value) {
                                                  setState(() {
                                                    val = value;
                                                  });
                                                  context
                                                      .read<cartCounter>()
                                                      .changeCounter(val);
                                                  widget.reload();
                                                });

                                                // widget.updateUi;
                                              });
                                            } else {
                                              setState(() {
                                                widget.quantity =
                                                    widget.quantity - 1;

                                                print('${widget.quantity}');
                                              });
                                              ApiCalls.updateCart(
                                                      widget.id,
                                                      '${widget.quantity}',
                                                      widget.itemID,
                                                      context)
                                                  .then((value) {
                                                var val = 0;

                                                ApiCalls.readCounter(
                                                        customerGuid: ConstantsVar
                                                            .prefs
                                                            .getString(
                                                                'guestGUID')!)
                                                    .then((value) {
                                                  setState(() {
                                                    val = value;
                                                  });
                                                  context
                                                      .read<cartCounter>()
                                                      .changeCounter(val);
                                                });

                                                widget.updateUi();
                                                widget.reload();
                                              });
                                            }
                                          });
                                        },
                                        child: Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(6.0)),
                                          // color: Colors.red,
                                          child: Icon(
                                            Icons.remove,
                                            size: 24,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Container(
                                        color: Colors.grey.shade200,
                                        padding: const EdgeInsets.only(
                                            bottom: 2, right: 12, left: 12),
                                        child: AutoSizeText(
                                          "${widget.quantity2}",
                                          style: CustomTextStyle
                                              .textFormFieldSemiBold,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      InkWell(
                                        radius: 36,
                                        onTap: () async {
                                          print('SomeOne Tap on Me');
                                          if (widget.quantity < 11) {
                                            SchedulerBinding.instance!
                                                .addPostFrameCallback(
                                                    (timeStamp) {
                                              setState(() {
                                                widget.quantity =
                                                    widget.quantity + 1;

                                                ApiCalls.updateCart(
                                                        widget.id,
                                                        widget.quantity
                                                            .toString(),
                                                        widget.itemID,
                                                        context)
                                                    .then((value) {
                                                  var val = 0;

                                                  ApiCalls.readCounter(
                                                          customerGuid: ConstantsVar
                                                              .prefs
                                                              .getString(
                                                                  'guestGUID')!)
                                                      .then((value) {
                                                    setState(() {
                                                      val = value;
                                                    });
                                                    context
                                                        .read<cartCounter>()
                                                        .changeCounter(val);
                                                  });

                                                  widget.reload();
                                                });
                                              });
                                            });
                                            print('${widget.quantity}');
                                            // });
                                          } else {
                                            Fluttertoast.showToast(
                                                msg:
                                                    'Quantity cannot be exceeds 11');
                                          }
                                        },
                                        child: Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(6.0)),
                                          child: Icon(
                                            Icons.add,
                                            size: 22,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    flex: 100,
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                radius: 36,
                onTap: () {
                  // showpopup();
                  ApiCalls.deleteCartItem(widget.id, widget.itemID, context)
                      .then((value) {
                    var val = 0;

                    ApiCalls.readCounter(
                            customerGuid:
                                ConstantsVar.prefs.getString('guestGUID')!)
                        .then((value) {
                      setState(() {
                        val = value;
                      });
                      context.read<cartCounter>().changeCounter(val);
                      widget.reload();
                    });

                    Fluttertoast.showToast(msg: 'Removed from Cart');
                  });
                },
                child: Container(
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(right: 10, top: 8),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 20,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      color: Colors.black),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
