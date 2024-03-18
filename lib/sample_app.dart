import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(const SampleApp());
}

class SampleApp extends StatelessWidget {
  const SampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Button Demo'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  _speak('Button 1');
                },
                child: const Text('Button 1'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _speak('Button 2');
                },
                child: const Text('Button 2'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _speak('Button 3');
                },
                child: const Text('Button 3'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _speak(String message) async {
    final FlutterTts flutterTts = FlutterTts();
    await flutterTts.setLanguage('en-US');
    await flutterTts.setPitch(1);
    await flutterTts.speak(message);
  }
}
