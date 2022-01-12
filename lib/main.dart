import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/utils/CartBadgeCounter/CartBadgetLogic.dart';
import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:untitled2/utils/CartBadgeCounter/SearchModel/SearchNotifier.dart';
import 'AppPages/SplashScreen/SplashScreen.dart';
import 'Constants/ConstantVariables.dart';

Future<void> setFireStoreData(
  RemoteMessage message,
) async {
  String formattedDate =
      DateFormat('dd-MM-yyyy hh:mm').format(message.sentTime!);
  Fluttertoast.showToast(msg: '${Timestamp.fromDate(message.sentTime!)}');
  final refrence = FirebaseFirestore.instance.collection('UserNotifications');
  Map<String, dynamic> data = {
    'Title': message.notification!.title,
    'Desc': message.notification!.body,
    'Time': Timestamp.fromDate(message.sentTime!)
  };
  refrence.doc().set(data);
}

Future<void> _messageHandler(RemoteMessage message) async {
  setFireStoreData(message);
  print('background message ${message.notification!.body}');
  print('background message message got ');
}

Future<void> main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      FirebaseMessaging.onBackgroundMessage(_messageHandler);
      ConstantsVar.prefs = await SharedPreferences.getInstance();
      ConstantsVar.prefs.setBool('isFirstTime', true);
      AwesomeNotifications().initialize(
        'resource://drawable/playstore', // icon for your app notification
        [
          NotificationChannel(
            channelKey: 'Add to Cart Notification',
            channelName: 'Add to Cart Notification',
            channelDescription: "Add to Cart Notification",
            defaultColor: Color(0XFF9050DD),
            ledColor: Colors.white,
            playSound: true,
            enableLights: true,
            enableVibration: true,
            channelShowBadge: true,
            icon: 'resource://drawable/playstore',
          ),
          NotificationChannel(
            channelKey: 'Add to Wishlist Notification',
            channelName: 'Add to Wishlist Notification',
            channelDescription: "Add to Wishlist Notification",
            defaultColor: Color(0XFF9050DD),
            ledColor: Colors.white,
            playSound: true,
            enableLights: true,
            enableVibration: true,
            channelShowBadge: true,
            icon: 'resource://drawable/playstore',
          ),
          NotificationChannel(
            channelKey: 'Remove from Wishlist Notification',
            channelName: 'Remove from Wishlist Notification',
            channelDescription: "Remove from Wishlist Notification",
            defaultColor: Color(0XFF9050DD),
            ledColor: Colors.white,
            playSound: true,
            enableLights: true,
            enableVibration: true,
            channelShowBadge: true,
            icon: 'resource://drawable/playstore',
          ),
        ],
      );

      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

      if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled == true) {
        FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      } else {
        FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      }
      GestureBinding.instance!.resamplingEnabled = true;

      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
          .then((_) async {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge)
            .then((_) async {
          FirebaseMessaging.instance;

          FirebaseMessaging.onMessage.listen((event) {
            _messageHandler(event);
          });
          // FirebaseMessaging.onMessage.;
          runApp(DevicePreview(
            enabled: false,
            builder: (context) => MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (_) => cartCounter(),
                ),
                ChangeNotifierProvider(
                  create: (_) => SearchModel(),
                ),
              ],
              child: Phoenix(
                child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'The One',
                  builder: (context, child) {
                    // final mediaQueryData = MediaQuery.of(context);
                    // final scale = mediaQueryData.textScaleFactor.clamp(1.0, 1.3);
                    return MediaQuery(
                      child: child!,
                      data:
                          MediaQuery.of(context).copyWith(textScaleFactor: 0.9),
                    );
                  },
                  home: SplashScreen(),
                  darkTheme: ThemeData(
                    pageTransitionsTheme: PageTransitionsTheme(
                      builders: {
                        TargetPlatform.android: ZoomPageTransitionsBuilder(),
                        TargetPlatform.iOS:
                            CupertinoWillPopScopePageTransionsBuilder(),
                      },
                    ),
                    fontFamily: 'Arial',
                    primarySwatch: MaterialColor(0xFF800E4F, color),
                    primaryColor: ConstantsVar.appColor,
                  ),
                  theme: ThemeData(
                    pageTransitionsTheme: PageTransitionsTheme(
                      builders: {
                        TargetPlatform.android: ZoomPageTransitionsBuilder(),
                        TargetPlatform.iOS:
                            CupertinoWillPopScopePageTransionsBuilder(),
                      },
                    ),
                    fontFamily: 'Arial',
                    primarySwatch: MaterialColor(0xFF800E4F, color),
                    primaryColor: ConstantsVar.appColor,
                  ),
                ),
              ),
            ),
          ));
        });
      });
    },
    (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack);
    },
  );
}

Map<int, Color> color = {
  // 10: Color.fromRGBO(255, 255, 255, 1)
  50: Color.fromRGBO(136, 14, 79, .1),
  100: Color.fromRGBO(136, 14, 79, .2),
  200: Color.fromRGBO(136, 14, 79, .3),
  300: Color.fromRGBO(136, 14, 79, .4),
  400: Color.fromRGBO(136, 14, 79, .5),
  500: Color.fromRGBO(136, 14, 79, .6),
  600: Color.fromRGBO(136, 14, 79, .7),
  700: Color.fromRGBO(136, 14, 79, .8),
  800: Color.fromRGBO(255, 255, 255, .9),
  900: Color.fromRGBO(136, 14, 79, 1),
};
