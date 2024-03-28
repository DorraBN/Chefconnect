import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  List<FeedItem> _feedItems = []; 

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadFeedItems(); 
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
        imageUrl = userImageUrl;
      });
    }
  }

  Future<void> _loadFeedItems() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('posts').get();
    List<FeedItem> items = [];
    querySnapshot.docs.forEach((doc) {
      FeedItem item = FeedItem(
        content: doc['content'],
        imageUrl: doc['imageUrl'],
        user: User1(doc['user']['fullName'], doc['user']['userName'], doc['user']['imageUrl']),
        commentsCount: doc['commentsCount'],
        likesCount: doc['likesCount'],
        retweetsCount: doc['retweetsCount'],
      );
      items.add(item);
    });
    setState(() {
      _feedItems = items;
    });
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
          child: ListView.separated(
            itemCount: _feedItems.length,
            separatorBuilder: (BuildContext context, int index) {
              return const Divider();
            },
            itemBuilder: (BuildContext context, int index) {
              final item = _feedItems[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
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
                                        color: Colors.black),
                                  ),
                                  TextSpan(
                                    text: item.user.userName != null ? " @${item.user.userName}" : '',
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                ]),
                              )),
                              Text('· 5m',
                                  style: Theme.of(context).textTheme.subtitle1),
                              const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Icon(Icons.more_horiz),
                              )
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
                                  )),
                            ),
                          _ActionsRow(item: item)
                        ],
                      ),
                    ),
                  ],
                ),
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
            : null, 
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
          ))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.mode_comment_outlined),
            label: Text(
                item.commentsCount == 0 ? '' : item.commentsCount.toString()),
          ),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.repeat_rounded),
            label: Text(
                item.retweetsCount == 0 ? '' : item.retweetsCount.toString()),
          ),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.favorite_border),
            label: Text(item.likesCount == 0 ? '' : item.likesCount.toString()),
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.share_up),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}

class FeedItem {
  final String? content;
  final String? imageUrl;
  final User1 user;
  final int commentsCount;
  final int likesCount;
  final int retweetsCount;

  FeedItem(
      {this.content,
      this.imageUrl,
      required this.user,
      this.commentsCount = 0,
      this.likesCount = 0,
      this.retweetsCount = 0});
}

class User1 {
  final String fullName;
  final String userName;
  final String imageUrl;

  User1(this.fullName, this.userName, this.imageUrl);
}

class NewPostPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Post'),
      ),
      body: Center(
        child: Text('Create new post page'),
      ),
    );
  }
}

class FirebaseAuthService {
  Future<String?> getUsername(String email) async {
    // Dummy implementation, replace with actual implementation
    return "John Doe";
  }

  Future<String?> getCollectionImageUrl(String email) async {
    // Dummy implementation, replace with actual implementation
    return "https://example.com/image.jpg";
  }
}

void main() {
  runApp(MaterialApp(
    home: NewsFeedPage2(),
  ));
}
