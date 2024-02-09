import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:io';
import 'package:optiguide_app/extensions.dart';

late List<CameraDescription> cameras;

class TextRecog extends StatefulWidget {
  const TextRecog({super.key});

  @override
  State<TextRecog> createState() => _TextRecogState();
}

class _TextRecogState extends State<TextRecog> with WidgetsBindingObserver {
  bool isWorking = false;
  String result = '';
  late CameraController cameraController;
  late CameraImage imgCamera;
  int direction = 0;
  bool isBusy = false;
  String funcName = 'Text Recognition';

  final textRecognizer = TextRecognizer();

  TextEditingController controller = TextEditingController();
  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    initCamera();
    super.initState();
    dictateFunction(funcName);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() async {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  initCamera() async {
    cameras = await availableCameras();
    cameraController = CameraController(
        cameras[direction], ResolutionPreset.high,
        enableAudio: false);
    await cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }

      setState(() {
        cameraController.startImageStream((imagesFromStream) {
          if (!isWorking) {
            isWorking = true;
            imgCamera = imagesFromStream;
          }
        });
      });
    }).catchError((e) {});
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        body: Stack(
          children: [
            SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: CameraPreview(cameraController)),
            GestureDetector(
              onTap: scanImage,
            ),
            Align(
              alignment: AlignmentDirectional.topCenter,
              child: Container(
                margin: const EdgeInsets.only(top: 30),
                child: Text(
                  'Text Recognition',
                  style: TextStyle(fontSize: 20, color: '#ffffff'.toColor()),
                ),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      return const SizedBox();
    }
  }

  Future<void> scanImage() async {
    // final navigator = Navigator.of(context);

    try {
      final pictureFile = await cameraController.takePicture();

      final file = File(pictureFile.path);
      final inputImage = InputImage.fromFile(file);

      final recognized = await textRecognizer.processImage(inputImage);

      // TextRecog({this.recognized});
      // CallTTS(inputTts: recognized.text);
      textToSpeech(recognized.text);
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('An error occurred when scanning text')));
    }
  }

  void textToSpeech(String text) async {
    await flutterTts.setLanguage('');
    await flutterTts.setVolume(0.5);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  }

  void dictateFunction(String funcName) async {
    await flutterTts.speak(funcName);
  }
}
