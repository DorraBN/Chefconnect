import 'package:flutter/material.dart';
import 'package:flutter_application_1/RecipeDetails.dart';
import 'package:flutter_application_1/login_page.dart';
import 'package:flutter_application_1/ChatHome.dart';
import 'package:flutter_application_1/SearchPage.dart';
import 'package:flutter_application_1/SearchHome.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Urbanist',
      ),
      home: SearchHome(),
    );
  }
}
