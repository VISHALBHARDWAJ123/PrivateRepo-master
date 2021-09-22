import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:untitled2/AppPages/CartxxScreen/ConstantVariables.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/ShippingxxMethodxx/Responsexx/SelectxxShippingxxResponse.dart';
import 'package:untitled2/AppPages/ShippingxxMethodxx/Responsexx/ShippingxxMethodxxResponse.dart';
import 'package:untitled2/AppPages/WebxxViewxx/PaymentWebView.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';
import 'package:untitled2/utils/utils/build_config.dart';

class ShippingMethod extends StatefulWidget {
  const ShippingMethod(
      {Key? key, required this.customerId, required this.paymentUrl})
      : super(key: key);
  final customerId;
  final paymentUrl;

  @override
  _ShippingMethodState createState() => _ShippingMethodState();
}

class _ShippingMethodState extends State<ShippingMethod> {
  var warning;
  List<MethodList> shippingMethods = [];
  bool isSelected = false;
  var selectedVal = '';

  @override
  void initState() {
    super.initState();
    getInitSharedPrefs().then((value) => getShippingMethods(widget.customerId));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        appBar: new AppBar(
            toolbarHeight: Adaptive.w(18),
            centerTitle: true,
            title: InkWell(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  CupertinoPageRoute(builder: (context) => MyHomePage()),
                  (route) => false,
                );
              },
              radius: 60.0,
              child: Image.asset(
                'MyAssets/logo.png',
                width: Adaptive.w(15),
                height: Adaptive.w(15),
              ),
            )),
        body: CustomScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Container(
                        width: double.infinity,
                        height: 60,
                        color: Colors.white60,
                        child: Center(
                          child: Text(
                            'Select Shipping Method'.toUpperCase(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: Adaptive.w(5)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ListView.builder(
                    padding: EdgeInsets.all(10),
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: shippingMethods.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: Container(
                          child: CheckboxListTile(
                            value: isSelected,
                            onChanged: (bool? value) {
                              setState(() {
                                if (isSelected) {
                                  selectedVal = '';
                                  isSelected = value!;
                                  print('${selectedVal}');

                                  print('${isSelected}');
                                } else {
                                  isSelected = value!;
                                  selectedVal = shippingMethods[index].name +
                                      '___' +
                                      shippingMethods[index]
                                          .shippingRateComputationMethodSystemName;
                                  print('${isSelected}');
                                  print('${selectedVal}');
                                }
                              });
                            },
                            tileColor: Colors.white24,
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Center(
                              child: Text(
                                shippingMethods[index].name,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 6.w),
                              ),
                            ),
                            subtitle: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                  removeAllHtmlTags(
                                      shippingMethods[index].description),
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(fontSize: 4.w)),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () async {
                    context.loaderOverlay.show(
                        widget: SpinKitRipple(
                      color: Colors.red,
                      size: 90,
                    ));
                    if (isSelected == false) {
                      Fluttertoast.showToast(
                          msg: 'Please select a Shipping Method first');
                      context.loaderOverlay.hide();
                    } else {
                      selectShippingMethod();
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    color: ConstantsVar.appColor,
                    child: Center(
                      child: Text(
                        'Confirm'.toUpperCase(),
                        style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> getShippingMethods(String customerId) async {
    context.loaderOverlay.show(
      widget: Center(
        child: SpinKitRipple(
          color: Colors.red,
          size: 90,
        ),
      ),
    );
    final uri = Uri.parse(BuildConfig.base_url +
        'apis/GetShippingMethod?apiToken=${ConstantsVar.apiTokken}&customerid=$customerId');
    try {
      print('Shipping method Apis >>>>>> $uri');
      var response = await http.get(uri);
      print(jsonDecode(response.body));
      ShippingMethodResponse methodResponse =
          ShippingMethodResponse.fromJson(jsonDecode(response.body));
      setState(() {
        shippingMethods.addAll(methodResponse.shippingmethods.shippingMethods);
      });
      context.loaderOverlay.hide();
    } on Exception catch (e) {
      context.loaderOverlay.hide();

      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future getInitSharedPrefs() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
  }

  Future selectShippingMethod() async {
    final uri = Uri.parse(BuildConfig.base_url +
        'apis/SelectShippingMethodForApp?apiToken=${ConstantsVar.apiTokken}&customerId=${widget.customerId}&shippingoption=$selectedVal');
    print(uri);
    try {
      var response = await http.get(uri);
      print(jsonDecode(response.body));
      SelectShippingMethodResponse reult =
          SelectShippingMethodResponse.fromJson(jsonDecode(response.body));
      var status = reult.status;
      if (status == 'Success') {
        context.loaderOverlay.hide();
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) =>
                    PaymentPage(paymentUrl: widget.paymentUrl)));
      } else {
        Fluttertoast.showToast(msg: status);

        context.loaderOverlay.hide();
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: e.toString());

      context.loaderOverlay.hide();
    }
  }

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return htmlText.replaceAll(exp, '');
  }
}
