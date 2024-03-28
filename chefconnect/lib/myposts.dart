import 'package:chefconnect/newpost.dart';
import 'package:chefconnect/firebaseAuthImp.dart'; // Importez votre service FirebaseAuth ici
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewsFeedPage2 extends StatefulWidget {
  const NewsFeedPage2({Key? key}) : super(key: key);

  @override
  _NewsFeedPage2State createState() => _NewsFeedPage2State();
}

class _NewsFeedPage2State extends State<NewsFeedPage2> {
  String? fullName;
  String? email;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    String? useremail = currentUser?.email;
    if (useremail != null) {
      String? username = await FirebaseAuthService().getUsername(useremail);
      String? userImageUrl = await FirebaseAuthService().getCollectionImageUrl(useremail);
      setState(() {
        fullName = username;
        email = currentUser?.email;
        imageUrl = userImageUrl; // Assign the retrieved image URL
      });
    }
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
  appBar: AppBar(
    title: Text('My posts'),
    backgroundColor: Color.fromARGB(255, 244, 206, 54),
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewPostPage()),
          );
        },
      ),
    ],
  ),
  body: Center(
    child: Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
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
                user: User1(
                  fullName ?? "",
                  fullName != null ? "@$fullName" : "",
                  imageUrl ?? "",
                ),
                likesCount: data['likesCount'] ?? 0,
                commentsCount: data['commentsCount'] ?? 0,
                retweetsCount: data['retweetsCount'] ?? 0,
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
                                      text: TextSpan(children: [
                                        TextSpan(
                                          text: item.user.fullName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                        TextSpan(
                                          text: item.user.userName,
                                          style: Theme.of(context).textTheme.subtitle1,
                                        ),
                                      ]),
                                    ),
                                  ),
                                  Text(
                                    '· 5m',
                                    style: Theme.of(context).textTheme.subtitle1,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Icon(Icons.more_horiz),
                                  ),
                                ],
                              ),
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
                              _ActionsRow(item: item),
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
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: imageUrl != null
            ? DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(imageUrl!),
              )
            : null, // Mettez l'image à null si imageUrl est null
      ),
    );
  }
}

class _ActionsRow extends StatelessWidget {
  final FeedItem item;
  const _ActionsRow({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        iconTheme: const IconThemeData(color: Colors.grey, size: 18),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.grey),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.mode_comment_outlined),
            label: Text(
              item.commentsCount == 0 ? '' : item.commentsCount.toString(),
            ),
          ),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.repeat_rounded),
            label: Text(
              item.retweetsCount == 0 ? '' : item.retweetsCount.toString(),
            ),
          ),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.favorite_border),
            label: Text(
              item.likesCount == 0 ? '' : item.likesCount.toString(),
            ),
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.share_up),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class FeedItem {
  final String? title;
  final String? content;
  final String? imageUrl;
  final String ingredients;
  final String instructions;
  final User1 user;
  final int commentsCount;
  final int likesCount;
  final int retweetsCount;

  FeedItem({
    this.title,
    this.content,
    this.imageUrl,
    required this.ingredients,
    required this.instructions,
    required this.user,
    this.commentsCount = 0,
    this.likesCount = 0,
    this.retweetsCount = 0,
  });
}

class User1 {
  final String fullName;
  final String userName;
  final String imageUrl;

  User1(
    this.fullName,
    this.userName,
    this.imageUrl,
  );
}

final List<User1> _users = [
  User1(
    "Joe Doe",
    "joe_doe",
    "https://th.bing.com/th/id/OIP.YWf2ipWdTwok7T4_sx75mgHaHa?rs=1&pid=ImgDetMain",
  ),
  // Add other users here
];
