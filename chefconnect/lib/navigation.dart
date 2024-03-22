import 'package:chefconnect/profile.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:chefconnect/myprofile.dart'; // Importer la page de profil

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: Colors.white,
      buttonBackgroundColor: Colors.green,
      color: Colors.green,
      animationDuration: Duration(milliseconds: 300),
      items: const <Widget>[
        Icon(Icons.home, size: 26, color: Colors.white),
        Icon(Icons.message, size: 26, color: Colors.white),
        Icon(Icons.add, size: 26, color: Colors.white),
        Icon(Icons.favorite, size: 26, color: Colors.white),
        Icon(Icons.notifications, size: 26, color: Colors.white),
        Icon(Icons.person, size: 26, color: Colors.white),
      ],
      onTap: (index) {
        // Vérifier si l'icône de profil est cliquée (index 5)
        if (index == 1) {
          // Naviguer vers la page de profil
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage2()),
          );
        }
      },
    );
  }
}
