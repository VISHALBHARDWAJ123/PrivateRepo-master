import 'package:loader_overlay/loader_overlay.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/AppPages/CartxxScreen/ConstantVariables.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/Widgets/CustomButton.dart';
import 'package:untitled2/utils/utils/build_config.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({Key? key}) : super(key: key);

  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
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
    var response = await get(uri);
    try {
      var result = jsonDecode(response.body);
      print(result);
      context.loaderOverlay
          .hide();
      return result;
    } on Exception catch (e) {
      context.loaderOverlay
          .hide();
      print(e.toString);
      // Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState

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
      super.initState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
          appBar: new AppBar(
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
          body: Container(
            width: 100.w,
            height: 100.h,
            child: Stack(
              children: [
                Visibility(
                  visible: isVisible,
                  child: Container(
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
                        Expanded(
                          child: ListView(
                            children: List.generate(
                                orders['customerorders']['Orders']!.length,
                                (index) {

                                  if(orders['customerorders']['Orders'].length <0){
                                    return Container(child:Text('No Orders found.'));
                                  }else{


                                  orderDate =
                                  '${orders['customerorders']['Orders'][index]['CreatedOn']}';
                              var resultDate =
                                  orderDate.toString().replaceAll('T', '  ');








                              return Container(
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  color: Colors.white,
                                  child: Container(
                                    height: 28.h,
                                    margin: EdgeInsets.only(
                                      left: 10,
                                      right: 10,
                                      bottom: 3.2,
                                    ),
                                    child: Container(
                                      // padding: const EdgeInsets.all(4.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Center(
                                            child: Text(
                                              '\nORDER NUMBER: \n ' +
                                                  orders['customerorders']
                                                              ['Orders'][index]
                                                          ['CustomOrderNumber']
                                                      .toString(),
                                              // maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                              // textAlign: TextAlign.center,
                                              style: CustomTextStyle
                                                  .textFormFieldBold
                                                  .copyWith(fontSize: 5.5.w),
                                            ),
                                          ),
                                          Utils.getSizedBox(null, 3),
                                          Container(
                                            child: Text(
                                              'Order Status: ' +
                                                  orders['customerorders']
                                                          ['Orders'][index]
                                                      ['OrderStatus'],
                                              style: TextStyle(
                                                fontSize: 4.w,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Container(
                                              child: Text(
                                            'Order created: ' + resultDate,
                                            style: TextStyle(
                                              fontSize: 4.w,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )),
                                          Container(
                                            child: Text(
                                              'Order Total: ' +
                                                  orders['customerorders']
                                                          ['Orders'][index]
                                                      ['OrderTotal'],
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 4.w,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }}),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future getInit() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
    setState(() {
      apiToken = ConstantsVar.prefs.getString('apiTokken');
      customerId = ConstantsVar.prefs.getString('guestCustomerID');
    });
  }
}
