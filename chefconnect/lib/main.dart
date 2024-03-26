<<<<<<< HEAD

import 'package:chefconnect/khedmet%20salma/ChatScreen.dart';
=======
>>>>>>> eb34d7681e5dc6cc46bc4f88e2f59525a20e2525
import 'package:chefconnect/wiem/pages/welcome/welcome.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // Importez kIsWeb pour détecter si l'application est web


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    // Initialisation de Firebase pour les applications web
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyDScAg-Rj4X63Sgs8RJCRxgZPsDeIc7fKE",
        appId: "1:54968741572:android:02d1e53c680040c7ece391",
        messagingSenderId: "your key",
        projectId: "chefconnect-2ac02",
      ),
    );
  } else {
    // Initialisation de Firebase pour les applications non web
try {
  await Firebase.initializeApp();
} catch (e) {
  print('Error initializing Firebase: $e');
}
  }

  // Lancez l'application Flutter
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
    //  home: ProfilePage(), 
    home:ChatScreen()// Remplacez ceci par une instance de Register
      // home: ConcentricAnimationOnboarding() ,
     // home: MainScreen(),
    );
  }
}
