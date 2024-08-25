import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:signlang/firebase_options.dart';
import 'WelcomeScreen.dart';
import 'loginScreen.dart';
import 'regScreen.dart';
import 'cameraScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'inter',
        useMaterial3: true,
      ),
      home: WelcomeScreen(),
      routes: {
        '/camera': (context) => CameraScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegScreen(),
      },
    );
  }
}
