import 'package:chefconnect/register.dart';
import 'package:chefconnect/wiem/pages/questions/questions.dart';
import 'package:chefconnect/wiem/pages/screens/main_screen.dart';
import 'package:chefconnect/wiem/pages/welcome/welcome.dart';
import 'package:flutter/material.dart';


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
   home:  WelcomePage(), // Remplacez ceci par une instance de Register


     // home: ConcentricAnimationOnboarding() ,
      //home: MainScreen(),
    );
  }
}
