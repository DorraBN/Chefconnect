import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chefconnect/firebaseAuthImp.dart';
import 'package:chefconnect/khedmet%20salma/ChatHome.dart';
import 'package:chefconnect/navigation.dart';
import 'package:chefconnect/myposts.dart';
import 'package:chefconnect/setings.dart';
import 'package:flutter/widgets.dart';

class ProfilePage1 extends StatefulWidget {
  const ProfilePage1({Key? key}) : super(key: key);

  @override
  _ProfilePage1State createState() => _ProfilePage1State();
}

class _ProfilePage1State extends State<ProfilePage1> {
  String? fullName;
  String? email;
  String? imageUrl;
  bool isLoading = true;
  List<String> allergies = []; // Liste pour stocker les allergies
  List<String> questions = []; // Liste pour stocker les questions correspondantes aux allergies

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadUserData2();
    fetchUserAllergies(); // Appel de la fonction pour récupérer les allergies
  }

  Future<void> _loadUserData() async {
    await Future.delayed(Duration(seconds: 2));

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
          isLoading = false;
        });
      }
    }
  }

  // Fonction pour récupérer les données utilisateur depuis FirebaseAuthService
  Future<void> _loadUserData2() async {
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

  Future<void> fetchUserAllergies() async {
    String? currentUserEmail = FirebaseAuth.instance.currentUser?.email;
    if (currentUserEmail != null) {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('allergies')
          .where('email', isEqualTo: currentUserEmail)
          .get();
      if (querySnapshot.size > 0) {
        List<String> userAllergies = [];
        List<String> userQuestions = [];
        querySnapshot.docs.forEach((doc) {
          List<Map<String, dynamic>> selectedResponses = List<Map<String, dynamic>>.from(doc['selected_responses']);
          selectedResponses.forEach((response) {
            userAllergies.add(response['response']);
            userQuestions.add(response['question']); // Ajouter la question correspondante
          });
        });
        setState(() {
          allergies = userAllergies;
          questions = userQuestions;
        });
      } else {
        print('Aucune allergie trouvée pour cet utilisateur.');
      }
    }
  }

List<Map<String, dynamic>> _groupAllergiesByQuestion(List<String> allergies, List<String> questions) {
    Map<String, List<String>> groupedAllergies = {};

    for (int i = 0; i < allergies.length; i++) {
      String question = i < questions.length ? questions[i] : "Question ${i + 1}";
      if (groupedAllergies.containsKey(question)) {
        groupedAllergies[question]?.add(allergies[i]);
      } else {
        groupedAllergies[question] = [allergies[i]];
      }
    }

    return groupedAllergies.entries.map((entry) => {'question': entry.key, 'responses': entry.value}).toList();
  }
Widget _buildResponseBox(String response) {
  return Container(
    decoration: BoxDecoration(
      color: Color.fromARGB(255, 169, 234, 181), // Change the background color here
      border: Border.all(color: Color.fromARGB(255, 31, 184, 59)),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        response,
        textAlign: TextAlign.center,
      ),
    ),
  );
}

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
    body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
     Container(
  margin: EdgeInsets.only(bottom: 10, top: 0), // Modification du margin
  width: double.infinity,
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [Color.fromARGB(255, 114, 242, 108), Color.fromARGB(255, 244, 207, 84)],
    ),
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(50),
      bottomRight: Radius.circular(50),
    ),
  ),
  child: SizedBox(
    width: double.infinity,
    height: 150,
    child: Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 10), // Ajustement pour déplacer légèrement vers le bas
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
          child: imageUrl != null
              ? CircleAvatar(
                  radius: 15, // Ajustement pour réduire la taille de l'image
                  backgroundImage: NetworkImage(imageUrl!),
                )
              : null,
        ),
        Positioned(
          bottom: 0, // Ajustement pour attacher en bas de l'image
          right: 150, // Ajustement pour attacher à la moitié de l'image
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

           SizedBox(height: 16),
                Text(
                  fullName ?? 'Full Name',
                  style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.bold),
                ),
          SizedBox(height: 16),
          Text(
            email ?? 'Email',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ProfileInfoItem(title: 'Posts', value: 10),
              _ProfileInfoItem(title: 'Followers', value: 100),
              _ProfileInfoItem(title: 'Following', value: 50),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'Food Preferences & Restrictions',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Divider(
            color: Colors.black,
            thickness: 1,
          ),
          if (allergies.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _groupAllergiesByQuestion(allergies, questions).map((group) {
                      String question = group['question'];
                      List<String> responses = group['responses'];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0, left: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              question,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: responses.map((response) => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: _buildResponseBox(response),
                              )).toList(),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            )
          else
            Text(
              'Aucune allergie',
              style: TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
          SizedBox(height: 16),
          Text(
            'Posts',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('posts').where('email', isEqualTo: email).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        DocumentSnapshot document = snapshot.data!.docs[index];
                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                        FeedItem item = FeedItem(
                          title: data['title'],
                          content: data['content'],
                          imageUrl: data['imageUrl'],
                          ingredients: data['ingredients'] ?? "",
                          instructions: data['instructions'] ?? "",
                          user: UserInfo(fullName ?? "", email ?? "", imageUrl ?? ""),
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
                                                          fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
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
                                        _ActionsRow(),
                                      ],
                                    ),
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
  );
}
}
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