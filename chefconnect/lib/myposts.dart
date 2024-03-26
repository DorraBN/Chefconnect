import 'package:chefconnect/newpost.dart';
import 'package:chefconnect/firebaseAuthImp.dart'; // Importez votre service FirebaseAuth ici

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
       String? imageUrl = await FirebaseAuthService().getCollectionImageUrl(useremail);
      setState(() {
        fullName = username;
        email = currentUser?.email;
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
                                    text: fullName ?? '',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black),
                                  ),
                                  TextSpan(
                                     text: fullName != null ? " @$fullName" : '',
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
// Le reste de votre code reste inchangé


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
  final String imageUrl;
  final String userName;

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
 User1(
    "Joe Doe",
    "joe_doe",
    "https://th.bing.com/th/id/OIP.YWf2ipWdTwok7T4_sx75mgHaHa?rs=1&pid=ImgDetMain",
  ),
 User1(
    "Joe Doe",
    "joe_doe",
    "https://th.bing.com/th/id/OIP.YWf2ipWdTwok7T4_sx75mgHaHa?rs=1&pid=ImgDetMain",
  ),
  User1(
    "Joe Doe",
    "joe_doe",
    "https://th.bing.com/th/id/OIP.YWf2ipWdTwok7T4_sx75mgHaHa?rs=1&pid=ImgDetMain",
  ),
];

final List<FeedItem> _feedItems = [
  FeedItem(
    content:
        "A son asked his father (a programmer) why the sun rises in the east, and sets in the west. His response? It works, don’t touch!",
    user: _users[0],
    imageUrl: "https://th.bing.com/th/id/OIP.SFmZoeTYOla0uWFetnZIogHaFs?rs=1&pid=ImgDetMain",
    likesCount: 100,
    commentsCount: 10,
    retweetsCount: 1,
  ),
  FeedItem(
      user: _users[1],
      imageUrl: "https://th.bing.com/th/id/R.e4a0cf4be524c934349c8534831933ca?rik=hAOAo54USaBD4w&riu=http%3a%2f%2fimages.unsplash.com%2fphoto-1551024601-bec78aea704b%3fixlib%3drb-1.2.1%26q%3d80%26fm%3djpg%26crop%3dentropy%26cs%3dtinysrgb%26w%3d1080%26fit%3dmax%26ixid%3deyJhcHBfaWQiOjEyMDd9&ehk=4BzmliELoqZdxIlSsVTxpSNGdUR0d2jZwka0OnM%2bKdA%3d&risl=&pid=ImgRaw&r=0",
      likesCount: 10,
      commentsCount: 2),
  FeedItem(
      user: _users[0],
       imageUrl: "https://resize.img.allw.mn/thumbs/nq/tu/knt5l6y35e9e60957ac91984701085_1080x1080.jpg?width=1200&height=1200",
      content:
          "How many programmers does it take to change a light bulb? None, that’s a hardware problem.",
      likesCount: 50,
      commentsCount: 22,
      retweetsCount: 30),
  FeedItem(
      user: _users[1],
      content:
          "Programming today is a race between software engineers striving to build bigger and better idiot-proof programs, and the Universe trying to produce bigger and better idiots. So far, the Universe is winning.",
      imageUrl: "https://th.bing.com/th/id/R.084953c6f0193b7fa9f0cbd437168fe0?rik=7Rex4uVkJ9CVcA&riu=http%3a%2f%2fwww.mainz-schmecker.de%2fwp-content%2fuploads%2f2016%2f12%2fEinfacher-Nachtisch-7.jpg&ehk=CdEiyHT04akFp5bJaftIP0r%2fJ1C14hf8Fj5NOevISvg%3d&risl=&pid=ImgRaw&r=0",
      likesCount: 500,
      commentsCount: 202,
      retweetsCount: 120),
  FeedItem(
    user: _users[2],
    content: "Good morning!",
    imageUrl: "https://th.bing.com/th/id/R.dc4aa2e5749f02b6c3ea565ddadeb8eb?rik=GWlhKZW%2bxEt%2b9A&riu=http%3a%2f%2fimages6.fanpop.com%2fimage%2fphotos%2f36800000%2fDessert-food-36849257-2560-1600.jpg&ehk=N0nwSDw3BZD4G3uq4LRGdcgnEif9MLkltc0Zz9OoFms%3d&risl=&pid=ImgRaw&r=0",
  ),
  FeedItem(
    user: _users[1],
    imageUrl: "https://th.bing.com/th/id/R.41685d965d64c00ddb8f78c458d5f6d2?rik=nNcaLLG2LGnTpQ&riu=http%3a%2f%2f4.bp.blogspot.com%2f_Pe9obweD_W8%2fTH5lSLYTgPI%2fAAAAAAAAABU%2fjWp0YWwlP8A%2fs1600%2fwhite-chocolate-parfait-flambeed-cherries200711131%5b1%5d.jpg&ehk=V2fo27SKZkLNgq1LV34E65nv73g2YTvtqNAcbUmY6zE%3d&risl=&pid=ImgRaw&r=0",
  ),
  FeedItem(
    user: _users[3],
    imageUrl: "https://th.bing.com/th/id/R.9060765ff3e9f9816eee775a9828af1e?rik=FmHk27nyrOFFBA&riu=http%3a%2f%2fimages6.fanpop.com%2fimage%2fphotos%2f37200000%2fDessert-food-37262256-2560-1600.jpg&ehk=Ojjv93B1cpxrkz0TQmPywCHSu5Q4uWGuiBitOnb7UcY%3d&risl=&pid=ImgRaw&r=0",
  ),
 
];
