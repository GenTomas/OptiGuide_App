import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:optiguide_app/buttons.dart';
import 'dart:io';
import 'package:optiguide_app/extensions.dart';
import 'package:optiguide_app/side_menu.dart';
import 'package:optiguide_app/text_to_speech.dart';

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
    ConvertTTS().dictateFunction(funcName);
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // final InputImage inputImage = InputImage.fromFilePath(widget.path!);
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
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * .92,
                  child: GestureDetector(
                      onTap: scanImage,
                      child: Align(
                        alignment: AlignmentDirectional.center,
                        child: SizedBox(
                            width: double.infinity,
                            // height: MediaQuery.of(context).size.height * .5,
                            child: CameraPreview(cameraController)),
                      ))),
            ),
            Builder(builder: (context) {
              return GestureDetector(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child:
                      Buttons().button(Icons.menu_rounded, Alignment.topLeft));
            }),
            Align(
              alignment: AlignmentDirectional.topCenter,
              child: Container(
                margin: const EdgeInsets.only(top: 30),
                child: Text(
                  funcName,
                  style: GoogleFonts.montserrat(
                      fontSize: 20, color: '#000000'.toColor()),
                ),
              ),
            ),
          ],
        ),
        backgroundColor: '#64ccc5'.toColor(),
        drawer: const SideMenu(),
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

      textToSpeech(recognized.text);

      // flutterTts.speak(recognized.text);

      // await navigator.push(MaterialPageRoute(
      //     builder: (BuildContext context) =>
      //         TextResult(text: recognized.text)));
    } catch (e) {
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
}

// class TextResult extends StatelessWidget {
//   final String text;
//   const TextResult({super.key, required this.text});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Result'),
//       ),
//       body: Container(
//         padding: const EdgeInsets.all(30.0),
//         child: Text(text),
//       ),
//     );
//   }
// }

  // Widget button(IconData icon, Alignment alignment) {
  //   return Align(
  //     alignment: alignment,
  //     child: Container(
  //       margin: const EdgeInsets.only(bottom: 20),
  //       height: 50,
  //       width: 50,
  //       decoration: BoxDecoration(
  //           shape: BoxShape.circle,
  //           color: '#ffffff'.toColor(),
  //           boxShadow: [
  //             BoxShadow(
  //                 color: '#767676'.toColor(),
  //                 offset: const Offset(2, 2),
  //                 blurRadius: 10)
  //           ]),
  //       child: Center(
  //         child: Icon(
  //           icon,
  //           color: '#404040'.toColor(),
  //         ),
  //       ),
  //     ),
  //   );
  // }



      // TextToSpeech textToSpeech = const TextToSpeech();
      // textToSpeech.assignText(recognized.text);