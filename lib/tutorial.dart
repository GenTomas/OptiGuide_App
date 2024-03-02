import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:optiguide_app/extensions.dart';
// import 'package:optiguide_app/pages.dart';

class Tutorial extends StatefulWidget {
  final VoidCallback onFinish;

  const Tutorial({super.key, required this.onFinish});

  @override
  State<Tutorial> createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> {
  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Preview of the App
      showTutorial(
          'Welcome to OptiGuide! Your personal object, text, and currency recognizer.\n\nI am Gyde, your OptiGuide Tutor for today. Let me show you our features.\n\nTap the screen to proceed',
          () {
        // Object Recognizer
        showTutorial(
            'This is the Object Recognizer. All you have to do is to grab the object you want to scan, point it at the rear camera of your handheld mobile phone, and press the screen. Then I will dictate what object are you holding.\n\nTap the screen to proceed',
            () {
          // Text Recognizer
          showTutorial(
              'This is the Text Recognizer. To use this, point your camera towards the text that you want to scan. Then I will read the entire text for you.\n\nTap the screen to proceed',
              () {
            // Currency Recognizer
            showTutorial(
                'Finally, this is the Currency Recognizer. To use this function, point your camera towards the coin or banknote that you are going to scan. I will dictate the money you are holding. My dictation will be one coin or banknote at a time.\n\nTap the screen to proceed',
                () {
              // Navigation
              showTutorial(
                  'To switch from one function to another, swipe the screen to the left or to the right. I will dictate the function you are currently using.\n\nTap the screen to proceed',
                  () {
                // End of tutorial
                showTutorial(
                    'Congratulations! You have finished the tutorial of OptiGuide. You may now venture your surroundings using the app.\n\nTap the screen to close',
                    () {
                  widget.onFinish();
                });
              });
            });
          });
        });
      });
    });
    //Preview of the app
  }

  void showTutorial(String message, Function()? onFinish) {
    //Speak message when the dialog is shown
    speakMessage(message);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return GestureDetector(
              onTap: () {
                Navigator.of(context).pop(); //Close the dialog on tap
                if (onFinish != null) {
                  onFinish();
                }
              },
              child: Dialog(
                backgroundColor: '#dafffb'.toColor(),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      color: '#000000'.toColor(),
                      wordSpacing: 0.5,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ));
        });
  }

  Future<void> speakMessage(String message) async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setPitch(1);
    await flutterTts.speak(message);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: const Center(
          child: Image(
            image: AssetImage('assets/load.png'),
            width: 500,
          ),
        ),
      ),
      backgroundColor: const Color.fromRGBO(218, 255, 251, 1),
    ));
  }
}
