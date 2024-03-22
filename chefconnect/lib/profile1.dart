import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewsFeedPage1 extends StatelessWidget {
  const NewsFeedPage1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         backgroundColor: Color.fromARGB(255, 244, 206, 54),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
       
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
                                    text: " @${item.user.userName}",
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
  final String url;
  const _AvatarImage(this.url, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(image: NetworkImage(url))),
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
  final User user;
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

class User {
  final String fullName;
  final String imageUrl;
  final String userName;

  User(
    this.fullName,
    this.userName,
    this.imageUrl,
  );
}

final List<User> _users = [
User(
    "Jill Doe",
    "jill_doe",
    "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80",
  ),
 User(
    "Jill Doe",
    "jill_doe",
    "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80",
  ),
 User(
    "Jill Doe",
    "jill_doe",
    "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80",
  ),
  User(
    "Jill Doe",
    "jill_doe",
    "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80",
  )
];

final List<FeedItem> _feedItems = [
  FeedItem(
    content:
        "A son asked his father (a programmer) why the sun rises in the east, and sets in the west. His response? It works, don’t touch!",
    user: _users[0],
    imageUrl: "https://th.bing.com/th/id/OIP.6hrDwgTWiZGnX13nmux1xgHaE8?rs=1&pid=ImgDetMain",
    likesCount: 100,
    commentsCount: 10,
    retweetsCount: 1,
  ),
  FeedItem(
      user: _users[1],
      imageUrl: "https://th.bing.com/th/id/OIP.2PYrFyzDKmM7DXizioW1sAAAAA?rs=1&pid=ImgDetMain",
      likesCount: 10,
      commentsCount: 2),
  FeedItem(
      user: _users[0],
       imageUrl: "https://th.bing.com/th/id/OIP.hr-eSa1_6YjSCf2H6kUf7QHaHa?w=500&h=500&rs=1&pid=ImgDetMain",
      content:
          "How many programmers does it take to change a light bulb? None, that’s a hardware problem.",
      likesCount: 50,
      commentsCount: 22,
      retweetsCount: 30),
  FeedItem(
      user: _users[1],
      content:
          "Programming today is a race between software engineers striving to build bigger and better idiot-proof programs, and the Universe trying to produce bigger and better idiots. So far, the Universe is winning.",
      imageUrl: "https://th.bing.com/th/id/OIP.SO_eabBiBvlTcTo47lI8igHaEK?rs=1&pid=ImgDetMain",
      likesCount: 500,
      commentsCount: 202,
      retweetsCount: 120),
  FeedItem(
    user: _users[2],
    content: "Good morning!",
    imageUrl: "https://th.bing.com/th/id/OIP.K7SrnO5CxY5zZUHL9kdK_gHaI-?w=660&h=800&rs=1&pid=ImgDetMain",
  ),
  FeedItem(
    user: _users[1],
    imageUrl: "https://th.bing.com/th/id/R.de9ab7c793e04b91a935355671d8e3e6?rik=6WrSx6076qD8xA&riu=http%3a%2f%2f2.bp.blogspot.com%2f-XR_G4Fw4Cf8%2fUoWtuBAypjI%2fAAAAAAAAFU0%2fGeUq7EGsjh4%2fs1600%2fDSC_0092-A.jpg&ehk=%2foFyndTqb046kuHxAFHfgzmxW6DAbFZnTPzDk6jSDQY%3d&risl=&pid=ImgRaw&r=0",
  ),
  FeedItem(
    user: _users[3],
    imageUrl: "https://th.bing.com/th/id/R.b815b00b9a10bcc88a58d88ab49734a2?rik=Gn%2bICRp5yjozvg&riu=http%3a%2f%2fwww.thephoblographer.com%2fwp-content%2fuploads%2f2013%2f07%2fMG_0959-1.jpg&ehk=sXhX3CkdWizwGoC1rRFB4sqE9EByzdWOjw%2b76Z8UneY%3d&risl=&pid=ImgRaw&r=0",
  ),
 
];
