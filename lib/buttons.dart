import 'package:flutter/material.dart';
import 'package:optiguide_app/extensions.dart';

class Buttons {
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
