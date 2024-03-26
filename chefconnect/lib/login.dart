import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:chefconnect/firebaseAuthImp.dart';
import 'package:chefconnect/remember.dart';
import 'package:chefconnect/wiem/pages/screens/home_screen.dart';
import 'register.dart';

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
  final FirebaseAuthService _auth = FirebaseAuthService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  String? _emailErrorText;
  String? _passwordErrorText;
  bool _rememberMe = false;
  bool _isLoading = false;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: '54968741572-hd129o6g7v8lov654nbuadclq973rsk5.apps.googleusercontent.com',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          DecoratedBox(
            position: DecorationPosition.background,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Color.fromARGB(255, 114, 242, 108),
                  Color.fromARGB(255, 244, 207, 84),
                ],
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
                Navigator.pop(context);
              },
              color: Colors.black,
            ),
          ),
          Center(
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
                          Icon(Icons.restaurant, size: 30, color: Colors.black),
                          SizedBox(width: 10),
                          Text(
                            'Login In',
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
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(50.0),
    color: Colors.white.withOpacity(0.13), // Couleur de fond avec opacité
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2), // Couleur de l'ombre avec opacité
        spreadRadius: 1,
        blurRadius: 5,
        offset: Offset(0, 3), // Décalage de l'ombre
      ),
    ],
  ),
  child: TextFormField(
    controller: _emailController,
    decoration: InputDecoration(
      labelText: 'Email',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50.0),
      ),
      hintText: 'Enter your email',
      filled: true,
      fillColor: Colors.white, // Fond transparent pour permettre à l'ombre de se voir
      prefixIcon: Icon(Icons.email, color: Colors.black),
      hintStyle: TextStyle(color: Colors.black),
      errorText: _emailErrorText,
    ),
    style: TextStyle(color: Colors.black),
  ),
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
                          fillColor: Colors.white.withOpacity(0.13),
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
                          errorText: _passwordErrorText,
                        ),
                        style: TextStyle(color: Colors.black),
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
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _signIn,
                        child: _isLoading
                            ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                            : Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25.0),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '--or--',
                            style: TextStyle(color: Colors.black, fontSize: 16.0),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    ElevatedButton.icon(
      icon: Icon(Icons.facebook),
      label: Text('Login with Facebook'),
      onPressed: () {}, // Fonction vide, le bouton ne fera rien quand il sera pressé
    ),
  

                         
                         ElevatedButton.icon(
  onPressed: _signInWithGoogle,
  icon: CircleAvatar(
    radius: 10,
    backgroundImage: AssetImage('../../assets/google.png'),
  ),
  label: Text('Login with Google'),
  style: ElevatedButton.styleFrom(
    primary: Colors.red, // Couleur du bouton
    onPrimary: Colors.white, // Couleur du texte
  ),
)

                        ],
                      ),
                      SizedBox(height: 16.0),
                      Container(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () {
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
        ],
      ),
    );
  }

  void _signIn() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    setState(() {
      _emailErrorText = 'Please enter your email';
      _passwordErrorText = null;
      _isLoading = true; // Set loading state to true
    });

    if (email.isEmpty) {
      setState(() {
        _emailErrorText = 'Please enter your email';
        _isLoading = false; // Set loading state to false
      });
      return;
    }

    if (password.isEmpty) {
      setState(() {
        _passwordErrorText = 'Please enter your password';
        _isLoading = false; // Set loading state to false
      });
      return;
    }

    try {
      User? user = await _auth.signInWithEmailAndPassword(email, password);
      if (user != null) {
        print("User was successfully logged In");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        setState(() {
          _emailErrorText = 'Email or password is incorrect';
          _passwordErrorText = 'Email or password is incorrect';
          _isLoading = false; // Set loading state to false
        });
      }
    } catch (e) {
      print("Error occurred during user login: $e");
      setState(() {
        _emailErrorText = 'An error occurred. Please try again later';
        _passwordErrorText = 'An error occurred. Please try again later';
        _isLoading = false; // Set loading state to false
      });
    }
  }

  void _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );
        await _firebaseAuth.signInWithCredential(credential);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } catch (e) {
      print("Some error occurred: $e");
    }
  }
/*
  void _signInWithFacebook() async {
  try {
    // Déclencher le flux de connexion
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      // Créer un jeton d'authentification à partir du jeton d'accès
      final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(result.accessToken!.token);

      // Une fois connecté, retourner le UserCredential
      await _firebaseAuth.signInWithCredential(facebookAuthCredential);

      // Naviguer vers l'écran d'accueil
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      print("La connexion Facebook a échoué");
    }
  } catch (e) {
    print("Une erreur s'est produite lors de la connexion Facebook: $e");
  }
}
*/
}
