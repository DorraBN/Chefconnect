import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chefconnect/khedmet%20salma/Food.dart';
import 'package:chefconnect/wiem/pages/models/posts_data.dart';
import 'package:chefconnect/wiem/pages/widgets/categories.dart';
import 'package:chefconnect/wiem/pages/widgets/home_appbar.dart';
import 'package:chefconnect/wiem/pages/widgets/quick_and_fast_list.dart';

// Définition de la classe Post
class Post {
  String title;
  String imageUrl;
  String ingredients;
  String authorImageUrl;
  String authorEmail;

  // Constructeur de la classe Post
  Post({
    required this.title,
    required this.imageUrl,
    required this.ingredients,
    required this.authorImageUrl,
    required this.authorEmail,
  });

  // Méthode pour récupérer l'URL de l'image de l'utilisateur à partir de son e-mail
  Future<String?> fetchUserImageUrl(String email) async {
    QuerySnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('registration')
        .where('email', isEqualTo: email)
        .get();
    if (userSnapshot.docs.isNotEmpty) {
      return userSnapshot.docs.first.get('imageUrl');
    } else {
      return null;
    }
  }

  // Méthode pour créer une instance de Post à partir d'un DocumentSnapshot
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
      authorEmail: data['email'] ?? "",
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

  // Méthode pour récupérer les utilisateurs suivis
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

  // Méthode pour récupérer l'e-mail de l'utilisateur connecté
  Future<String?> getLoggedInUserEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.email;
    } else {
      return null;
    }
  }

  // Méthode pour récupérer les noms d'utilisateur
  Future<void> fetchUserNames() async {
    QuerySnapshot usersSnapshot = await FirebaseFirestore.instance.collection('registration').get();
    setState(() {
      userNames = Map.fromIterable(usersSnapshot.docs, key: (doc) => doc['email'], value: (doc) => doc['username']);
    });
  }

  // Méthode appelée lors de l'initialisation de l'écran
  @override
  void initState() {
    super.initState();
    fetchFollowingUsers();
    fetchUserNames();
  }

  // Méthode appelée pour changer la catégorie sélectionnée
  void _onCategorySelected(String category) {
    setState(() {
      currentCat = category;
    });
  }

  // Méthode pour construire l'interface utilisateur de l'écran
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
                QuickAndFastList(),
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
                      return CircularProgressIndicator();
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
                                          return CircularProgressIndicator();
                                        } else {
                                          if (snapshot.hasError || !snapshot.hasData) {
                                            return CircleAvatar(
                                              radius: 20,
                                              backgroundColor: Colors.grey,
                                            );
                                          } else {
                                            return CircleAvatar(
                                              radius: 20,
                                              backgroundImage: NetworkImage(snapshot.data!),
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
                                        authorUsername,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text(
                                        post.authorEmail,
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
                                      "Title: ${post.title}",
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

void main() {
  runApp(MaterialApp(
    home: HomeScreen(),
  ));
}
