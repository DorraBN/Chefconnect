import 'package:chefconnect/login.dart';
import 'package:chefconnect/wiem/pages/questions/questions.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(MaterialApp(
    home: Register(),
  ));
}

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _isPasswordVisible = false;
  bool _isPasswordVisible1 = false;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _imageUrlController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  bool _registerButtonClicked = false;
  RegExp passwordPattern =
      RegExp(r'^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9]).{8,}$');
  RegExp emailPattern = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  @override
  void dispose() {
    _imageUrlController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Image de fond
          DecoratedBox(
            position: DecorationPosition.background,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("../assets/R5.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(),
          ),
          Positioned(
            left: 20,
            bottom: 20,
            child: IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Positioned(
            width: 430,
            height: 520,
            left: MediaQuery.of(context).size.width / 2 - 215,
            top: MediaQuery.of(context).size.height / 2 - 260,
            child: Stack(
              children: [
                Positioned(
                  top: -80,
                  left: -80,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 35.0, vertical: 50.0),
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.restaurant,
                                size: 30, color: Colors.black),
                            SizedBox(width: 10),
                            Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            labelStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            hintText: 'Enter your username',
                            filled: true,
                            fillColor: _usernameController.text.isEmpty
                                ? Colors.white.withOpacity(0.13)
                                : Color.fromARGB(255, 37, 188, 10)
                                    .withOpacity(0.13),
                            prefixIcon:
                                Icon(Icons.person, color: Colors.black),
                            hintStyle: TextStyle(color: Colors.black),
                          ),
                          style: TextStyle(color: Colors.black),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your username';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            hintText: 'Enter your email',
                            filled: true,
                            fillColor: _emailController.text.isEmpty
                                ? Colors.white.withOpacity(0.13)
                                : Color.fromARGB(255, 55, 201, 29)
                                    .withOpacity(0.13),
                            prefixIcon:
                                Icon(Icons.email, color: Colors.black),
                            hintStyle: TextStyle(color: Colors.black),
                          ),
                          style: TextStyle(color: Colors.black),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            labelText: 'Phone',
                            labelStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            hintText: 'Enter your phone number',
                            filled: true,
                            fillColor: _phoneController.text.isEmpty
                                ? Colors.white.withOpacity(0.13)
                                : Color.fromARGB(255, 55, 201, 29)
                                    .withOpacity(0.13),
                            prefixIcon:
                                Icon(Icons.phone, color: Colors.black),
                            hintStyle: TextStyle(color: Colors.black),
                          ),
                          style: TextStyle(color: Colors.black),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            hintText: 'Enter your password',
                            filled: true,
                            fillColor: _passwordController.text.isEmpty
                                ? Colors.white.withOpacity(0.13)
                                : Color.fromARGB(255, 55, 201, 29)
                                    .withOpacity(0.13),
                            prefixIcon:
                                Icon(Icons.lock, color: Colors.black),
                            hintStyle: TextStyle(color: Colors.black),
                            suffixIcon: IconButton(
                              icon: Icon(_isPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          style: TextStyle(color: Colors.black),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (!passwordPattern.hasMatch(value)) {
                              return 'Password must contain at least one uppercase and one special character';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: !_isPasswordVisible1,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            labelStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            hintText: 'Re-enter your password',
                            filled: true,
                            fillColor: _confirmPasswordController.text.isEmpty
                                ? Colors.white.withOpacity(0.13)
                                : Color.fromARGB(255, 55, 201, 29)
                                    .withOpacity(0.13),
                            prefixIcon:
                                Icon(Icons.lock, color: Colors.black),
                            hintStyle: TextStyle(color: Colors.black),
                            suffixIcon: IconButton(
                              icon: Icon(_isPasswordVisible1
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible1 = !_isPasswordVisible1;
                                });
                              },
                            ),
                          ),
                          style: TextStyle(color: Colors.black),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please re-enter your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
SizedBox(height: 20.0,width: 26,),
Container(
  margin: EdgeInsets.symmetric(horizontal: 20.0),
  child: TextFormField(
    readOnly: true, // Rend le champ de texte en lecture seule
    controller: _imageUrlController,
    onTap: () async {
      final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.camera,
      );
      if (pickedImage != null) {
        setState(() {
          _imageUrlController.text = pickedImage.path;
        });
      }
    },
    decoration: InputDecoration(
      labelText: 'Profile image',
      labelStyle: TextStyle(color: Colors.black), // Ajout du style pour le label
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50.0), // Modification du rayon du bord
        borderSide: BorderSide(color: Colors.black),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50.0), // Modification du rayon du bord
        borderSide: BorderSide(color: Colors.black),
      ),
      hintText: 'Tap to take a picture',
      filled: true,
      fillColor: _imageUrlController.text.isEmpty
          ? Colors.white.withOpacity(0.13)
          : Color.fromARGB(255, 55, 201, 29).withOpacity(0.13),
      prefixIcon: Icon(Icons.camera_alt, color: Colors.black), // Utilisez l'icône de la caméra comme préfixe
      hintStyle: TextStyle(color: Colors.black),
    ),
    style: TextStyle(color: Colors.black),
  ),
),

       SizedBox(height: 16.0),
                        GestureDetector(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _registerButtonClicked = true;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Processing registration...'),
                                ),
                              );
                              _signup();
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 20.0),
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: _registerButtonClicked
                                  ? Colors.orange
                                  : Colors.green,
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Center(
                              child: Text(
                                'Register',
                                style: TextStyle(
                                  color: _registerButtonClicked
                                      ? Colors.white
                                      : Color(0xFF080710),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.0),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                            );
                          },
                          child: Container(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account? ",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  "Login",
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
          ),
        ],
      ),
    );
  }

  void _signup() async {
    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String imageUrl = _imageUrlController.text;
    try {
      User? user = (await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password))
          .user;
      if (user != null) {
        print("User was successfully created");
        // Enregistrement des données dans la collection Firestore
        FirebaseFirestore.instance.collection('registration').add({
          'username': username,
          'email': email,
          'phone': _phoneController.text,
          'password': password,
          'confirm': _confirmPasswordController.text,
          'imageUrl': imageUrl,
        }).then((value) {
          // Enregistrement réussi
          print('User registered successfully');
          // Pass the user's email to the onboarding process
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConcentricAnimationOnboarding(
                userEmail: email,
              ),
            ),
          );
        }).catchError((error) {
          // Erreur lors de l'enregistrement
          print('Failed to register user: $error');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to register user'),
            ),
          );
        }).whenComplete(() {
          // Optional: Any additional actions to take after registration completes
          // Réinitialisation de l'état du bouton après l'enregistrement
          setState(() {
            _registerButtonClicked = false;
          });
        });
      } else {
        print("User creation failed: User object is null");
      }
    } catch (e) {
      print("Error occurred during user creation: $e");
    }
  }
}
