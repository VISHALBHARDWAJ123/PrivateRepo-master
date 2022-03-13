import 'dart:async';
import 'dart:io' show Platform;

import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/MyOrders/MyOrders.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/utils/ApiCalls/CategoryModel.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentPage extends StatefulWidget {
  PaymentPage({Key? key, required this.paymentUrl}) : super(key: key);
  String paymentUrl;

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> with WidgetsBindingObserver {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  var progressCount;
  bool isLoading = true;
  bool _willGo = true;

  var _opacity = 1.0;

  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    WidgetsBinding.instance!.addObserver(this);
    secureScreen();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        setState(() {
          _opacity = 0.0;
        });
        break;
      case AppLifecycleState.resumed:
        setState(() {
          _opacity = 1.0;
        });
        break;
    case AppLifecycleState.paused:
        setState(() {
          _opacity = 0.0;
        });
        break;
    }
  }

  @override
  void dispose() {
    disposeSecureScreen();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _willGoBack() async {
      Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(
              builder: (context) => MyOrders(
                    isFromWeb: true,
                  )),
          (route) => false);
      setState(() {
        _willGo = true;
      });
      return _willGo;
    }

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (currentFocus.hasFocus) {
          setState(() {
            currentFocus.unfocus();
          });
        }
      },
      child: SafeArea(
        top: true,
        bottom: true,
        maintainBottomViewPadding: true,
        child: WillPopScope(
          onWillPop: _willGo ? _willGoBack : () async => false,
          child: Scaffold(
            appBar: new AppBar(
              leading: Platform.isAndroid
                  ? InkWell(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => MyOrders(
                                      isFromWeb: true,
                                    )),
                            (route) => false);
                      },
                      child: Icon(Icons.arrow_back))
                  : InkWell(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => MyOrders(
                                      isFromWeb: true,
                                    )),
                            (route) => false);
                      },
                      child: Icon(Icons.arrow_back_ios)),
              backgroundColor: ConstantsVar.appColor,
              toolbarHeight: 18.w,
              centerTitle: true,
              title: GestureDetector(
                onTap: () {
                  context.loaderOverlay.hide();
                  Navigator.pushAndRemoveUntil(context,
                      CupertinoPageRoute(builder: (context) {
                    return MyApp();
                  }), (route) => false);
                },
                child: Image.asset(
                  'MyAssets/logo.png',
                  width: 15.w,
                  height: 15.w,
                ),
              ),
            ),
            body: Stack(
              children: <Widget>[
                Opacity(
                  opacity: _opacity,
                  child: WebView(
                    initialUrl: widget.paymentUrl,
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (WebViewController webViewController) {
                      _controller.complete(webViewController);
                    },
                    onProgress: (int progress) {
                      setState(() {
                        isLoading = true;
                        progressCount = progress;
                      });
                    },
                    javascriptChannels: <JavascriptChannel>{
                      _toasterJavascriptChannel(context),
                    },
                    navigationDelegate: (NavigationRequest request) {
                      if (request.url.contains(
                          "https://secureacceptance.cybersource.com/billing")) {
                        FacebookAppEvents().logPurchase(
                            amount: 0.0, currency: CurrencyCode.AED.name);
                        return NavigationDecision.navigate;
                      }
                      if (request.url.startsWith('https://www.youtube.com/')) {
                        print('blocking navigation to $request}');
                        return NavigationDecision.prevent;
                      }
                      print('allowing navigation to $request');
                      return NavigationDecision.navigate;
                    },
                    onPageStarted: (String url) {
                      setState(() {
                        _willGo = false;
                        isLoading = true;
                      });

                      print('Page started loading: $url');
                    },
                    onPageFinished: (String url) {
                      print('Page finished loading: $url');
                      setState(() {
                        _willGo = true;
                        isLoading = false;
                      });
                    },
                    gestureNavigationEnabled: true,
                  ),
                ),
                isLoading
                    ? Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            SpinKitRipple(
                              color: Colors.red,
                              size: 90,
                            ),
                            Text('Loading Please Wait!.........' +
                                progressCount.toString() +
                                '%'),
                          ],
                        ))
                    : Stack(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

  Future<void> disposeSecureScreen() async {
    await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
  }
}
