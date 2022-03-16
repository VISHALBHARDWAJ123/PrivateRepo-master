//import 'dart:html';
// Import package
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:device_info_plus/device_info_plus.dart';

// import 'package:facebook_event/facebook_event.dart';
// import 'dart:convert';
import 'package:freerasp/talsec_app.dart';
import 'package:nb_utils/nb_utils.dart';

// import '../LoginScreen/LoginScreen.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';

// import 'package:untitled2/AppPages/SplashScreen/GuestxxResponsexx/GuestResponsexx.dart';
import 'package:untitled2/AppPages/SplashScreen/TokenResponse/TokenxxResponsexx.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';
import 'package:untitled2/utils/CartBadgeCounter/CartBadgetLogic.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  /// String to hold current state (common)
  String _debuggerState = 'Secured';

  String name = "MyAssets/logo.png";
  var _guestCustomerID;
  var _guestGUID;
  var permGranted = "granted";
  var permDenied = "denied";
  var permUnknown = "unknown";
  var permProvisional = "provisional";
  bool shouldScaleDown = true; // c
  final width = 200.0;
  final height = 300.0;
  late AnimationController animationController;
  var animation;

  var isVisible = false;

  Future initilaize() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
    try {
      // If the system can show an authorization request dialog
      if (await AppTrackingTransparency.trackingAuthorizationStatus ==
          TrackingStatus.notDetermined) {
        // Request system's tracking authorization dialog
        await AppTrackingTransparency.requestTrackingAuthorization();
      }
    } on PlatformException {
      // Unexpected exception was thrown
      Fluttertoast.showToast(msg: 'Something Went Wrong');
    }
    if (ConstantsVar.prefs.getStringList('RecentProducts') == null) {
      ConstantsVar.prefs.setStringList('RecentProducts', []);
    }
    // setState(())
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance!.addPostFrameCallback((_) => initPlugin());
    initSecurityState().whenComplete(() {
      animationController = new AnimationController(
          vsync: this, duration: new Duration(seconds: 3));
      animation = new CurvedAnimation(
          parent: animationController, curve: Curves.easeOut);

      animation.addListener(() => this.setState(() {}));
      animationController.forward();
      getCheckNotificationPermStatus();
      Future.delayed(
        Duration(seconds: 2, milliseconds: 80),
      ).then((value) => setState(() => isVisible = true));
      initilaize().then((value) {
        _guestCustomerID = ConstantsVar.prefs.getString('guestCustomerID');
        print('init');
        print('$_guestCustomerID');
        if (_guestCustomerID == null ||
            _guestCustomerID == '' ||
            _guestCustomerID.toString().isEmpty) {
          print('guestCustomerID is null');
          ApiCalls.getApiTokken(context).then((value) {
            TokenResponse myResponse = TokenResponse.fromJson(value);
            _guestCustomerID = myResponse.cutomer.customerId;
            _guestGUID = myResponse.cutomer.customerGuid;
            ConstantsVar.prefs
                .setString('guestCustomerID', '$_guestCustomerID');
            ConstantsVar.prefs.setString('guestGUID', _guestGUID);
            ConstantsVar.prefs.setString('sepGuid', _guestGUID!);
            int val = 0;
            Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                  builder: (context) => MyApp(),
                ));
          }
              // },
              );
        } else {
          int val = 0;
          getCartBagdge().then(
            (value) => Future.delayed(
              Duration(seconds: 4),
              () => Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                  builder: (context) => MyApp(),
                ),
              ),
            ),
          );
        }
      }).then((value) => null);
    });

    // // } else {
    // }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: FlutterSizer(
        builder: (context, orientation, screenType) {
          return Scaffold(
            body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: animation.value * width,
                    height: animation.value * height,
                    child: Hero(
                      tag: 'HomeImage',
                      child: Image.asset(name),
                      transitionOnUserGestures: true,
                      placeholderBuilder: (context, _, widget) {
                        return Container(
                          height: 15.w,
                          width: 15.w,
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  ),
                  SpinKitRipple(
                    color: Colors.red,
                    size: 60,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future getCustomerId() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
    if (ConstantsVar.prefs.getString('userId') != null) {
      ConstantsVar.customerID = ConstantsVar.prefs.getString('userId')!;
    }

    return ConstantsVar.customerID;
  }

  Future getCartBagdge() async {
    int val = 0;
    Future.delayed(
        Duration(seconds: 3),
        () => ApiCalls.readCounter(
                    customerGuid: ConstantsVar.prefs.getString('guestGUID')!)
                .then((value) {
              if (mounted)
                setState(() {
                  val = value;
                  context.read<cartCounter>().changeCounter(val);
                });
            }));
  }

  /// Checks the notification permission status
  Future<String> getCheckNotificationPermStatus() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    return NotificationPermissions.getNotificationPermissionStatus()
        .then((status) {
      switch (status) {
        case PermissionStatus.denied:
          return permDenied;
        case PermissionStatus.granted:
          return permGranted;
        case PermissionStatus.unknown:
          requestPermission();
          return permUnknown;
        case PermissionStatus.provisional:
          return permProvisional;
        default:
          return '';
      }
    });
  }

  Future<bool> showCustomTrackingDialog(BuildContext context) async =>
      await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Dear User'),
          content: const Text(
            'We care about your privacy and data security. '
            'Can we continue to use your data to tailor best recommendations for you?\n\nYou can change your choice anytime in the app settings. '
            'Our partners will collect data and use a unique identifier on your device to show you best recommendations.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("I'll decide later"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Allow tracking'),
            ),
          ],
        ),
      ) ??
      false;

  requestPermission() async {
    await NotificationPermissions.requestNotificationPermissions();
  }

  Future<void> initPlugin() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final TrackingStatus status =
          await AppTrackingTransparency.trackingAuthorizationStatus;

      // If the system can show an authorization request dialog
      if (status == TrackingStatus.notDetermined) {
        await AppTrackingTransparency.requestTrackingAuthorization();
        // Show a custom explainer dialog before the system dialog

      }
    } on PlatformException {
      Fluttertoast.showToast(msg: 'Something went wrong');
    }
  }

  // void getHashKey()async{
  //   var hashKey= await FacebookEvent().getAndroidHashKey();
  //   print('Android Hash Key'+hashKey!);
  // }
  Future<void> initSecurityState() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    print('init security');
    if (await FlutterJailbreakDetection.developerMode) {
      ApiCalls.sendAnalytics(
              map: {'device_information': deviceInfoPlugin.deviceInfo},
              eventName: 'developer_mode')
          .whenComplete(() => Fluttertoast.showToast(
                  msg:
                      'Developer Mode is on. Cannot run this app on this device.')
              .then((value) => Future.delayed(Duration(seconds: 2))
                  .whenComplete(() => FirebaseCrashlytics.instance.crash())));
    }

    /// Provide TalsecConfig your expected data and then use them in TalsecApp
    TalsecConfig config = TalsecConfig(
      /// For Android
      androidConfig: AndroidConfig(
        expectedPackageName: 'com.theone.androidtheone',
        expectedSigningCertificateHash: 'eLqz+HNqpo7ayE7MUrzsffPyqTc=',
      ),

      /// For iOS
      iosConfig: IOSconfig(
        appBundleId: 'com.dev.theone',
        appTeamId: '4TD6VF2SFJ',
      ),

      watcherMail: 'vishal.matrid2380@gmail.com',
    );

    /// Callbacks thrown by library

    TalsecCallback callback = TalsecCallback(
      /// For Android
      androidCallback: AndroidCallback(onRootDetected: () async {
        ApiCalls.sendAnalytics(
                map: {'device_information': deviceInfoPlugin.deviceInfo},
                eventName: 'rooted_device')
            .whenComplete(() => Fluttertoast.showToast(
                    msg:
                        'Your Device is rooted. Cannot run this app on this device.',
                    toastLength: Toast.LENGTH_LONG)
                .then((value) => Future.delayed(Duration(seconds: 2))
                    .whenComplete(() => FirebaseCrashlytics.instance.crash())));
      }, onEmulatorDetected: () {
        print('Emulator detected');
        ApiCalls.sendAnalytics(
                map: {'device_information': deviceInfoPlugin.deviceInfo},
                eventName: 'emulator_device')
            .whenComplete(() => Fluttertoast.showToast(
                    msg:
                        'Your Device is an emulator. Cannot run this app on this device.')
                .then((value) => Future.delayed(Duration(seconds: 2))
                    .whenComplete(() => FirebaseCrashlytics.instance.crash())));
      }, onHookDetected: () {
        print('Hooking detected');
        ApiCalls.sendAnalytics(
                map: {'device_information': deviceInfoPlugin.deviceInfo},
                eventName: 'hooking_detected')
            .whenComplete(() => Fluttertoast.showToast(
                    msg:
                        'Hooking Process is detected. Cannot run this app on this device.')
                .then((value) => Future.delayed(Duration(seconds: 2))
                    .whenComplete(() => FirebaseCrashlytics.instance.crash())));
      }, onTamperDetected: () {
        ApiCalls.sendAnalytics(map: {
          'device_information': deviceInfoPlugin.deviceInfo,
          'reason': 'may be developer mode is on.'
        }, eventName: 'tamper_detection');
      }, onDeviceBindingDetected: () {
        setState(() {});
      }, onUntrustedInstallationDetected: () {
        ApiCalls.sendAnalytics(
                map: {'device_information': deviceInfoPlugin.deviceInfo},
                eventName: 'untrusted_installation_source')
            .whenComplete(() => Fluttertoast.showToast(
                    msg:
                        'Untrusted Installation Source Detected. Cannot run this app on this device.')
                .then((value) => Future.delayed(Duration(seconds: 2))
                    .whenComplete(() => FirebaseCrashlytics.instance.crash())));
      }),

      /// For iOS
      iosCallback: IOScallback(onRuntimeManipulationDetected: () {
        ApiCalls.sendAnalytics(
                map: {'device_information': deviceInfoPlugin.deviceInfo},
                eventName: 'runtime_manipulation_detected')
            .whenComplete(() => Fluttertoast.showToast(
                    msg:
                        'Runtime Manipulation Detected. Cannot run this app on this device.')
                .then((value) => Future.delayed(Duration(seconds: 2))
                    .whenComplete(() => FirebaseCrashlytics.instance.crash())));
      }, onJailbreakDetected: () {
        ApiCalls.sendAnalytics(
                map: {'device_information': deviceInfoPlugin.deviceInfo},
                eventName: 'jailbreak_detected_on_this_device')
            .whenComplete(() => Fluttertoast.showToast(
                    msg:
                        'Your Device is jailbreak. Cannot run this app on this device.')
                .then((value) => Future.delayed(Duration(seconds: 2))
                    .whenComplete(() => FirebaseCrashlytics.instance.crash())));
      }, onSimulatorDetected: () {
        ApiCalls.sendAnalytics(
                map: {'device_information': deviceInfoPlugin.deviceInfo},
                eventName: 'simulator_device')
            .whenComplete(() => Fluttertoast.showToast(
                    msg:
                        'Your Device is a simulator. Cannot run this app on this device.')
                .then((value) => Future.delayed(Duration(seconds: 2))
                    .whenComplete(() => FirebaseCrashlytics.instance.crash())));
      }, onMissingSecureEnclaveDetected: () {
        ApiCalls.sendAnalytics(
                map: {'device_information': deviceInfoPlugin.deviceInfo},
                eventName: 'secure_enclave_missing')
            .whenComplete(
          () => Fluttertoast.showToast(
                  msg:
                      'Your Device is not enclave secure. Cannot run this app on this device.')
              .then(
            (value) => Future.delayed(Duration(seconds: 2))
                .whenComplete(() => FirebaseCrashlytics.instance.crash()),
          ),
        );
      }, onDeviceIdDetected: () {
        setState(() {});
      }),

      /// Debugger is common for both platforms
      onDebuggerDetected: () {
        setState(() {
          _debuggerState = 'Detected';
          print('Debugging Enabled');
          Fluttertoast.showToast(
                  msg:
                      'Debugging Mode is on. Cannot run this app on this device.')
              .then((value) => Future.delayed(Duration(seconds: 2))
                  .whenComplete(() => FirebaseCrashlytics.instance.crash()));
        });
      },
    );

    TalsecApp app = TalsecApp(
      config: config,
      callback: callback,
    );

    /// Turn on freeRASP
    app.start();

    if (!mounted) return;
  }
}
