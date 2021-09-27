import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/AppPages/CartxxScreen/CartScreen2.dart';
import 'package:untitled2/utils/CartBadgeCounter/CartBadgetLogic.dart';

import 'AppPages/LoginScreen/LoginScreen.dart';

import 'AppPages/SplashScreen/SplashScreen.dart';
import 'Constants/ConstantVariables.dart';

Future<void> setFireStoreData(
  RemoteMessage message,
) async {
  Firebase.initializeApp();
  AwesomeNotifications().createNotificationFromJsonData(message.data);
  String formattedDate =
      DateFormat('yyyy-MM-dd – kk:mm').format(message.sentTime!);
  final refrence = FirebaseFirestore.instance.collection('UserNotifications');
  Map<String, dynamic> data = {
    'Title': message.notification!.title,
    'Desc': message.notification!.body,
    'Time': formattedDate
  };
  refrence.add(data);
}

Future<void> _messageHandler(RemoteMessage message) async {
  setFireStoreData(message);
  print('background message ${message.notification!.body}');
  print('background message message got ');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  AwesomeNotifications().initialize('MyAssets/logo.png', [
    // Your notification channels go here
  ]);
  GestureBinding.instance!.resamplingEnabled = true;
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) async {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge)
        .then((_) async {
      ConstantsVar.prefs = await SharedPreferences.getInstance();
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
        ],
        child: Phoenix(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            routes: {
              '/LoginScreen': (context) => LoginScreen(),
              '/CartScreen': (context) => CartScreen2(),
            },
            title: 'The One',
            home: SplashScreen(),
            theme: ThemeData(
                fontFamily: 'Arial',
                primarySwatch: MaterialColor(0xFF800E4F, color),
                primaryColor: ConstantsVar.appColor),
          ),
        ),
      ));
    });
  });
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
