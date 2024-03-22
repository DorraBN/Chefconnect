import 'package:flutter/material.dart';
import 'package:flutter_application_pfa/pages/screens/main_screen.dart';
import 'package:flutter_application_pfa/pages/questions/questions.dart';
import 'package:flutter_application_pfa/pages/welcome/welcome.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      //home: WelcomePage(),
      //home: ConcentricAnimationOnboarding() ,
      home: MainScreen(),
    );
  }
}
