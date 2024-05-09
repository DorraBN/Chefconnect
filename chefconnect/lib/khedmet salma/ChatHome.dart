import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'ChatScreen.dart';

class ChatHome extends StatelessWidget {
  const ChatHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.green,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Messages',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Quicksand',
                          fontSize: 30,
                          color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
            Padding(
  padding: EdgeInsets.all(16.0),
  child: Text(
    'R E C E N T',
    style: TextStyle(
      color: Colors.white,
      fontSize: 14, // Réduisez la taille de police ici
    ),
  ),
),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: SizedBox(
                  height: 110,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('following').where('follower', isEqualTo: currentUser!.email).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (!snapshot.hasData || snapshot.data == null) {
                        return SizedBox(); // Si pas de données, retourne un conteneur vide
                      }
                      List<DocumentSnapshot> following = snapshot.data!.docs;

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: following.length,
                        itemBuilder: (context, index) {
                          var user = following[index].data() as Map<String, dynamic>;
                          var followingUser = user['following']; // Accédez à l'attribut 'following'
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(user['photoURL'] ?? ''), // Vérifie si l'URL de l'image est null
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                followingUser ?? '', // Affiche le contenu de l'attribut 'following'
                                style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold,),
                              )
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 555,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('following').where('following', isEqualTo: currentUser!.email).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (!snapshot.hasData || snapshot.data == null) {
                      return SizedBox(); // Si pas de données, retourne un conteneur vide
                    }
                    List<DocumentSnapshot> followers = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: followers.length,
                      itemBuilder: (context, index) {
                        var user = followers[index].data() as Map<String, dynamic>;
                        var followerUser = user['follower']; // Accédez à l'attribut 'follower'
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ChatScreen()),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 26.0, top: 35, right: 10),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: NetworkImage(user['photoURL'] ?? ''), // Vérifie si l'URL de l'image est null
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          followerUser ?? '', // Affiche le contenu de l'attribut 'follower'
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Quicksand',
                                            fontSize: 17,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 100,
                                        ),
                                        Text(
                                          'Follower', // Vous pouvez ajouter un indicateur ici pour distinguer les followers des followings
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    // Ajoutez ici d'autres informations sur les followers si nécessaire
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
