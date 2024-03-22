import 'package:flutter/material.dart';

class SecurityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(backgroundColor: Color.fromARGB(255, 244, 206, 54),
       title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          
            Text('Security'),
            
            IconButton(
              icon: Icon(Icons.security_outlined),
              onPressed: () {
                // Add logic to edit profile
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Change Password',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Current Password',
                icon: Icon(Icons.lock, color: Colors.black), // Ajout de l'icône de cadenas
              ),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'New Password',
                icon: Icon(Icons.lock, color: Colors.black), // Ajout de l'icône de cadenas
                suffixIcon: Icon(Icons.visibility), // Ajout de l'icône d'œil pour afficher le mot de passe
              ),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Confirm New Password',
                icon: Icon(Icons.lock, color: Colors.black), // Ajout de l'icône de cadenas
                suffixIcon: Icon(Icons.visibility), // Ajout de l'icône d'œil pour afficher le mot de passe
              ),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            Center(
              // Centrer le bouton
              child: Padding(
                // Ajouter du padding au bouton
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                child: ElevatedButton(
                  onPressed: () {
                    // Add logic to change password here
                    // For example, you can validate the new password and send it to an API
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Password changed successfully'),
                      ),
                    );
                  },
                  child: Text(
                    'Change Password',
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green, // Définir la couleur de fond du bouton
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Two-Factor Authentication',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            SwitchListTile(
              title: Text('Enable Two-Factor Authentication'),
              value: true, // Replace with the actual value from your app state
              onChanged: (value) {
                // Add logic to enable/disable two-factor authentication here
                // For example, you can update the user's preferences
              },
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SecurityPage(),
  ));
}
