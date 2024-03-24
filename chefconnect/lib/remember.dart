import 'package:chefconnect/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(MaterialApp(
    home: RememberPage(),
  ));
}

class RememberPage extends StatefulWidget {
  @override
  _RememberPageState createState() => _RememberPageState();
}

class _RememberPageState extends State<RememberPage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: const Color(0xff1eb090),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              elevation: 4, // Ajout de l'ombre
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0), // Bord arrondi du formulaire
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Taille minime du formulaire
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green, // Couleur du cercle
                      ),
                      padding: EdgeInsets.all(24), // Marge interne du cercle
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: Icon(
                          Icons.email, // Icône d'email
                          size: 36, // Taille de l'icône
                          color: Colors.white, // Couleur de l'icône
                        ),
                      ),
                    ),
                    SizedBox(height: 16), // Espace entre l'icône et l'entrée de texte
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email',
                      ),
                    ),
                    SizedBox(height: 50), // Espace entre l'entrée de texte et le bouton
                    ElevatedButton(
                      onPressed: () {
                        _resetPassword(_emailController.text);
                      },
                      child: Text('Send Reset Code'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green, // Couleur verte
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        },
        child: Icon(Icons.arrow_forward),
      ),
    );
  }

  Future<void> _resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('An email containing a reset code has been sent to $email'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to send reset email. Error: $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
