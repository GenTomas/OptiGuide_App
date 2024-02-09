import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:optiguide_app/extensions.dart';
import 'package:tflite/tflite.dart';

late List<CameraDescription> cameras;

class ObjectRecog extends StatefulWidget {
  const ObjectRecog({super.key});

  @override
  State<ObjectRecog> createState() => _ObjectRecogState();
}

class _ObjectRecogState extends State<ObjectRecog> {
  bool isWorking = false;
  String result = '';
  late CameraController cameraController;
  late CameraImage imgCamera;
  int direction = 0;

  //InitState
  @override
  void initState() {
    //To load the camera
    initCamera(0);

    //To load the TFlite model
    loadModel();

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
          // numResults: 2,
          threshold: 0.1,
          asynch: true);

      result = '';
      recognitions?.forEach((response) {
        result += response['label'] +
            ' ' +
            (response['confidence'] as double).toStringAsFixed(2) +
            '\n\n';
      });

      setState(() {
        result;
      });

      isWorking = false;
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
              height: double.infinity,
              child: CameraPreview(cameraController)
            ),
            GestureDetector(
              onTap: () {
                SystemNavigator.pop();
              },
              child: button(Icons.exit_to_app_outlined, Alignment.bottomCenter),
            ),
            Align(
              alignment: AlignmentDirectional.topCenter,
              child: Container(
                margin: const EdgeInsets.only(top: 30),
                child: Text(
                  'Object Recognition',
                  style: TextStyle(fontSize: 20, color: '#ffffff'.toColor()),
                ),
              ),
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
        margin: const EdgeInsets.only(bottom: 20),
        height: 50,
        width: 50,
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
