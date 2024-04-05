import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chefconnect/khedmet%20salma/Food.dart';
import 'package:chefconnect/wiem/pages/models/posts_data.dart';
import 'package:chefconnect/wiem/pages/widgets/categories.dart';
import 'package:chefconnect/wiem/pages/widgets/home_appbar.dart';
import 'package:chefconnect/wiem/pages/widgets/quick_and_fast_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  @override
  void initState() {
    super.initState();
    fetchFollowingUsers();
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
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20, top: 20),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage: NetworkImage(post.authorImageUrl),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        post.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        post.authorEmail, // Afficher l'email de l'auteur
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Ingredients: ${post.ingredients}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Image.network(
                                    post.imageUrl,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
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
