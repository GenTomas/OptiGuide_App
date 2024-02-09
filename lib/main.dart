import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:optiguide_app/extensions.dart';
import 'package:optiguide_app/pages.dart';

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'OpTiGuide: Object and Text Recognizer App v1.0.0+1',
        home: AnimatedSplashScreen(
            duration: 5000,
            splash: const Image(image: AssetImage('assets/load.png')),
            splashIconSize: 500.0,
            nextScreen: const Pages(),
            splashTransition: SplashTransition.fadeTransition,
            backgroundColor: '#dafffb'.toColor()));
  }
}
