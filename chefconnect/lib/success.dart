import 'package:chefconnect/wiem/pages/questions/questions.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(MaterialApp(
    home: RegistrationSuccessPage(),
  ));
}

class RegistrationSuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 114, 242, 108),
                  Color.fromARGB(255, 244, 207, 84),
                ],
              ),
            ),
          ),
          // Content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 120,
                color: Colors.white,
              ),
              SizedBox(height: 20),
              Text(
                'Registration Successful!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Welcome to ChefConnect, your ultimate cooking companion.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          // Next Button
          Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ConcentricAnimationOnboarding()),
                );
              },
              label: Text(
                'Next',
                style: TextStyle(fontSize: 18),
              ),
              icon: Icon(Icons.arrow_forward),
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
