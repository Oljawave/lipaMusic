import 'package:flutter/material.dart';
import 'package:lipa_music/pages/HomePage.dart';
import 'package:lipa_music/pages/MusicPage.dart';
import 'package:lipa_music/pages/PlayListPage.dart';
import 'package:lipa_music/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: {
        "homePage": (context) => const HomePage(),
        "playlistPage": (context) => PlayListPage(),
        "MusicPage": (context) => MusicPage(),
      },
    );
  }
}
