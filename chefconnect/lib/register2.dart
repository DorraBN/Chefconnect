import 'package:flutter/material.dart';
import 'login.dart'; // Importez la page de connexion

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

  final _formKey = GlobalKey<FormState>();
  String _selectedGender = '';
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _pseudoController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  bool _registerButtonClicked = false; // Etat du bouton "Register" 
  // Expression régulière exigeant une longueur minimale de 8 caractères avec au moins une lettre majuscule, une lettre minuscule, un chiffre et un caractère spécial
RegExp passwordPattern = RegExp(r'^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9]).{8,}$');


RegExp emailPattern = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');


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
                image: AssetImage("assets/1.png"), // Remplacez "assets/background_image.jpg" par le chemin de votre image
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
                Navigator.pop(context); // Retour à la page initiale
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
                            Icon(Icons.restaurant, size: 30, color: Colors.black), // Icône de restaurant
                            SizedBox(width: 10),
                            Text(
                              'Sign Up',
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
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            hintText: 'Enter your username',
                            filled: true,
                            fillColor: _usernameController.text.isEmpty ? Colors.white.withOpacity(0.13) : Color.fromARGB(255, 37, 188, 10).withOpacity(0.13),
                            prefixIcon: Icon(Icons.person, color: Colors.black),
                            hintStyle: TextStyle(color: Colors.black),
                          ),
                          style: TextStyle(color: Colors.black), // form *
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your username';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          controller: _pseudoController,
                          decoration: InputDecoration(
                            labelText: 'Pseudo',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            hintText: 'Enter your pseudo name',
                            filled: true,
                            fillColor: _pseudoController.text.isEmpty ? Colors.white.withOpacity(0.13) : Color.fromARGB(255, 55, 201, 29).withOpacity(0.13),
                            prefixIcon: Icon(Icons.person, color: Colors.black),
                            hintStyle: TextStyle(color: Colors.black),
                          ),
                          style: TextStyle(color: Colors.black), // form *
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your pseudo name';
                            }
                            return null;
                          },
                        ),
                       SizedBox(height: 10.0),
TextFormField(
  controller: _emailController,
  decoration: InputDecoration(
    labelText: 'Email',
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50.0),
    ),
    hintText: 'Enter your email',
    filled: true,
    fillColor: _emailController.text.isEmpty ? Colors.white.withOpacity(0.13) : Color.fromARGB(255, 55, 201, 29).withOpacity(0.13),
    prefixIcon: Icon(Icons.email, color: Colors.black),
    hintStyle: TextStyle(color: Colors.black),
  ),
  style: TextStyle(color: Colors.black), // form *
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!emailPattern.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  },
),

                        SizedBox(height: 10.0),
                        TextFormField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            labelText: 'Phone',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            hintText: 'Enter your phone number',
                            filled: true,
                            fillColor: _phoneController.text.isEmpty ? Colors.white.withOpacity(0.13) : Color.fromARGB(255, 55, 201, 29).withOpacity(0.13),
                            prefixIcon: Icon(Icons.phone, color: Colors.black),
                            hintStyle: TextStyle(color: Colors.black),
                          ),
                          style: TextStyle(color: Colors.black), // form *
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
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50.0),
    ),
    hintText: 'Enter your password',
    filled: true,
    fillColor: _passwordController.text.isEmpty ? Colors.white.withOpacity(0.13) : Color.fromARGB(255, 55, 201, 29).withOpacity(0.13),
    prefixIcon: Icon(Icons.lock, color: Colors.black),
    hintStyle: TextStyle(color: Colors.black),
    suffixIcon: IconButton(
      icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility),
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
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            hintText: 'Re-enter your password',
                            filled: true,
                            fillColor: _confirmPasswordController.text.isEmpty ? Colors.white.withOpacity(0.13) : Color.fromARGB(255, 55, 201, 29).withOpacity(0.13),
                            prefixIcon: Icon(Icons.lock, color: Colors.black),
                            hintStyle: TextStyle(color: Colors.black),
                            suffixIcon: IconButton(
                              icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility),
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
                              return 'Please re-enter your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          children: <Widget>[
                            Text('Gender:', style: TextStyle(fontSize: 14, color: Colors.black)),
                            SizedBox(width: 10),
                            Radio(
                              value: 'Male',
                              groupValue: _selectedGender,
                              onChanged: (value) {
                                setState(() {
                                  _selectedGender = value.toString();
                                });
                              },
                            ),
                            Text('Male', style: TextStyle(fontSize: 14, color: Colors.black)),
                            SizedBox(width: 10),
                            Radio(
                              value: 'Female',
                              groupValue: _selectedGender,
                              onChanged: (value) {
                                setState(() {
                                  _selectedGender = value.toString();
                                });
                              },
                            ),
                            Text('Female', style: TextStyle(fontSize: 14, color: Colors.black)),
                          ],
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
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 20.0),
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: _registerButtonClicked ? Colors.orange : Colors.green,
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Center(
                              child: Text(
                                'Register',
                                style: TextStyle(
                                  color: _registerButtonClicked ? Colors.white : Color(0xFF080710),
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
                            // Naviguer vers la page de connexion
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage()),
                            );
                          },
                          child: Container(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account? ",
                                  style: TextStyle(fontSize: 12, color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  "Login",
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue),
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
}



