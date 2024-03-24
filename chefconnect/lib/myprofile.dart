import 'package:chefconnect/myposts.dart';
import 'package:chefconnect/navigation.dart';

import 'package:chefconnect/setings.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';


class ProfilePage1 extends StatelessWidget {
  const ProfilePage1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Color.fromARGB(255, 244, 206, 54),
        
        actions: [
        
          PopupMenuButton<String>(
            offset: Offset(0, 40), // Décalage vers le bas pour placer le menu sous l'icône
            onSelected: (value) {
              if (value == 'settings') {
            
                          // Add login logic here
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SettingsPage2()),
                          );
                        
              } else if (value == 'logout') {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Fermer la boîte de dialogue
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
               FirebaseAuth.instance.signOut();
              // Add logout logic here
              // Rediriger vers la page d'accueil après la déconnexion
              Navigator.pushReplacementNamed(context, '/');
            },
            child: Text('Logout'),
          ),
        ],
      );
    },
  );
}

            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'settings',
                child: Container(
                  width: 120, // Largeur du PopupMenuItem
                  child: ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Settings'),
                    contentPadding: EdgeInsets.zero, // Aucun padding interne
                  ),
                ),
              ),
              PopupMenuItem<String>(
                value: 'logout',
                child: Container(
                  width: 120, // Largeur du PopupMenuItem
                  child: ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Log out'),
                    contentPadding: EdgeInsets.zero, // Aucun padding interne
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          const Expanded(flex: 2, child: _TopPortion()),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    "Joe Doe",
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                   
                  ),
                  const SizedBox(height: 16),
                  const _ProfileInfoRow(),
                  const SizedBox(height: 16),
                  GestureDetector( // Ajouter GestureDetector pour gérer le clic
                    onTap: () {
                      Navigator.push( // Naviguer vers la page NewsFeedPage1
                        context,
                        MaterialPageRoute(builder: (context) => NewsFeedPage2()),
                      );
                    },
                    child: Text( // Texte "Publications" enveloppé dans GestureDetector
                      "Posts",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),               
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
class _AvatarImage extends StatelessWidget {
  final String url;
  const _AvatarImage(this.url, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(image: NetworkImage(url))),
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  const _ProfileInfoRow({Key? key}) : super(key: key);

  final List<ProfileInfoItem> _items = const [
    ProfileInfoItem("Likes", 900),
    ProfileInfoItem("Followers", 120),
    ProfileInfoItem("Following", 200),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      constraints: const BoxConstraints(maxWidth: 400),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _items
            .map((item) => Expanded(
                  child: Row(
                    children: [
                      if (_items.indexOf(item) != 0) const VerticalDivider(),
                      Expanded(child: _singleItem(context, item)),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _singleItem(BuildContext context, ProfileInfoItem item) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              item.value.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Text(
            item.title,
            style: Theme.of(context).textTheme.caption,
          )
        ],
      );
}

class ProfileInfoItem {
  final String title;
  final int value;
  const ProfileInfoItem(this.title, this.value);
}

class _TopPortion extends StatelessWidget {
  const _TopPortion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 50),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Color.fromARGB(255, 114, 242, 108), Color.fromARGB(255, 244, 207, 84)],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        'https://th.bing.com/th/id/OIP.YWf2ipWdTwok7T4_sx75mgHaHa?rs=1&pid=ImgDetMain',
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}


class FeedItem {
  final User user;
  final String? content;

  FeedItem(this.user, this.content);
}

class User {
  final String fullName;
  final String imageUrl;

  User(this.fullName, this.imageUrl);
}

final List<FeedItem> _feedItems = [
  FeedItem(
    User('John Doe', 'https://www.example.com/johndoe.jpg'),
    'Hello, world!',
  ),
  FeedItem(
    User('Jane Smith', 'https://www.example.com/janesmith.jpg'),
    'Flutter is awesome!',
  ),
  FeedItem(
    User('James Brown', 'https://www.example.com/jamesbrown.jpg'),
    null,
  ),
];

