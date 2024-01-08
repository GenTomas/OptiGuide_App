import 'package:flutter/material.dart';
import 'package:optiguide_app/extensions.dart';

// Test Page 1

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

// Test Page 2

class SampleApp2 extends StatefulWidget {
  const SampleApp2({super.key});

  @override
  State<SampleApp2> createState() => _SampleApp2State();
}

class _SampleApp2State extends State<SampleApp2> {
  int bounty = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: '#dafffb'.toColor(),
      appBar: AppBar(
        title: const Text('Sample App 2'),
        centerTitle: true,
        backgroundColor: '#03e9d2'.toColor(),
        elevation: 0.0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            bounty += 10000000;
          });
        },
        backgroundColor: '#9e9e9e'.toColor(),
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Center(
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/Luffy.jpg'),
                radius: 70.0,
              ),
            ),
            Divider(
              height: 60.0,
              color: '#008275'.toColor(),
            ),

            //Pirate Name
            Text(
              'NAME',
              style: TextStyle(color: '#000000'.toColor(), letterSpacing: 2.0),
            ),
            const SizedBox(height: 10.0),
            Text(
              'Monkey D. Luffy',
              style: TextStyle(
                  color: '#575757'.toColor(),
                  letterSpacing: 2.0,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30.0),

            //Pirate Group
            Text(
              'Pirate Group',
              style: TextStyle(color: '#000000'.toColor(), letterSpacing: 2.0),
            ),
            const SizedBox(height: 10.0),
            Text(
              'Straw Hat Pirates',
              style: TextStyle(
                  color: '#575757'.toColor(),
                  letterSpacing: 2.0,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30.0),

            //Bounty
            Text(
              'Current Bounty',
              style: TextStyle(color: '#000000'.toColor(), letterSpacing: 2.0),
            ),
            const SizedBox(height: 10.0),
            Text(
              'B $bounty',
              style: TextStyle(
                  color: '#575757'.toColor(),
                  letterSpacing: 2.0,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30.0),

            Row(
              children: <Widget>[
                Icon(
                  Icons.email,
                  color: '#575757'.toColor(),
                ),
                const SizedBox(width: 10.0),
                Text(
                  'mdluffykaizoku@pirates.com',
                  style: TextStyle(
                      color: '#575757'.toColor(),
                      fontSize: 20.0,
                      letterSpacing: 1.0),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
