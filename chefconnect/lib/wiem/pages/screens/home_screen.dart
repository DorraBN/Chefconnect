import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chefconnect/wiem/pages/models/posts_data.dart';
import 'package:chefconnect/wiem/pages/widgets/categories.dart';
import 'package:chefconnect/wiem/pages/widgets/home_appbar.dart';
import 'package:chefconnect/wiem/pages/widgets/quick_and_fast_list.dart';
import 'package:iconly/iconly.dart';

class Post {
  String title;
  String imageUrl;
  String ingredients;
  String authorImageUrl;
  String authorEmail;
  int likes;
  int comments;
  bool isLiked; // Add a boolean to track liked state for each post

  Post({
    required this.title,
    required this.imageUrl,
    required this.ingredients,
    required this.authorImageUrl,
    required this.authorEmail,
    required this.likes,
    required this.comments,
    required this.isLiked, // Initialize isLiked in the constructor
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
      likes: data['likes'] ?? 0,
      comments: data['comments'] ?? 0,
      isLiked: false, // Initialize isLiked to false for each post
    );
  }
}

class Comment {
  String postId;
  String comment;
  String userEmail;

  Comment({
    required this.postId,
    required this.comment,
    required this.userEmail,
  });

  factory Comment.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception("Comment data is null");
    }

    return Comment(
      postId: data['postId'] ?? "",
      comment: data['comment'] ?? "",
      userEmail: data['userEmail'] ?? "",
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
  final TextEditingController _commentController = TextEditingController();

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

  void addComment(String postId, String comment, Post post) async {
    // Récupérer l'utilisateur actuellement connecté
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (comment.isNotEmpty && currentUser != null) {
      // Ajouter le commentaire à la collection 'comments'
      FirebaseFirestore.instance.collection('comments').add({
        'postId': postId,
        'comment': comment,
        'userEmail': currentUser.email, // Utiliser l'e-mail de l'utilisateur actuel
        'postTitle': post.title,
      }).then((docRef) {
        // Incrémenter le compteur de commentaires dans le document du post
        FirebaseFirestore.instance.collection('posts').doc(postId).update({
          'comments': FieldValue.increment(1),
        });
      }).catchError((error) {
        // Gérer les erreurs éventuelles ici
        print("Error adding comment: $error");
      });
    }

    setState(() {
      // Increment comment count
      post.comments++;
    });

    _commentController.clear();
  }

  int ChangeColorToRed(Post post, int number) {
    int newNumber = number;

    // Toggle like status and update like count
    setState(() {
      if (post.isLiked) {
        post.isLiked = false;
        newNumber--;
      } else {
        post.isLiked = true;
        newNumber++;
      }
    });

    return newNumber;
  }

  void _onSubmitted(String postId, Post post) {
    String comment = _commentController.text;

    if (comment.isNotEmpty) {
      addComment(postId, comment, post);
    }
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: post.isLiked ? Icon(Icons.favorite, color: Colors.red) : Icon(IconlyLight.heart),
                                        onPressed: () async {
                                          setState(() {
                                            post.likes = ChangeColorToRed(post, post.likes);
                                          });
                                          
                                          // Mettre à jour le nombre de likes dans Firestore
                                          await FirebaseFirestore.instance.collection('posts').doc(postSnapshot.id).update({
                                            'likes': post.likes,
                                          });
                                        },
                                      ),
                                      Text("${post.likes} Likes"),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.comment),
                                        onPressed: () {
                                          // Ouvrir une nouvelle page pour afficher les commentaires
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => CommentScreen(postId: postSnapshot.id),
                                            ),
                                          );
                                        },
                                      ),
                                      SizedBox(width: 5),
                                      Text("${post.comments} Comments"),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.share), // Ajout de l'icône de partage
                                        onPressed: () async {
                                          // Récupérer l'utilisateur actuellement connecté
                                          User? currentUser = FirebaseAuth.instance.currentUser;
                                          if (currentUser != null) {
                                            // Récupérer les informations du post
                                            String postId = postSnapshot.id;
                                            String title = post.title;
                                            String ingredients = post.ingredients;
                                            String imageUrl = post.imageUrl;
                                            String authorImageUrl = post.authorImageUrl;
                                            String authorEmail = post.authorEmail;
                                            
                                            // Vérifier si le post est déjà partagé par l'utilisateur actuel
                                            QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                                                .collection('partage')
                                                .where('userId', isEqualTo: currentUser.uid)
                                                .where('postId', isEqualTo: postId)
                                                .get();
                                            
                                            if (querySnapshot.docs.isNotEmpty) {
                                              // Le post est déjà partagé, afficher un message d'alerte
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text("Already Shared"),
                                                    content: Text("This post is already on your profile."),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                        },
                                                        child: Text("OK"),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            } else {
                                              // Le post n'est pas encore partagé, l'ajouter à la collection "partage"
                                              await FirebaseFirestore.instance.collection('partage').add({
                                                'userId': currentUser.uid,
                                                'postId': postId,
                                                'title': title,
                                                'ingredients': ingredients,
                                                'imageUrl': imageUrl,
                                                'authorImageUrl': authorImageUrl,
                                                'authorEmail': authorEmail,
                                                'currentUserEmail': currentUser.email, // Ajouter le courant utilisateur
                                              });
                                            }
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _commentController,
                                      decoration: InputDecoration(
                                        hintText: 'Add a comment...',
                                      ),
                                      onSubmitted: (comment) {
                                        _onSubmitted(postSnapshot.id, post);
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.send),
                                    onPressed: () {
                                      _onSubmitted(postSnapshot.id, post);
                                    },
                                  ),
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

class CommentScreen extends StatefulWidget {
  final String postId;

  const CommentScreen({Key? key, required this.postId}) : super(key: key);

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('comments').where('postId', isEqualTo: widget.postId).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          List<Comment> comments = [];
          snapshot.data!.docs.forEach((doc) {
            comments.add(Comment.fromSnapshot(doc));
          });
          return ListView.builder(
            itemCount: comments.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(comments[index].comment),
                subtitle: Text(comments[index].userEmail),
              );
            },
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomeScreen(),
  ));
}

