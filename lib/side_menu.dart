import 'package:flutter/material.dart';
import 'package:optiguide_app/about.dart';
import 'package:optiguide_app/extensions.dart';
import 'package:optiguide_app/tutorial.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: '#dafffb'.toColor(), // Customize the background color
        width:
            MediaQuery.of(context).size.width * 0.5, // Half of the screen width
        height: 40,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: '#64ccc5'.toColor(),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                    color: '#000000'.toColor(),
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              title: Text(
                'Tutorial',
                style: TextStyle(color: '#000000'.toColor()),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Tutorial(onFinish: () {
                            Navigator.pop(context);
                          })),
                );
              },
            ),
            ListTile(
              title:
                  Text('About', style: TextStyle(color: '#000000'.toColor())),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => About()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
