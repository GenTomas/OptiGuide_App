import 'package:flutter/material.dart';
import 'package:optiguide_app/pages.dart';
import 'package:optiguide_app/tutorial.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstTime extends StatefulWidget {
  const FirstTime({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FirstTimeState createState() => _FirstTimeState();
}

class _FirstTimeState extends State<FirstTime> {
  late SharedPreferences prefs;
  bool _showTutorial = false;

  @override
  void initState() {
    super.initState();
    loadPreferences();
  }

  loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
    bool showTutorial = prefs.getBool('showTutorial') ?? true;
    setState(() {
      _showTutorial = showTutorial;
    });
  }

  updatePreferences() async {
    await prefs.setBool('showTutorial', false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _showTutorial
          ? Tutorial(onFinish: onTutorialFinished)
          : const Pages(),
    );
  }

  void onTutorialFinished() {
    updatePreferences();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Pages()));
  }
}
