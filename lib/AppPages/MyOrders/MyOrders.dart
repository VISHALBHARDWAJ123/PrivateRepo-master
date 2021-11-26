import 'dart:io' show Platform;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:progress_loading_button/progress_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:untitled2/AppPages/CartxxScreen/ConstantVariables.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/MyAccount/MyAccount.dart';
import 'package:untitled2/AppPages/ReturnScreen/ReturnScreen.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/Widgets/CustomButton.dart';
import 'package:untitled2/utils/utils/build_config.dart';

import 'OrderDetails.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({Key? key, required this.isFromWeb}) : super(key: key);
  final bool isFromWeb;

  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> with WidgetsBindingObserver {
  var apiToken;
  var customerId;
  var orders = {};
  var orderDate;

  bool isVisible = true;

  Future getOrder(String apiToken, String customerId) async {
    context.loaderOverlay
        .show(widget: SpinKitRipple(color: Colors.red, size: 90));
    // setState(() => isVisible == true);
    final uri = Uri.parse(BuildConfig.base_url +
        'apis/GetCustomerOrderList?apiToken=$apiToken&customerid=$customerId');
    print(uri);

    var response = await get(uri);
    try {
      var result = jsonDecode(response.body);
      context.loaderOverlay.hide();
      return result;
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      context.loaderOverlay.hide();
      print(e.toString);
      // Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance!.addObserver(this);
    getInit().whenComplete(() {
      setState(() {
        isVisible = true;
      });
      getOrder(apiToken, customerId).then((value) => setState(() {
            orders = value;
            orders['customerorders']['Orders']!.length > 0
                ? setState(() => isVisible == false)
                : setState(() => isVisible == true);
          }));
    });
  }

  var _color;
  bool _willGo = true;

  @override
  Widget build(BuildContext context) {
    Future<bool> _willGoBack() async {
      Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (context) => MyAccount()),
          (route) => false);
      setState(() {
        _willGo = true;
      });
      return _willGo;
    }

    return WillPopScope(
      onWillPop: _willGo ? _willGoBack : () async => false,
      child: SafeArea(
          top: true,
          bottom: true,
          maintainBottomViewPadding: true,
          child: Scaffold(
            appBar: new AppBar(
              leading: Platform.isAndroid
                  ? InkWell(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => MyAccount()),
                            (route) => false);
                      },
                      child: Icon(Icons.arrow_back))
                  : InkWell(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => MyAccount()),
                            (route) => false);
                      },
                      child: Icon(Icons.arrow_back_ios)),
              backgroundColor: ConstantsVar.appColor,
              toolbarHeight: 18.w,
              centerTitle: true,
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
            body: orders.isEmpty
                ? Container(
                    child: Center(
                      child: SpinKitRipple(
                        color: Colors.red,
                        size: 90,
                      ),
                    ),
                  )
                : Container(
                    width: 100.w,
                    height: 100.h,
                    child: Stack(
                      children: [
                        Container(
                          width: 100.w,
                          height: 100.h,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Container(
                                  width: 100.w,
                                  child: Center(
                                    child: AutoSizeText(
                                      'MY ORDERS',
                                      style: TextStyle(
                                        fontSize: 8.5.w,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: isVisible,
                                child: Expanded(
                                  child: ListView(
                                    children: List.generate(
                                      orders['customerorders']!['Orders']!
                                          .length,
                                      (index) {
                                        if (orders['customerorders']['Orders']
                                                .length <
                                            0) {
                                          return Container(
                                              child: AutoSizeText(
                                                  'No Orders found.'));
                                        } else {
                                          orderDate =
                                              '${orders['customerorders']['Orders'][index]['CreatedOn']}';
                                          var resultDate = orderDate
                                              .toString()
                                              .replaceAll('T', '  ')
                                              .toString()
                                              .splitBefore('.');
                                          if (orders['customerorders']['Orders']
                                                  [index]['OrderStatus']
                                              .toString()
                                              .contains('Pending')) {
                                            setState(() =>
                                                _color = Colors.amberAccent);
                                          } else if (orders['customerorders']
                                                      ['Orders'][index]
                                                  ['OrderStatus']
                                              .toString()
                                              .contains('Cancelled')) {
                                            setState(() => _color = Colors.red);
                                          } else {
                                            setState(
                                                () => _color = Colors.green);
                                          }
                                          bool isReturnAvail =
                                              orders['customerorders']['Orders']
                                                      [index]
                                                  ['IsReturnRequestAllowed'];
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4.0),
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                  // borderRadius:
                                                  ),
                                              child: Container(
                                                // height: 35.h,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 3.0,
                                                        vertical: 2),
                                                child: Container(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Center(
                                                        child: AutoSizeText(
                                                          '\nORDER NUMBER\n ' +
                                                              orders['customerorders']
                                                                              [
                                                                              'Orders']
                                                                          [
                                                                          index]
                                                                      [
                                                                      'CustomOrderNumber']
                                                                  .toString()
                                                                  .toUpperCase(),
                                                          // maxLines: 1,
                                                          textAlign:
                                                              TextAlign.center,
                                                          textDirection:
                                                              TextDirection.ltr,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          softWrap: true,
                                                          // textAlign: TextAlign.center,
                                                          style: CustomTextStyle
                                                              .textFormFieldBold
                                                              .copyWith(
                                                                  fontSize:
                                                                      5.5.w),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 10),
                                                        height: 30.w,
                                                        width: 100.w,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            Container(
                                                              child: RichText(
                                                                text: TextSpan(
                                                                  text:
                                                                      'Order Status: ',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        5.w,
                                                                    // fontWeight:
                                                                    //     FontWeight.bold,
                                                                  ),
                                                                  children: <
                                                                      TextSpan>[
                                                                    TextSpan(
                                                                      text: orders['customerorders']['Orders'][index]
                                                                              [
                                                                              'OrderStatus']
                                                                          .toString()
                                                                          .toUpperCase(),
                                                                      style:
                                                                          TextStyle(
                                                                        color:
                                                                            _color,
                                                                        fontSize:
                                                                            5.w,
                                                                        fontWeight:
                                                                            FontWeight.bold,

                                                                        // fontWeight:
                                                                        //     FontWeight
                                                                        //         .bold,
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Utils.getSizedBox(
                                                                null, 3),
                                                            Container(
                                                                child:
                                                                    AutoSizeText(
                                                              'Order Date: ' +
                                                                  resultDate,
                                                              style: TextStyle(
                                                                fontSize: 5.w,

                                                                // fontWeight:
                                                                //     FontWeight.bold,
                                                              ),
                                                            )),
                                                            Utils.getSizedBox(
                                                                null, 3),
                                                            Container(
                                                              child:
                                                                  AutoSizeText(
                                                                'Order Total: ' +
                                                                    orders['customerorders']['Orders']
                                                                            [
                                                                            index]
                                                                        [
                                                                        'OrderTotal'],
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 5.w,

                                                                  // fontWeight:
                                                                  //     FontWeight.bold,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      Container(
                                                        color: ConstantsVar
                                                            .appColor,
                                                        width: 100.w,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            horizontal: 4.0,
                                                            vertical: 4.0,
                                                          ),
                                                          child: LoadingButton(
                                                            loadingWidget:
                                                                SpinKitCircle(
                                                              color:
                                                                  Colors.white,
                                                              size: 30,
                                                            ),
                                                            color: ConstantsVar
                                                                .appColor,
                                                            defaultWidget:
                                                                AutoSizeText(
                                                              'Details'
                                                                  .toUpperCase(),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 4.4.w,
                                                              ),
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              print(
                                                                  '${orders['customerorders']['Orders'][index]['CustomOrderNumber'].toString()}');
                                                              await getOderDetails(
                                                                      orderid: orders['customerorders']['Orders'][index]
                                                                              [
                                                                              'Id']
                                                                          .toString(),
                                                                      apiToekbn:
                                                                          apiToken,
                                                                      customerId:
                                                                          customerId)
                                                                  .then(
                                                                (value) =>
                                                                    Navigator
                                                                        .push(
                                                                  context,
                                                                  CupertinoPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            OrderDetails(
                                                                      orderNumber:
                                                                          '\nORDER  # ${orders['customerorders']['Orders'][index]['CustomOrderNumber'].toString()}',
                                                                      orderProgress:
                                                                          orders['customerorders']['Orders'][index]
                                                                              [
                                                                              'OrderStatus'],
                                                                      orderTotal:
                                                                          'Order Total: ' +
                                                                              orders['customerorders']['Orders'][index]['OrderTotal'],
                                                                      orderDate:
                                                                          'Order Date: ' +
                                                                              resultDate,
                                                                      color:
                                                                          _color,
                                                                      resultas:
                                                                          value,
                                                                      orderId: orders['customerorders']['Orders'][index]
                                                                              [
                                                                              'Id']
                                                                          .toString(),
                                                                      apiToken:
                                                                          apiToken,
                                                                      customerId:
                                                                          customerId,
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      Visibility(
                                                        visible: isReturnAvail,
                                                        child: SizedBox(
                                                          height: 15,
                                                        ),
                                                      ),
                                                      Visibility(
                                                        visible: isReturnAvail,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Center(
                                                            child: AppButton(
                                                              color:
                                                                  ConstantsVar
                                                                      .appColor,
                                                              child: Container(
                                                                width: 100.w,
                                                                height: 2.7.h,
                                                                child: Center(
                                                                  child:
                                                                      AutoSizeText(
                                                                    'Return',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          4.4.w,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              onTap: () async {
                                                                print(
                                                                    '${orders['customerorders']['Orders'][index]['Id'].toString()}');
                                                                Navigator.push(
                                                                  context,
                                                                  CupertinoPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            ReturnScreen(
                                                                      orderId: orders['customerorders']['Orders'][index]
                                                                              [
                                                                              'Id']
                                                                          .toString(),
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          )),
    );
  }

  Future getOderDetails({
    required String orderid,
    required String apiToekbn,
    required String customerId,
  }) async {
    print('Order Id =====>>>>>>> ' + orderid);
    context.loaderOverlay.show(
        widget: SpinKitRipple(
      color: Colors.red,
      size: 90,
    ));
    final uri = Uri.parse(BuildConfig.base_url +
        "apis/GetCustomerOrderDetail?apiToken=${apiToken}&customerId=${customerId}&orderid=${orderid}");
    print(uri);
    var response = await get(uri);

    try {
      var result = jsonDecode(response.body);
      // print(result);

      context.loaderOverlay.hide();
      return result;
    } on Exception catch (e) {
      print(e.toString());

      context.loaderOverlay.hide();
    }
  }

  Future getInit() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
    setState(() {
      apiToken = ConstantsVar.prefs.getString('apiTokken');
      customerId = ConstantsVar.prefs.getString('guestCustomerID');
    });
  }
}
