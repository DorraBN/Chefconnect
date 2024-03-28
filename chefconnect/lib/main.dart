
import 'package:chefconnect/newpost.dart';
import 'package:chefconnect/wiem/pages/screens/main_screen.dart';
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
    await Firebase.initializeApp();
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
        home:NewPostPage()// Remplacez ceci par une instance de Register
      // home: ConcentricAnimationOnboarding() ,
     //home: MainScreen(),
    );
  }
}
