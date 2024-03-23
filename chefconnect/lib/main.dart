import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // Importez kIsWeb pour détecter si l'application est web

import 'package:chefconnect/wiem/pages/welcome/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    // Initialisation de Firebase pour les applications web
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "your key",
        appId: "1:54968741572:android:02d1e53c680040c7ece391",
        messagingSenderId: "your key",
        projectId: "chefconnect-2ac02",
      ),
    );
  } else {
    // Initialisation de Firebase pour les applications non web
    await Firebase.initializeApp();
  }

  // Lancez l'application Flutter
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: WelcomePage(), // Remplacez ceci par une instance de Register
      // home: ConcentricAnimationOnboarding() ,
      // home: MainScreen(),
    );
  }
}
