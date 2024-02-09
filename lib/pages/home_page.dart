import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:optiguide_app/text_to_speech.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  FlutterTts _flutterTts = FlutterTts();

  List<Map> _voices = [];
  Map? _currentVoice;
  String ttsInput = 'Enter the new year with a NEW LAPTOP as we give you EXCITING DEALS and BUNDLES to enjoy! You can still get as much as ₱51,000+ worth of bundled items when you  purchase any of the participating ROG laptops! The spirit of sharing is still alive because you can get an ROG Cetra True Core and even an ROG Phone! Still worked up about the holiday spending? We got you! You can get your new ROG Laptop at 0% installment deals up to 12mos via Home Credit! The #ROGSHARE2023 is available on all our platforms! Purchase offline from any of our ASUS/ROG concept stores and authorized dealers or check out online through our official Shopee, Lazada stores, and the ASUS Official Online Store! Click here for more details Terms and Conditions Apply. Per DTI Fair Trade Permit No. FTEB-179938 Series of 2023';

  @override
  void initState() {
    super.initState();
  }

  void initTTS() {
    _flutterTts.getVoices.then((data) {
      try {
          _voices = List<Map>.from(data);
        setState(() {
                  _voices= 
            _voices.where((_voice) => _voice["name"].contains("en")).toList();
          _currentVoice = _voices.first;
          setVoice(_currentVoice!);
        });
      } catch (e) {
        print(e);
      }
    });
  }

  void setVoice(Map voice){
    _flutterTts.setVoice({"name": voice["name"], "locale": voice["locale"]});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _flutterTts.speak(ttsInput);
        }, 
        child: const Icon(
          Icons.speaker_phone,
          ),
          ),
          );
  }
  Widget _buildUI(){
  return SafeArea(
      child: Column(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      _speakerSelector(),
      RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: const TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 20,
            color: Colors.black,
          ),
          children: <TextSpan>[
            TextSpan(
              text: ttsInput,
            ),
          ],
        ),
      ),
    ],
  )
);
  
}

Widget _speakerSelector() {
  return DropdownButton(
    value: _currentVoice,
    items: _voices
        .map(
          (_voice) => DropdownMenuItem(
            value: _voice,
            child: Text(
              _voice["name"],
              ),
            ),
          )
        .toList(),
      onChanged: (value) {},
    );
  }
}
