import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chefconnect/firebaseAuthImp.dart';
import 'package:chefconnect/khedmet%20salma/ChatHome.dart';
import 'package:chefconnect/navigation.dart';
import 'package:chefconnect/myposts.dart';
import 'package:chefconnect/setings.dart';

class ProfilePage1 extends StatefulWidget {
  const ProfilePage1({Key? key}) : super(key: key);

  @override
  _ProfilePage1State createState() => _ProfilePage1State();
}

class _ProfilePage1State extends State<ProfilePage1> {
  String? fullName;
  String? email;
  String? imageUrl; // Add imageUrl variable
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadUserData2();
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
  Future<void> _loadUserData2() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    String? useremail = currentUser?.email;
    if (useremail != null) {
      String? username = await FirebaseAuthService().getUsername(useremail);
      String? userImageUrl =
          await FirebaseAuthService().getCollectionImageUrl(useremail); // Get user image URL
      setState(() {
        fullName = username;
        email = currentUser?.email;
        imageUrl = userImageUrl; // Set user image URL
      });
    }
  }
 int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);
@override
Widget build(BuildContext context) {
 return Scaffold(
  appBar: AppBar(
    title: Text('Profile'),
    backgroundColor: Color.fromARGB(255, 244, 206, 54),
    actions: [
      PopupMenuButton<String>(
        offset: Offset(0, 40),
        onSelected: (value) {
          if (value == 'settings') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsPage2()),
            );
          } else if (value == 'logout') {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Confirm Logout'),
                  content: Text('Are you sure you want to logout?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.pushReplacementNamed(context, '/');
                      },
                      child: Text('Logout'),
                    ),
                  ],
                );
              },
            );
          }
        },
        itemBuilder: (BuildContext context) => [
          PopupMenuItem<String>(
            value: 'settings',
            child: Container(
              width: 120,
              child: ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          PopupMenuItem<String>(
            value: 'logout',
            child: Container(
              width: 120,
              child: ListTile(
                leading: Icon(Icons.logout),
                title: Text('Log out'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    ],
  ),
  body: Column(
    
    children: [
      Expanded(
        flex: 2,
        child: _TopPortion(imageUrl: imageUrl), // Pass imageUrl to _TopPortion
      ),
      
      Expanded(
        flex: 3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                fullName ?? 'Full Name',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                email ?? 'Email',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ProfileInfoItem(title: 'Posts', value: 10),
                  _ProfileInfoItem(title: 'Followers', value: 100),
                  _ProfileInfoItem(title: 'Following', value: 50),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: isLoading
                    ? CircularProgressIndicator() // Show loading indicator while data is loading
                    : Container(
                        constraints: BoxConstraints(maxWidth: 400),
                        
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance.collection('posts').where('email', isEqualTo: email).snapshots(),
                          builder: (BuildContext context, AsyncSnapshot
                          <QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }

                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }

                            return ListView(
                               shrinkWrap: true,
  physics: NeverScrollableScrollPhysics(),
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
                            ); },
                         ),
                      ),
                ),
              
            ],
          ),
        ),
      ),
    ],
  ),
);
}}

class _TopPortion extends StatelessWidget {
  final String? imageUrl;
  const _TopPortion({Key? key, this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 50),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Color.fromARGB(255, 114, 242, 108), Color.fromARGB(255, 244, 207, 84)],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: imageUrl != null
                      ? CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(imageUrl!),
                        )
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileInfoItem extends StatelessWidget {
  final String title;
  final int value;

  const _ProfileInfoItem({Key? key, required this.title, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(title),
      ],
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
    home: ProfilePage1(),
  ));
}
