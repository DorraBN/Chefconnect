import 'package:chefconnect/khedmet%20salma/ChatHome.dart';
import 'package:chefconnect/wiem/pages/widgets/favorite_api_recipes.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';


import 'myprofile.dart';
import 'newpost.dart';
import 'wiem/pages/screens/home_screen.dart';


class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: Colors.white,
      buttonBackgroundColor: Colors.green,
      color: Colors.green,
      animationDuration: Duration(milliseconds: 300),
      animationCurve: Curves.easeInOut,
      items: const <Widget>[
        Icon(Icons.home, size: 26, color: Colors.white),
        Icon(Icons.message, size: 26, color: Colors.white),
        Icon(Icons.add, size: 26, color: Colors.white),
        Icon(Icons.favorite, size: 26, color: Colors.white),
        Icon(Icons.notifications, size: 26, color: Colors.white),
        Icon(Icons.person, size: 26, color: Colors.white),
      ],
      onTap: (index) {
        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatHome()),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewPostPage()),
          );
        } else if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FavoriteApiScreen()),
          );
        } else if (index == 4) {
          // Remplacez NewPostPage() par la page de notification souhaitée
          // Exemple: Navigator.push(
          //            context,
          //            MaterialPageRoute(builder: (context) => NotificationPage()),
          //          );
        } else if (index == 5) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage1()),
          );
        }
      },
    );
  }
}
