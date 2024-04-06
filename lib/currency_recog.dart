import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:optiguide_app/buttons.dart';
import 'package:optiguide_app/extensions.dart';
import 'package:optiguide_app/side_menu.dart';
import 'package:optiguide_app/text_to_speech.dart';
import 'package:tflite/tflite.dart';

late List<CameraDescription> cameras;

class CurrencyRecog extends StatefulWidget {
  const CurrencyRecog({super.key});

  @override
  State<CurrencyRecog> createState() => _CurrencyRecogState();
}

class _CurrencyRecogState extends State<CurrencyRecog> {
  bool isWorking = false;
  bool isMounted = false;
  bool isInitialized = false;
  late CameraController cameraController;
  late CameraImage imgCamera;
  int direction = 0;
  String funcName = 'Currency Recognition';
  String result = '';
  FlutterTts flutterTts = FlutterTts();

  //InitState
  @override
  void initState() {
    //To load the camera
    initCamera(direction);

    //To load the TFlite model
    loadModel();
    ConvertTTS().dictateFunction(funcName);

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

    //Close flutterTts
    flutterTts.stop();
  }

  //Loads the object detection and recognition model
  loadModel() async {
    await Tflite.loadModel(
      //Model: SSD MobileNet

      model: 'assets/currency_recog.tflite',
      labels: 'assets/currency_recog.txt',
    );
  }

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

            // runModelOnStreamFrames();
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
          numResults: 1,
          threshold: 0.1,
          asynch: true);

      result = '';
      recognitions?.forEach((response) {
        result += response['label'] + '\n\n';
      });

      setState(() {
        ConvertTTS().textToSpeech(result);
      });

      isWorking = false;
    }
  }

  // void recognizeObject() async {
  //   CameraPreview(cameraController);
  //   // Check if the camera feed and context are available
  //   if (imgCamera != null && context.mounted) {
  //     // Capture a new frame from the camera
  //     XFile? picture = await cameraController.takePicture();

  //     // Check if the captured frame is not null
  //     if (picture != null) {
  //       // Run object recognition on the captured frame
  //       var recognitions = await Tflite.runModelOnFrame(
  //         bytesList: imgCamera.planes.map((plane) {
  //           return plane.bytes;
  //         }).toList(),
  //         imageHeight: imgCamera.height,
  //         imageWidth: imgCamera.width,
  //         imageMean: 127.5,
  //         imageStd: 127.5,
  //         rotation: 90,
  //         numResults: 1, // Set to 1 to detect only one object
  //         threshold: 0.1,
  //         asynch: true,
  //       );

  //       // Check if the context is still mounted and recognitions are available
  //       if (context.mounted &&
  //           recognitions != null &&
  //           recognitions.isNotEmpty) {
  //         // Get the first recognition result
  //         var response = recognitions[0];
  //         result =
  //             response['label'] ?? ''; // Get the label of the detected object

  //         // Update the UI with the recognized object
  //         setState(() {
  //           ConvertTTS().textToSpeech(result);
  //         });

  //         isWorking = false;
  //         picture = null;
  //         recognitions = null;

  //         Future.delayed(const Duration(seconds: 5), () {
  //           setState(() {
  //             result = '';
  //           });
  //         });
  //       }
  //     }
  //   }
  // }

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
                  child: CameraPreview(cameraController)),
              // child: GestureDetector(
              //     onTap: recognizeObject,
              //     child: CameraPreview(cameraController))),
              Builder(builder: (context) {
                return GestureDetector(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child:
                      Buttons().button(Icons.menu_rounded, Alignment.topLeft),
                );
              }),
              Align(
                alignment: AlignmentDirectional.topCenter,
                child: Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: Text(
                    funcName,
                    style: GoogleFonts.montserrat(
                        fontSize: 20,
                        color: '#000000'.toColor(),
                        fontWeight: FontWeight.w500),
                    // style: TextStyle(fontSize: 20, color: '#000000'.toColor()),
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
                      style: GoogleFonts.montserrat(
                        backgroundColor: '#404040'.toColor(),
                        fontSize: 20.0,
                        color: '#ffffff'.toColor(),
                      ),
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
}
