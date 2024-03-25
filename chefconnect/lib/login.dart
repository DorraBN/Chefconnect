import 'package:chefconnect/myprofile.dart';
import 'package:chefconnect/remember.dart';
import 'package:chefconnect/wiem/pages/screens/home_screen.dart';
import 'package:chefconnect/wiem/pages/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'register.dart'; // Importez la classe RegisterPage depuis le fichier register.dart
 // Importez la classe ProfilePage1 depuis le fichier profile.dart

void main() {
  runApp(MaterialApp(
    home: LoginPage(),
  ));
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Image de fond
         DecoratedBox(
  position: DecorationPosition.background,
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: [Color.fromARGB(255, 114, 242, 108), Color.fromARGB(255, 244, 207, 84)],
    ),
    image: DecorationImage(
      image: AssetImage("assets/R5.png"), // Chemin de votre image
      fit: BoxFit.cover,
    ),
  ),
  child: Container(),
),

          Positioned(
            left: 20,
            bottom: 20,
            top: 590,
            child: IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.pop(context); // Retour à la page initiale
              },
              color: Colors.black,
            ),
          ),
          Center( // Centrer le container verticalement et horizontalement
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 35.0, vertical: 50.0),
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.restaurant,
                              size: 30, color: Colors.black), // Icône de restaurant
                          SizedBox(width: 10),
                          
                          Text(
                            'Login In',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ), // form h3
                        ],
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          hintText: 'Enter your email',
                          filled: true,
                          fillColor:
                              Colors.white.withOpacity(0.13), // background-color: rgba(255,255,255,0.13);
                          prefixIcon: Icon(Icons.email, color: Colors.black),
                          hintStyle: TextStyle(color: Colors.black),
                        ),
                        style: TextStyle(color: Colors.black), // form *
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          // Add email validation logic if needed
                          return null;
                        },
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          hintText: 'Enter your password',
                          filled: true,
                          fillColor:
                              Colors.white.withOpacity(0.13), // background-color: rgba(255,255,255,0.13);
                          prefixIcon: Icon(Icons.lock, color: Colors.black),
                          hintStyle: TextStyle(color: Colors.black),
                          suffixIcon: IconButton(
                            icon: Icon(_isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        style: TextStyle(color: Colors.black), // form *
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value ?? false;
                                  });
                                },
                              ),
                              Text(
                                'Remember me',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigate to the password reset page (RememberPage)
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => RememberPage()),
                              );
                            },
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          // Add login logic here
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MainScreen()),
                          );
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 20,
                          vertical: 25.0), // Espacement interne du bouton
                    // Taille minimale du bouton
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('--or--', style: TextStyle(color: Colors.black, fontSize: 16.0)),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.facebook),
                            label: Text('Login with Facebook'),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.email),
  label: Text('Login with Google'),
  style: ElevatedButton.styleFrom(
    foregroundColor: Colors.white, backgroundColor: Colors.red, // Change la couleur du texte du bouton
  ),
 
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      Container(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () {
                            // Navigate to the registration page (RegisterPage)
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Register()),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "already have an account? ",
                                style: TextStyle(fontSize: 12, color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "Register",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue),
                              ),
                              Icon(Icons.arrow_forward, color: Colors.blue),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
