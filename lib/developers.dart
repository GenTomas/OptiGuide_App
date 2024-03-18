import 'package:flutter/material.dart';
import 'package:optiguide_app/extensions.dart';
import 'package:optiguide_app/text_to_speech.dart';

// ignore: must_be_immutable
class Developers extends StatelessWidget {
  Developers({super.key});

  String widgetName = 'Our team';

  void initState() {
    ConvertTTS().dictateFunction(widgetName);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OptiGuide Developers',
      home: Scaffold(
        appBar: AppBar(
            title: const Text('Developers'),
            backgroundColor: '#ffffff'.toColor(),
            shadowColor: '#000000'.toColor(),
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back))),
        body: GestureDetector(
          onLongPress: () => Navigator.pop(context),
          child: const SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: [
                    //Preview
                    Text(
                      'About Our Team',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    Image(
                      image: AssetImage('assets/pup_logo.png'),
                      width: 200,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'We are the students from Polytechnic University of the Philippines - Parañaque City Campus. This project of making OptiGuide mobile application is a part of our partial fulfillment for the degree in Bachelor of Science in Information Technology.\n',
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 20),

                    //Project Manager
                    Text(
                      'Project Manager',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Tom Angelo Fernando',
                    ),
                    SizedBox(height: 20),

                    //Developers
                    Text(
                      'Front-end Developers',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Jethan Divinaflor',
                    ),
                    Text(
                      'Tom Angelo Fernando',
                    ),
                    SizedBox(height: 20),

                    //Lead Researcher
                    Text(
                      'Lead Researcher',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Camille Shyne Barrameda',
                    ),
                    SizedBox(height: 20),

                    //Model Trainor
                    Text(
                      'Model Trainor',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Christian Villagen',
                    ),
                    SizedBox(height: 20),

                    //Quality Assurance
                    Text(
                      'Quality Assurance (Android)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Christian Villagen',
                    ),
                    Text(
                      'Jethan Divinaflor',
                    ),
                    SizedBox(height: 20),

                    //Quality Assurance
                    Text(
                      'Quality Assurance (iOS)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Tom Angelo Fernando',
                    ),
                    SizedBox(height: 20),

                    //Research Adviser
                    Text(
                      'Research Adviser',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Aldrin Obsanga',
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              )),
        ),
        backgroundColor: '#dafffb'.toColor(),
      ),
    );
  }
}
