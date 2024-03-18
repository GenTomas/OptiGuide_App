import 'package:flutter_tts/flutter_tts.dart';

class ConvertTTS {
  final FlutterTts flutterTts = FlutterTts();

  Future<void> dictateFunction(String funcName) async {
    await flutterTts.speak(funcName);
  }

  Future<void> textToSpeech(String text) async {
    await flutterTts.setLanguage('');
    await flutterTts.setVolume(0.5);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  }
}
