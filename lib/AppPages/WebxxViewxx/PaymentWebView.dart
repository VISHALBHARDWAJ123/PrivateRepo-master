import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentPage extends StatefulWidget {
  PaymentPage({Key? key, required this.paymentUrl}) : super(key: key);
  String paymentUrl;

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  var progressCount;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
      context.loaderOverlay.show(
          widget: SpinKitRipple(
        color: Colors.red,
        size: 90,
      ));
    } else {
      context.loaderOverlay.show(widget: CupertinoActivityIndicator());
    }
  }

  @override
  Widget build(BuildContext context) {
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
        child: WillPopScope(
          onWillPop: _willPopUp,
          child: Scaffold(
            appBar: new AppBar(
              toolbarHeight: 18.w,
              centerTitle: true,
              title: GestureDetector(
                onTap: () => Navigator.pushAndRemoveUntil(context,
                    CupertinoPageRoute(builder: (context) {
                  return MyApp();
                }), (route) => false),
                child: Image.asset(
                  'MyAssets/logo.png',
                  width: 15.w,
                  height: 15.w,
                ),
              ),
            ),
            body: WebView(
              initialUrl: widget.paymentUrl,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              onProgress: (int progress) {
                setState(() {
                  progressCount = progress;
                });
              },
              javascriptChannels: <JavascriptChannel>{
                _toasterJavascriptChannel(context),
              },
              navigationDelegate: (NavigationRequest request) {
                if (request.url.startsWith('https://www.youtube.com/')) {
                  print('blocking navigation to $request}');
                  return NavigationDecision.prevent;
                }
                print('allowing navigation to $request');
                return NavigationDecision.navigate;
              },
              onPageStarted: (String url) {
                context.loaderOverlay.show(
                    widget: SpinKitRipple(
                      color: Colors.red,
                      size: 90,
                    ));
                print('Page started loading: $url');
              },
              onPageFinished: (String url) {
                print('Page finished loading: $url');
                setState(() {
                  context.loaderOverlay.hide();
                });
              },
              gestureNavigationEnabled: true,
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _willPopUp() async {
    Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(builder: (context) => MyHomePage()),
        (route) => false);
    return true;
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
}
