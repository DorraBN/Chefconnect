import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chefconnect/khedmet%20salma/Food.dart';
import 'package:chefconnect/wiem/pages/models/posts_data.dart';
import 'package:chefconnect/wiem/pages/widgets/categories.dart';
import 'package:chefconnect/wiem/pages/widgets/home_appbar.dart';
import 'package:chefconnect/wiem/pages/widgets/quick_and_fast_list.dart';

class Post {
  String title;
  String imageUrl;
  String ingredients;
  String authorImageUrl;
  String authorEmail; // Ajout de l'email de l'auteur

  Post({
    required this.title,
    required this.imageUrl,
    required this.ingredients,
    required this.authorImageUrl,
    required this.authorEmail,
  });

  Future<String?> fetchUserImageUrl(String email) async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('registration')
        .doc(email)
        .get();
    if (userSnapshot.exists) {
      return userSnapshot.get('imageUrl');
    } else {
      return null;
    }
  }

  factory Post.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception("Post data is null");
    }

    return Post(
      title: data['title'] ?? "", 
      imageUrl: data['imageUrl'] ?? "",
      ingredients: data['ingredients'] ?? "",
      authorImageUrl: data['authorImageUrl'] ?? "",
      authorEmail: data['email'] ?? "", // Récupérer l'email de l'auteur
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String currentCat = "All";
  List<String> followingEmails = [];
  Map<String, String> userNames = {};

  Future<void> fetchFollowingUsers() async {
    String? loggedInUserEmail = await getLoggedInUserEmail();
    if (loggedInUserEmail != null) {
      QuerySnapshot followingSnapshot = await FirebaseFirestore.instance
          .collection('following')
          .where('follower', isEqualTo: loggedInUserEmail)
          .get();
      setState(() {
        followingEmails = followingSnapshot.docs.map((doc) => doc['following'] as String).toList();
      });
    }
  }

  Future<String?> getLoggedInUserEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.email;
    } else {
      return null;
    }
  }

  Future<void> fetchUserNames() async {
    QuerySnapshot usersSnapshot = await FirebaseFirestore.instance.collection('registration').get();
    setState(() {
      userNames = Map.fromIterable(usersSnapshot.docs, key: (doc) => doc['email'], value: (doc) => doc['username']);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchFollowingUsers();
    fetchUserNames();
  }

  void _onCategorySelected(String category) {
    setState(() {
      currentCat = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 244, 206, 54),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Home'),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HomeAppbar(),
                const SizedBox(height: 20),
                const Text(
                  "Categories",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Categories(
                  currentCat: currentCat,
                  onCategorySelected: _onCategorySelected,
                ),
                const SizedBox(height: 20),
                QuickAndFastList(foods: FoodList.foods),
                const SizedBox(height: 20),
                const Text(
                  "Posts",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('posts').snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator(); // Afficher un indicateur de chargement si les données ne sont pas encore disponibles
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot postSnapshot = snapshot.data!.docs[index];
                        Post post = Post.fromSnapshot(postSnapshot);

                        String authorUsername = userNames[post.authorEmail] ?? "";

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                 CircleAvatar(
  radius: 20,
  child: FutureBuilder<String?>(
    future: post.fetchUserImageUrl(post.authorEmail),
    builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator(); // Afficher un indicateur de chargement en attendant que l'URL de l'image soit récupérée
      } else {
        if (snapshot.hasError || !snapshot.hasData) {
          return CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey, // Utilisez une couleur de remplacement en cas d'erreur ou de données manquantes
          );
        } else {
          return CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(snapshot.data!), // Utiliser l'URL de l'image récupérée
          );
        }
      }
    },
  ),
),

                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        authorUsername, // Afficher le nom d'utilisateur à la place du titre
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text(
                                        post.authorEmail, // Afficher l'email de l'auteur
                                      ),
                                     
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                   
                                    const SizedBox(height: 10),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        post.imageUrl,
                                        width: double.infinity,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                     Text(
  "Title: ${post.title}", // Afficher le titre de la recette
  style: const TextStyle(
    fontWeight: FontWeight.bold,
  ),
),
Text(
  "Ingredients: ${post.ingredients}",
  style: const TextStyle(
    fontWeight: FontWeight.bold,
  ),
),

                                  ],
                                  
                                ),
                              ),
                              const SizedBox(height: 20),
                               Row(
                                        children: [
                                          Icon(Icons.thumb_up),
                                          SizedBox(width: 5),
                                          Text('Like', style: TextStyle(fontWeight: FontWeight.bold)),
                                          SizedBox(width: 10),
                                          Icon(Icons.comment),
                                          SizedBox(width: 5),
                                          Text('Comment', style: TextStyle(fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ), 
    );
  }
}
