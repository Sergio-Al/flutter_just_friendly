import 'package:family_chat/main.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroScreen extends StatelessWidget {
  IntroScreen({super.key});

  final listPagesViewModel = [
    PageViewModel(
      title: "Pal Chat",
      body: "Welcome to the app! Chat with your family or friends.",
      image: const Center(
        child: Icon(Icons.waving_hand, size: 50.0),
      ),
    ),
    PageViewModel(
      title: "Title of orange text and bold page",
      body:
          "This is a description on a page with an orange title and bold, big body.",
      image: const Center(
        child: Text("👋", style: TextStyle(fontSize: 100.0)),
      ),
      decoration: const PageDecoration(
        titleTextStyle: TextStyle(color: Colors.orange),
        bodyTextStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0),
      ),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: listPagesViewModel,
      showSkipButton: true,
      skip: const Icon(Icons.skip_next),
      next: const Text("Next"),
      done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w700)),
      onDone: () async {
        // In this part, it begins navigating to another screen
        // then it saves the state in sharedpreferences.
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext ctx) => const MyHomePage(title: 'Hello'),
          ),
        );

        final preferences = await SharedPreferences.getInstance();
        preferences.setBool('showHome', true);
        // On Done button pressed
      },
      onSkip: () {
        // On Skip button pressed
      },
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeColor: Theme.of(context).colorScheme.secondary,
        color: Colors.black26,
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      ),
    );
  }
}
