import 'package:chefconnect/profile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<String> _followers = [];
  Map<String, String> _followerImageUrls = {}; // Map pour stocker les URL d'image des followers
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getFollowers();
  }

  Future<void> _getFollowers() async {
    // Récupérer l'utilisateur actuel
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      // Récupérer les documents de la collection 'following' où l'utilisateur actuel est un 'following'
      QuerySnapshot<Map<String, dynamic>> followingSnapshot = await FirebaseFirestore.instance
          .collection('following')
          .where('following', isEqualTo: currentUser.email)
          .get();

      List<String> followerEmails = [];
      followingSnapshot.docs.forEach((doc) {
        // Ajouter les adresses e-mail des 'followers' à la liste
        followerEmails.add(doc['follower']);
      });

      // Récupérer les URL d'image des followers depuis la collection 'registration'
      QuerySnapshot<Map<String, dynamic>> registrationSnapshot = await FirebaseFirestore.instance
          .collection('registration')
          .where('email', whereIn: followerEmails)
          .get();

      Map<String, String> followerImageUrls = {};
      registrationSnapshot.docs.forEach((doc) {
        followerImageUrls[doc['email']] = doc['imageUrl']; // Associer chaque e-mail à son URL d'image
      });

      setState(() {
        _followers = followerEmails;
        _followerImageUrls = followerImageUrls;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'People who start following you',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : _followers.isEmpty
                    ? Center(
                        child: Text('Aucun follower trouvé.'),
                      )
                    : ListView.builder(
                        itemCount: _followers.length,
                        itemBuilder: (BuildContext context, int index) {
                          // Comparer l'e-mail récupéré avec l'e-mail de l'utilisateur actuel
                          bool isCurrentUser = _followers[index] == FirebaseAuth.instance.currentUser?.email;

                          return ListTile(
                            title: Row(
                              children: [
                                
                                Text(_followers[index]),
                                Spacer(),
                                ElevatedButton(
                                  onPressed: () {
                                    // Rediriger vers ProfilePage2 lorsque le bouton est cliqué
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => ProfilePage2()),
                                    );
                                  },
                                  child: Text('View Profile'),
                                ),
                              ],
                            ),
                            // Afficher une image circulaire si l'e-mail correspond à celui de l'utilisateur actuel
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(_followerImageUrls[_followers[index]] ?? ''), // Utiliser l'URL d'image associée
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
