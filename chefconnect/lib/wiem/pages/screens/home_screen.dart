import 'package:chefconnect/navigation.dart';
import 'package:chefconnect/wiem/pages/models/posts_data.dart';
import 'package:chefconnect/wiem/pages/widgets/categories.dart';
import 'package:chefconnect/wiem/pages/widgets/home_appbar.dart';
import 'package:chefconnect/wiem/pages/widgets/quick_and_fast_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chefconnect/khedmet salma/Food.dart';

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
  bool isLiked = false; // Initialize liked state for each list item
  bool isCommentVisible = true;

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
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    Post post = posts[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20, top: 20),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: AssetImage(post.authorImageUrl),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                post.authorName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.asset(post.postImageUrl),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          post.caption,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    isLiked ? Icons.favorite : Icons.favorite_border,
                                    color: isLiked ? Colors.red : null,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isLiked = !isLiked;
                                    });
                                  },
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "${post.likes} Likes",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.comment),
                                  onPressed: () {
                                    setState(() {
                                      isCommentVisible = !isCommentVisible;
                                    });
                                  },
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "${post.comments} Comments",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (isCommentVisible)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                const Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: "Add a comment...",
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.send),
                                  onPressed: () {
                                    // Add send comment functionality
                                  },
                                ),
                              ],
                            ),
                          ),
                        Divider(
                          height: 20,
                          color: Colors.grey.shade300,
                        ),
                      ],
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
