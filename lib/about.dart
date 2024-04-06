import 'package:flutter/material.dart';
import 'package:optiguide_app/developers.dart';
import 'package:optiguide_app/extensions.dart';
import 'package:optiguide_app/text_to_speech.dart';
// import 'package:path/path.dart';

// ignore: must_be_immutable
class About extends StatelessWidget {
  About({super.key});

  String par_1 =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Dignissim suspendisse in est ante. Eleifend donec pretium vulputate sapien. Donec ultrices tincidunt arcu non sodales neque. Praesent tristique magna sit amet purus gravida quis blandit. Sit amet consectetur adipiscing elit. Dictum varius duis at consectetur lorem. Bibendum enim facilisis gravida neque convallis. Felis eget nunc lobortis mattis aliquam faucibus. Donec adipiscing tristique risus nec feugiat in fermentum posuere urna. Sollicitudin tempor id eu nisl. Penatibus et magnis dis parturient montes nascetur ridiculus. Non sodales neque sodales ut etiam sit. At volutpat diam ut venenatis tellus in metus vulputate eu. Ut placerat orci nulla pellentesque. Consectetur purus ut faucibus pulvinar elementum integer. Dolor morbi non arcu risus. Turpis egestas pretium aenean pharetra magna ac placerat vestibulum lectus.\n\n';
  String par_2 =
      'Pulvinar etiam non quam lacus suspendisse faucibus interdum posuere. Sed enim ut sem viverra. Et molestie ac feugiat sed lectus. Urna cursus eget nunc scelerisque viverra mauris in aliquam. Sagittis eu volutpat odio facilisis mauris. Scelerisque eu ultrices vitae auctor eu. Tellus molestie nunc non blandit massa enim nec dui nunc. Sed augue lacus viverra vitae congue eu consequat ac felis. Ultricies tristique nulla aliquet enim tortor. Diam maecenas sed enim ut sem viverra.\n\n';
  String par_3 =
      'A cras semper auctor neque vitae tempus quam. Dolor magna eget est lorem ipsum dolor sit amet. Eget egestas purus viverra accumsan in nisl nisi. Et ultrices neque ornare aenean euismod. Aliquam faucibus purus in massa tempor nec feugiat nisl. Pretium fusce id velit ut tortor. Cursus euismod quis viverra nibh. Arcu vitae elementum curabitur vitae nunc. Ut sem viverra aliquet eget sit amet tellus. Eget nunc scelerisque viverra mauris in aliquam. Eget est lorem ipsum dolor sit amet consectetur. Congue nisi vitae suscipit tellus mauris a diam maecenas sed. A lacus vestibulum sed arcu non odio euismod lacinia at. Amet risus nullam eget felis. Auctor urna nunc id cursus. Rutrum tellus pellentesque eu tincidunt tortor aliquam nulla facilisi. Malesuada fames ac turpis egestas maecenas pharetra convallis posuere. Non odio euismod lacinia at quis risus. Enim praesent elementum facilisis leo vel fringilla est ullamcorper eget. Duis at tellus at urna condimentum mattis pellentesque.';
  String widgetName = 'About us';

  void initState() {
    ConvertTTS().dictateFunction(widgetName);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'About OptiGuide',
      home: Scaffold(
        appBar: AppBar(
            title: const Text('About'),
            backgroundColor: '#ffffff'.toColor(),
            shadowColor: '#000000'.toColor(),
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back))),
        body: GestureDetector(
          onLongPress: () => Navigator.pop(context),
          child: const SingleChildScrollView(
            padding: EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                children: [
                  Text(
                    'About OptiGuide',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Image(
                    image: AssetImage('assets/logo.png'),
                    width: 200,
                    alignment: Alignment.topCenter,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'OptiGuide is designed with the specific needs of visually impaired individuals and those with visual challenges in mind. This mobile application is a tool for innovation and progress, offering a range of features tailored to enhance accessibility and independence for users with varying degrees of visual impairments. \n',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),
                  Text(
                    'With functions like object detection, text recognition, currency identification, and text-to-speech capabilities, OptiGuide provides crucial assistance for individuals navigating their surroundings, identifying objects, reading printed text, and recognizing money.\n',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),
                  Text(
                    'By empowering blind or visually impaired users to interact confidently and independently with their surroundings, OptiGuide significantly improves their overall quality of life.',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Version:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    '1.0.1+5 Beta',
                  ),
                  SizedBox(height: 20),
                  Text('Copyright ©2024'),
                  Text(
                    'Polytechnic University of the Philippines - Parañaque City Campus',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
        backgroundColor: '#dafffb'.toColor(),
        bottomNavigationBar: BottomAppBar(
          child: SizedBox(
            height: 30.0,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Developers()),
                );
              },
              child: const Text(
                'About the developers',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
