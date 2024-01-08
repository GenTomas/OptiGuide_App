import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
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

  final textRecognizer = TextRecognizer();

  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    initCamera();
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
        body: Column(
          children: [
            Stack(
              children: [
                CameraPreview(cameraController),
                GestureDetector(
                  onTap: () {
                    scanImage();
                  },
                  child:
                      button(Icons.camera_alt_outlined, Alignment.bottomCenter),
                )
              ],
            )
          ],
        ),
      );
    } catch (e) {
      return const SizedBox();
    }
  }

  Widget button(IconData icon, Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Container(
        // margin: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
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

  Future<void> scanImage() async {
    final navigator = Navigator.of(context);

    try {
      final pictureFile = await cameraController.takePicture();

      final file = File(pictureFile.path);
      final inputImage = InputImage.fromFile(file);

      final recognized = await textRecognizer.processImage(inputImage);

      await navigator.push(MaterialPageRoute(
          builder: (BuildContext context) =>
              TextResult(text: recognized.text)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('An error occurred when scanning text')));
    }
  }
}

class TextResult extends StatelessWidget {
  final String text;
  const TextResult({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
      ),
      body: Container(
        padding: const EdgeInsets.all(30.0),
        child: Text(text),
      ),
    );
  }
}
