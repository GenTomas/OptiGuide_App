import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:optiguide_app/extensions.dart';
import 'package:optiguide_app/tutorial.dart';
import 'package:tflite/tflite.dart';

late List<CameraDescription> cameras;

class CurrencyRecog extends StatefulWidget {
  const CurrencyRecog({super.key});

  @override
  State<CurrencyRecog> createState() => _CurrencyRecogState();
}

class _CurrencyRecogState extends State<CurrencyRecog> {
  bool isWorking = false;
  late CameraController cameraController;
  late CameraImage imgCamera;
  int direction = 0;
  String funcName = 'Currency Recognition';

  // this.result = objectResult;

  FlutterTts flutterTts = FlutterTts();

  //InitState
  @override
  void initState() {
    //To load the camera
    initCamera(0);

    //To load the TFlite model
    // loadModel();
    dictateFunction(funcName);

    super.initState();
  }

  //Dispose
  @override
  void dispose() async {
    super.dispose();

    //Close the tflite
    await Tflite.close();

    //Close the camera feed
    cameraController.dispose();
  }

  //Loads the object detection and recognition model
  loadModel() async {
    await Tflite.loadModel(
      //Model: MobileNet
      model: 'assets/mobilenet_v1_1.0_224.tflite',
      labels: 'assets/mobilenet_v1_1.0_224.txt',
    );
  }

  String result = '';

  //Initiate camera feed
  initCamera(int direction) async {
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

            runModelOnStreamFrames();
          }
        });
      });
    }).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('An error occurred while initiating model.')));
    });
  }

  //Run object recognition
  runModelOnStreamFrames() async {
    // ignore: unnecessary_null_comparison
    if (imgCamera != null) {
      var recognitions = await Tflite.runModelOnFrame(
        bytesList: imgCamera.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        imageHeight: imgCamera.height,
        imageWidth: imgCamera.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        numResults: 1, // Set to 1 to detect only one object
        threshold: 0.1,
        asynch: true,
      );

      if (recognitions != null && recognitions.isNotEmpty) {
        // Get the first recognition result
        var response = recognitions[0];
        result =
            response['label'] ?? ''; // Get the label of the detected object

        setState(() {
          textToSpeech(result);
        });
      }

      isWorking = false;
    }
  }

  void dictateFunction(String funcName) async {
    await flutterTts.speak(funcName);
  }

  void textToSpeech(String text) async {
    await flutterTts.setLanguage('');
    await flutterTts.setVolume(0.5);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  }

  //Show camera feed
  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        body: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: CameraPreview(cameraController)),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Tutorial(onFinish: () {
                            Navigator.pop(context);
                          })),
                );
              },
              child: button(Icons.exit_to_app_outlined, Alignment.topLeft),
            ),
            Align(
              alignment: AlignmentDirectional.topCenter,
              child: Container(
                margin: const EdgeInsets.only(top: 30),
                child: Text(
                  funcName,
                  style: TextStyle(fontSize: 20, color: '#ffffff'.toColor()),
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: Container(
                  margin: const EdgeInsets.only(bottom: 30.0),
                  child: SingleChildScrollView(
                      child: Text(
                    result,
                    style: TextStyle(
                        backgroundColor: '#404040'.toColor(),
                        fontSize: 20.0,
                        color: '#ffffff'.toColor()),
                    textAlign: TextAlign.center,
                  ))),
            ),
          ],
        ),
      );
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //    content: Text('An error occurred while initiating model.')));
      return const SizedBox();
    }
  }

  Widget button(IconData icon, Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.only(top: 30, left: 10),
        height: 40,
        width: 40,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: '#ffffff'.toColor(),
            boxShadow: [
              BoxShadow(
                  color: '#767676'.toColor(),
                  offset: const Offset(2, 2),
                  blurRadius: 10)
            ]),
        child: Center(
          child: Icon(
            icon,
            color: '#404040'.toColor(),
          ),
        ),
      ),
    );
  }
}
