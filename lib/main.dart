import 'dart:async';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:workmanager/workmanager.dart';
import 'AppPages/SplashScreen/SplashScreen.dart';
import 'Constants/ConstantVariables.dart';

const simpleTaskKey = "simpleTask";
const rescheduledTaskKey = "rescheduledTask";
const failedTaskKey = "failedTask";
const simpleDelayedTask = "simpleDelayedTask";
const simplePeriodicTask = "simplePeriodicTask";
const simplePeriodic1HourTask = "simplePeriodic1HourTask";

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    Fluttertoast.showToast(msg: 'Hi There');
    switch (task) {
      case simpleTaskKey:
        print("$simpleTaskKey was executed. inputData = $inputData");
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool("test", true);
        print("Bool from prefs: ${prefs.getBool("test")}");
        break;
      case rescheduledTaskKey:
        final key = inputData!['key']!;
        final prefs = await SharedPreferences.getInstance();
        if (prefs.containsKey('unique-$key')) {
          print('has been running before, task is successful');
          return true;
        } else {
          await prefs.setBool('unique-$key', true);
          print('reschedule task');
          return false;
        }
      case failedTaskKey:
        print('failed task');
        return Future.error('failed');
      case simpleDelayedTask:
        print("$simpleDelayedTask was executed");
        break;
      case simplePeriodicTask:
        print("$simplePeriodicTask was executed");
        break;
      case simplePeriodic1HourTask:
        print("$simplePeriodic1HourTask was executed");
        break;
      case Workmanager.iOSBackgroundTask:
        print("The iOS background fetch was triggered");
        Directory? tempDir = Directory.systemTemp;
        String? tempPath = tempDir.path;
        print(
            "You can access other plugins in the background, for example Directory.getTemporaryDirectory(): $tempPath");
        break;
    }

    return Future.value(true);
  });
}

Future<void> setFireStoreData(
  RemoteMessage message,
) async {
  Firebase.initializeApp();
  String formattedDate =
      DateFormat('yyyy-MM-dd – kk:mm').format(message.sentTime!);
  final refrence = FirebaseFirestore.instance.collection('UserNotifications');
  Map<String, dynamic> data = {
    'Title': message.notification!.title,
    'Desc': message.notification!.body,
    'Time': formattedDate
  };
  refrence.doc().set(data);
}

Future<void> _messageHandler(RemoteMessage message) async {
  setFireStoreData(message);
  print('background message ${message.notification!.body}');
  print('background message message got ');
}


// Toggle this for testing Crashlytics in your app locally.


Future<void> main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      ConstantsVar.prefs = await SharedPreferences.getInstance();
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
          FirebaseMessaging.onBackgroundMessage(_messageHandler);
          FirebaseMessaging.onMessage.listen((event) {
            _messageHandler(event);
          });
          // FirebaseMessaging.onMessage.;
          runApp(MultiProvider(
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
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 0.9),
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
