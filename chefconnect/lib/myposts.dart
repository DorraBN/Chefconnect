import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewsFeedPage2 extends StatefulWidget {
  const NewsFeedPage2({Key? key}) : super(key: key);

  @override
  _NewsFeedPage2State createState() => _NewsFeedPage2State();
}

class _NewsFeedPage2State extends State<NewsFeedPage2> {
  String? fullName;
  String? email;
  String? imageUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

 Future<void> _loadUserData() async {
  // Add a delay for demonstration purposes (replace with actual data loading)
  await Future.delayed(Duration(seconds: 2));

  // Fetch user data from Firestore
  String? currentUserEmail = FirebaseAuth.instance.currentUser?.email;
  if (currentUserEmail != null) {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection('registration')
        .where('email', isEqualTo: currentUserEmail)
        .get();
    if (querySnapshot.size > 0) {
      var userData = querySnapshot.docs.first.data();
      setState(() {
        fullName = userData['username'];
        email = userData['email'];
        imageUrl = userData['imageUrl'];
        isLoading = false; // Set loading state to false after data is loaded
      });
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My posts'),
        backgroundColor: Colors.amber, // Use Colors.amber directly
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Navigate to new post page
            },
          ),
        ],
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator() // Show loading indicator while data is loading
            : Container(
                constraints: BoxConstraints(maxWidth: 400),
                child: StreamBuilder<QuerySnapshot>(
                   stream: FirebaseFirestore.instance.collection('posts').where('email', isEqualTo: email).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    return ListView(
                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                        FeedItem item = FeedItem(
                          title: data['title'],
                          content: data['content'],
                          imageUrl: data['imageUrl'], // Use imageUrl from Firestore
                          ingredients: data['ingredients'] ?? "",
                          instructions: data['instructions'] ?? "",
                          user: UserInfo(fullName ?? "", email?? "", imageUrl ?? ""), // Pass user information
                        );
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _AvatarImage(item.user.imageUrl),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: RichText(
                                                overflow: TextOverflow.ellipsis,
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: fullName ?? '',
                                                      style: const TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 16,
                                                          color: Colors.black),
                                                    ),
                                                    TextSpan(
                                                      text: fullName != null ? " @$fullName" : '',
                                                      style: Theme.of(context).textTheme.subtitle1,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Text('· 5m', style: Theme.of(context).textTheme.subtitle1),
                                            const Padding(
                                              padding: EdgeInsets.only(left: 8.0),
                                              child: Icon(Icons.more_horiz),
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        if (item.content != null) Text(item.content!),
                                        if (item.imageUrl != null)
                                          Container(
                                            height: 200,
                                            margin: const EdgeInsets.only(top: 8.0),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8.0),
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(item.imageUrl!),
                                              ),
                                            ),
                                          ),
                                        SizedBox(height: 8),
                                        if (item.title != null)
                                          Text(
                                            item.title!,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        if (item.ingredients.isNotEmpty)
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Ingrédients:",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              for (String ingredient in item.ingredients.split(','))
                                                Text("- $ingredient"),
                                            ],
                                          ),
                                        _ActionsRow(), // Actions row
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
      ),
    );
  }
}

class _AvatarImage extends StatelessWidget {
  final String? imageUrl;
  const _AvatarImage(this.imageUrl, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 24,
      backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
      child: imageUrl == null ? Icon(Icons.person) : null,
    );
  }
}

class _ActionsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.favorite_border),
              onPressed: () {
                // Handle like button pressed
              },
            ),
            SizedBox(width: 5),
            Text(
              "Like",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.comment),
              onPressed: () {
                // Handle comment button pressed
              },
            ),
            SizedBox(width: 5),
            Text(
              "Comment",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class FeedItem {
  final String? title;
  final String? content;
  final String? imageUrl;
  final String ingredients;
  final String instructions;
  final UserInfo user;

  FeedItem({
    this.title,
    this.content,
    this.imageUrl,
    required this.ingredients,
    required this.instructions,
    required this.user,
  });
}

class UserInfo {
  final String fullName;
  final String email;
  final String imageUrl;

  UserInfo(
    this.fullName,
    this.email,
    this.imageUrl,
  );
}

void main() {
  runApp(MaterialApp(
    home: NewsFeedPage2(),
  ));
}
