import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/AppPages/CartxxScreen/ConstantVariables.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/Widgets/CustomButton.dart';
import 'package:untitled2/utils/CartBadgeCounter/CartBadgetLogic.dart';
import 'package:untitled2/utils/utils/build_config.dart';

import 'Response/OrderResponse.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({Key? key}) : super(key: key);

  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  var apiToken;

  var customerId;

  @override
  void initState() {
    getIds().whenComplete(
        () => context.read<cartCounter>().getOrder(apiToken, customerId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      child: Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          toolbarHeight: 18.w,
          title: InkWell(
            onTap: () => Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(
                  builder: (context) => MyApp(),
                ),
                (route) => false),
            child: Image.asset(
              'MyAssets/logo.png',
              width: 15.w,
              height: 15.w,
            ),
          ),
        ),
        body: Consumer<cartCounter>(
          builder: (context, value, child) {
            if (value.respone == null) {
              return Container(
                child:
                    Center(child: SpinKitRipple(color: Colors.red, size: 90)),
              );
            } else {
              return OrderWidget(
                myOrders: value.respone!,
              );
            }
          },
        ),
      ),
    );
  }

  Future getIds() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        apiToken = ConstantsVar.prefs.getString('apiTokken');
        customerId = ConstantsVar.prefs.getString('guestCustomerID');
      });
      print(apiToken + '   ' + customerId);
    }
  }
}

class OrderWidget extends StatefulWidget {
  OrderWidget({Key? key, required this.myOrders}) : super(key: key);
  Customerorders myOrders;

  @override
  _OrderWidgetState createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  @override
  Widget build(BuildContext context) {
    return buildContainer(widget.myOrders);
  }

  Widget buildContainer(Customerorders myOrders) {
    if (myOrders.orders.length > 0 || myOrders.orders != null) {
      return Container(
        width: 100.w,
        height: 100.h,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: 100.w,
                child: Center(
                  child: Text(
                    'MY ORDERS',
                    style: TextStyle(
                      fontSize: 8.5.w,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            ListView(
              children: List.generate(
                  widget.myOrders.orders.length,
                  (index) => Container(
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: Colors.white,
                          child: Container(
                            height: 25.h,
                            margin: EdgeInsets.only(
                              left: 10,
                              right: 10,
                              bottom: 3.2,
                            ),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    // padding: const EdgeInsets.all(4.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          padding:
                                              EdgeInsets.only(right: 8, top: 4),
                                          child: Text(
                                            widget.myOrders.orders[index]
                                                .customOrderNumber,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true,
                                            style: CustomTextStyle
                                                .textFormFieldBold
                                                .copyWith(fontSize: 16),
                                          ),
                                        ),
                                        Utils.getSizedBox(null, 6),
                                        Container(
                                          child: Text(widget.myOrders
                                              .orders[index].orderTotal),
                                        ),
                                        Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Flexible(
                                                child: Text(
                                                  widget.myOrders.orders[index]
                                                      .orderTotal,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )),
            )
          ],
        ),
      );
    } else {
      return Container(
        child: Center(
          child: Text('No Orders!.'),
        ),
      );
    }
  }
}
