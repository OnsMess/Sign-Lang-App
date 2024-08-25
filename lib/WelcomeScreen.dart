import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'loginScreen.dart';
import 'regScreen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromARGB(255, 190, 237, 248),
          Color.fromARGB(255, 126, 204, 250),
        ])),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 120.0),
              child: Image(image: AssetImage('assets/logo.png')),
            ),
            const SizedBox(
              height: 100,
            ),
            AnimatedTextKit(
              animatedTexts: [
                TyperAnimatedText(
                  'Bienvenue',
                  textStyle: const TextStyle(
                    fontFamily: 'Pacifico',
                    fontSize: 34,
                    color: Color.fromARGB(255, 115, 73, 232),
                  ),
                  speed: const Duration(milliseconds: 200),
                ),
              ],
              totalRepeatCount: 1,
              pause: const Duration(milliseconds: 1000),
              displayFullTextOnTap: true,
              stopPauseOnTap: true,
            ),
            const SizedBox(
              height: 50,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: Container(
                height: 53,
                width: 320,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                    color: Color.fromARGB(255, 244, 14, 236),
                    width: 2,
                  ),
                ),
                child: const Center(
                  child: Text(
                    "Se connecter",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 244, 14, 236),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RegScreen()));
              },
              child: Container(
                height: 53,
                width: 320,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                      color: Color.fromARGB(255, 105, 59, 231), width: 2),
                ),
                child: const Center(
                  child: Text(
                    "S'inscrire",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 105, 59, 231),
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
