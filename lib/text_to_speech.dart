import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_tts/flutter_tts.dart';

FlutterTts flutterTts = FlutterTts();

class CallTTS {
  final String inputTts;

  CallTTS({required this.inputTts});

  Future<void> convertTTS(String text) async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setVolume(0.5);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1);
    // await flutterTts.setVoice(voice);
    // await flutterTts.getEngines();
    await flutterTts.speak(text);

    // return flutterTts.speak(text);
  }
}

// class TTSWidget extends StatefulWidget {
//   const TTSWidget({super.key});

//   @override
//   State<TTSWidget> createState() => _TTSWidgetState();
// }

// class _TTSWidgetState extends State<TTSWidget> {
//   @override
//   Widget build(BuildContext context) {
//     FlutterTts flutterTts = FlutterTts();

    // void convertTTS(String text) async {
    //   await flutterTts.setLanguage('');
    //   await flutterTts.setVolume(0.5);
    //   await flutterTts.setSpeechRate(0.5);
    //   await flutterTts.setPitch(1);
    //   await flutterTts.speak(text);
    // }

//     return const Placeholder();
//   }
// }

// class TTSWidget extends StatefulWidget {
//   const TTSWidget({super.key, required});

//   @override
//   State<TTSWidget> createState() => _TTSWidgetState();
// }

// class _TTSWidgetState extends State<TTSWidget> {
//   FlutterTts flutterTts = FlutterTts();

//   List<Map> _voices = [];
//   Map? _currentVoice;
//   String ttsInput =
//       'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam sed leo dui. Nam vel euismod ipsum, quis lacinia odio. In sagittis tellus ipsum, posuere lacinia nisi fringilla quis. Pellentesque congue eros eu tellus congue, sed mattis ante blandit. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis.';

//   @override
//   void initState() {
//     super.initState();
//   }

//   void initTTS() {
//     flutterTts.getVoices.then((data) {
//       try {
//         _voices = List<Map>.from(data);
//         setState(() {
//           _voices =
//               _voices.where((_voice) => _voice["name"].contains("en")).toList();
//           _currentVoice = _voices.first;
//           setVoice(_currentVoice!);
//         });
//       } catch (e) {
//         print(e);
//       }
//     });
//   }

//   void setVoice(Map voice) {
//     flutterTts.setVoice({"name": voice["name"], "locale": voice["locale"]});
//   }

//   void inputTTS(String textTTS) {
//     if (textTTS.isEmpty) {
//       textTTS = ttsInput;
//     }

//     flutterTts.speak(textTTS);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _buildUI(),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           flutterTts.speak(ttsInput);
//         },
//         child: const Icon(
//           Icons.speaker_phone,
//         ),
//       ),
//     );
//   }

//   Widget _buildUI() {
//     return SafeArea(
//         child: Column(
//       mainAxisSize: MainAxisSize.max,
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         _speakerSelector(),
//         RichText(
//           textAlign: TextAlign.center,
//           text: TextSpan(
//             style: const TextStyle(
//               fontWeight: FontWeight.w300,
//               fontSize: 20,
//               color: Colors.black,
//             ),
//             children: <TextSpan>[
//               TextSpan(
//                 text: ttsInput,
//               ),
//             ],
//           ),
//         ),
//       ],
//     ));
//   }

//   Widget _speakerSelector() {
//     return DropdownButton(
//       value: _currentVoice,
//       items: _voices
//           .map(
//             (_voice) => DropdownMenuItem(
//               value: _voice,
//               child: Text(
//                 _voice["name"],
//               ),
//             ),
//           )
//           .toList(),
//       onChanged: (value) {},
//     );
//   }
// }
