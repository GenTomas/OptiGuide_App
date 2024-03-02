import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:optiguide_app/extensions.dart';
import 'package:optiguide_app/side_menu.dart';
import 'package:optiguide_app/text_to_speech.dart';
// import 'package:optiguide_app/tutorial.dart';
import 'package:tflite/tflite.dart';
import 'dart:typed_data';

late List<CameraDescription> cameras;

class ObjectRecog extends StatefulWidget {
  const ObjectRecog({super.key});

  @override
  State<ObjectRecog> createState() => _ObjectRecogState();
}

class _ObjectRecogState extends State<ObjectRecog> {
  bool isWorking = false;
  bool isMounted = false;
  late CameraController cameraController;
  late CameraImage imgCamera;
  int direction = 0;
  String funcName = 'Object Recognition';
  String result = '';
  FlutterTts flutterTts = FlutterTts();

  //InitState
  @override
  void initState() {
    //To load the camera
    isMounted = true;
    initCamera(direction);

    //To load the TFlite model
    loadModel();
    ConvertTTS().dictateFunction(funcName);

    super.initState();
  }

  //Dispose
  @override
  void dispose() async {
    isMounted = false;
    super.dispose();

    //Close the tflite
    await Tflite.close();

    //Close the camera feed
    cameraController.dispose();

    //Close flutterTts
    flutterTts.stop();
  }

  //Loads the object detection and recognition model
  loadModel() async {
    await Tflite.loadModel(
      //Model: MobileNet
      model: 'assets/mobilenet_v1_1.0_224.tflite',
      labels: 'assets/mobilenet_v1_1.0_224.txt',
    );
  }

  //Initiate camera feed
  initCamera(int direction) async {
    if (isMounted) {
      cameras = await availableCameras();
      cameraController = CameraController(
          cameras[direction], ResolutionPreset.high,
          enableAudio: false);

      await cameraController.initialize().then((value) {
        if (isMounted) {
          setState(() {
            cameraController.startImageStream((imagesFromStream) {
              if (!isWorking) {
                isWorking = true;
                // imgCamera = imagesFromStream;

                // runModelOnStreamFrames();
              }
            });
          });
        }
      }).catchError((e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('An error occurred while initiating model.')));
      });
    }
  }

  //Run object recognition
  runModelOnStreamFrames() async {
    if (imgCamera != null && isMounted) {
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

      if (isMounted) {
        if (recognitions != null && recognitions.isNotEmpty) {
          // Get the first recognition result
          var response = recognitions[0];
          result =
              response['label'] ?? ''; // Get the label of the detected object

          if (isMounted) {
            setState(() {
              ConvertTTS().textToSpeech(result);
            });
          }
        }
      }
      isWorking = false;
    }
  }

  void recognizeObject() async {
    XFile? picture = await cameraController.takePicture();

    if (picture != null) {
      Uint8List bytes = await picture.readAsBytes();

      var recognitions = await Tflite.runModelOnBinary(
        binary: bytes,
        numResults: 1, // Set to 1 to detect only one object
        asynch: true,
      );

      if (recognitions != null && recognitions.isNotEmpty) {
        var objName = recognitions[0];
        setState(() {
          result = objName['label'] ?? '';
          ConvertTTS().textToSpeech(result);
        });
      }
    }
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
                  height: MediaQuery.of(context).size.width * 1.95,
                  // child: CameraPreview(cameraController)),
                  child: GestureDetector(
                      onTap: recognizeObject,
                      child: CameraPreview(cameraController))),
              Builder(builder: (context) {
                return GestureDetector(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: button(Icons.menu_rounded, Alignment.topLeft),
                );
              }),
              Align(
                alignment: AlignmentDirectional.topCenter,
                child: Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: Text(
                    funcName,
                    style: TextStyle(fontSize: 20, color: '#000000'.toColor()),
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
          backgroundColor: '#64ccc5'.toColor(),
          drawer: const SideMenu());
    } catch (e) {
      return const SizedBox();
    }
  }

  Widget button(IconData icon, Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.only(top: 25, left: 10),
        height: 40,
        width: 40,
        child: Center(
          child: Icon(
            icon,
            color: '#000000'.toColor(),
            // shadows: const <Shadow>[
            //   Shadow(color: Colors.black, blurRadius: 15.0)
            // ],
          ),
        ),
      ),
    );
  }
}
