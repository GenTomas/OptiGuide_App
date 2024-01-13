import 'package:flutter/material.dart';
//import 'package:optiguide_app/extra_pages.dart';
import 'package:optiguide_app/object_recog.dart';
import 'package:optiguide_app/pages/home_page.dart';
import 'package:optiguide_app/text_recog.dart';

class Pages extends StatefulWidget {
  const Pages({super.key});

  @override
  State<Pages> createState() => _PagesState();
}

class _PagesState extends State<Pages> {
  PageController pageController = PageController();

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
          controller: pageController,
          itemBuilder: (context, index) {
            return getPage(index % 3);
          }),
    );
  }

  Widget getPage(int index) {
    switch (index) {
      case 0:
        return const ObjectRecog();
      case 1:
        return const TextRecog();
      case 2:
        return const HomePage();
      default:
        return const ObjectRecog(); // Placeholder, you can customize this based on your needs
    }
  }
}
