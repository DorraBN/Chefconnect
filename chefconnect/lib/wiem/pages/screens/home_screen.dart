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
  String authorEmail;

  Post({
    required this.title,
    required this.imageUrl,
    required this.ingredients,
    required this.authorImageUrl,
    required this.authorEmail,
  });

 
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
                    final filteredPosts = snapshot.data!.docs.where((doc) => followingEmails.contains(doc['email']));
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredPosts.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot postSnapshot = filteredPosts.elementAt(index);
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
