import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:optiguide_app/extensions.dart';
import 'package:optiguide_app/first_time_handler.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';
import 'package:flutter/foundation.dart' show kDebugMode;

void main(List<String> args) {
  // runZonedGuarded<Future<void>>(() async {
  //   WidgetsFlutterBinding.ensureInitialized();
  //   await Firebase.initializeApp();

  //   if (kDebugMode) {
  //     // await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  //   } else {
  //     // The following lines are the same as previously explained in "Handling uncaught errors"
  //     FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  //   }

  //   runApp(const MyApp());
  // }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'OpTiGuide: Object and Text Recognizer App v1.0.1+1',
        home: AnimatedSplashScreen(
            duration: 5000,
            splash: const Image(image: AssetImage('assets/load.png')),
            splashIconSize: 500.0,
            nextScreen: const FirstTime(),
            splashTransition: SplashTransition.fadeTransition,
            backgroundColor: '#dafffb'.toColor()));
  }
}
