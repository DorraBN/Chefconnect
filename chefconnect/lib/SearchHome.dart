import 'dart:convert';
import 'package:chefconnect/firebaseAuthImp.dart';
import 'package:chefconnect/khedmet%20salma/APIkey.dart';
import 'package:chefconnect/khedmet%20salma/ChatScreen.dart';
import 'package:chefconnect/khedmet%20salma/CustomCategoriesList.dart';
import 'package:chefconnect/khedmet%20salma/CustomField.dart';
import 'package:chefconnect/khedmet%20salma/CustomSlider.dart';
import 'package:chefconnect/khedmet%20salma/Food.dart';
import 'package:chefconnect/khedmet%20salma/Post.dart';
import 'package:chefconnect/khedmet%20salma/RecipeDetails.dart';
import 'package:chefconnect/khedmet%20salma/SearchPage.dart';
import 'package:chefconnect/khedmet%20salma/styles/app_colors.dart';
import 'package:chefconnect/notification.dart';
import 'package:chefconnect/wiem/pages/models/Recipe.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:chefconnect/testRecipes.dart';
import 'dart:ui' as ui;
import 'khedmet salma/CustomButton.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchHome extends StatefulWidget {
  const SearchHome({Key? key}) : super(key: key);
  @override
  State<SearchHome> createState() => _SearchHome();
}

class Person {
  final String name;
  final String email;
  final String imageUrl; // Ajouter une nouvelle propriété pour l'URL de l'image

  Person({
    required this.name,
    required this.email,
    required this.imageUrl,
  });
}
class Post {
  final String authorImageUrl; // Ajouter la propriété authorImageUrl

  // Autres propriétés de Post
  final String email;
  final String imageUrl;
  final String ingredients;
  final String instructions;
  final String title;
  int likes;
  int comments;

  Post({
    required this.authorImageUrl, // Assurez-vous que la propriété est incluse dans le constructeur
    required this.email,
    required this.imageUrl,
    required this.ingredients,
    required this.instructions,
    required this.title,
     required this.likes, required this.comments,
  });

  // Reste de la classe...
}

class _SearchHome extends State<SearchHome> {
  
  TextEditingController searchController = TextEditingController();
  static List previousSearchs = [];
  bool isLiked = false; // Initialize liked state
  bool isCommentVisible = true;
  late List<Person> people = [];
  Icon favorite_icon = new Icon(IconlyLight.heart);
  List<Post> posts = [
   
    
  ];
 Future<void> fetchPostsData() async {
  try {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('posts').get();

    final List<Post> loadedPosts = snapshot.docs.map((doc) {
      final data = doc.data();
      return Post(
       
        imageUrl: data['imageUrl'] ?? 'blob:http://localhost:55653/62f50f4e-45d9-41ae-8641-a6186aa720ad',
       
       
        likes: data['likes'] ?? 0,
        comments: data['comments'] ?? 0,
        authorImageUrl: data['authorImageUrl'] ?? 'blob:http://localhost:55653/62f50f4e-45d9-41ae-8641-a6186aa720ad', // Utilisez la valeur de authorImageUrl si elle est disponible
        email: data['email'] ?? '', // Assurez-vous d'inclure la propriété email dans la création de l'objet Post
        ingredients: data['ingredients'] ?? '', // Assurez-vous d'inclure la propriété ingredients dans la création de l'objet Post
        instructions: data['instructions'] ?? '', // Assurez-vous d'inclure la propriété instructions dans la création de l'objet Post
        title: data['title'] ?? '', // Assurez-vous d'inclure la propriété title dans la création de l'objet Post
      );
    }).toList();

    setState(() {
      posts = loadedPosts;
    });
  } catch (error) {
    print('Error fetching posts: $error');
  }
}


  @override
  void initState() {
    super.initState();
     fetchPostsData(); 
    fetchPeopleData();
  }

  Future<void> fetchPeopleData() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('registration').get();

      final List<Person> loadedPeople = snapshot.docs.map((doc) {
        final data = doc.data();
        return Person(
          name: data['username'] ?? '',
          email: data['email'] ?? '',
          imageUrl: data['imageUrl'] ?? '',
        );
      }).toList();

      setState(() {
        people = loadedPeople;
      });
    } catch (error) {
      print('Error fetching people: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 1,
          title: Text(
            "Search",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        body: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: AppColors.textColor,
                          )),
                      Expanded(
                        child: CustomTextField(
                          hint: "Search",
                          prefixIcon: IconlyLight.search,
                          controller: searchController,
                          filled: true,
                          suffixIcon: searchController.text.isEmpty
                              ? null
                              : Icons.cancel_sharp,
                          onTapSuffixIcon: () {
                            searchController.clear();
                          },
                          onChanged: (pure) {
                            setState(() {});
                          },
                          onEditingComplete: () {
                            previousSearchs.add(searchController.text);
                            fetchRecipesData(searchController.text, 2);
                            fetchUserDataByUsername(searchController.text);
                          },
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              showModalBottomSheet(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(25),
                                    ),
                                  ),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  context: context,
                                  builder: (context) =>
                                      _custombottomSheetFilter(context));
                            });
                          },
                          icon: const Icon(
                            IconlyBold.filter,
                            color: AppColors.textColor,
                          )),
                    ],
                  ),
                ),
              ),
              Material(
                child: Container(
                  height: 70,
                  color: Colors.white,
                  child: TabBar(
                    physics: const ClampingScrollPhysics(),
                    padding: EdgeInsets.only(
                        top: 10, left: 10, right: 10, bottom: 10),
                    unselectedLabelColor: AppColors.primary,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: AppColors.primary),
                    tabs: [
                      Tab(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                                color: Color.fromARGB(255, 38, 125, 0),
                                width: 1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.restaurant), // Spoon and fork icon
                              SizedBox(width: 8), // Adjust spacing as needed
                              Text("Recipes"),
                            ],
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                                color: Color.fromARGB(255, 38, 125, 0),
                                width: 1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.post_add), // Add posts icon here
                              SizedBox(width: 8), // Adjust spacing as needed
                              Text("Posts"),
                            ],
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                                color: Color.fromARGB(255, 38, 125, 0),
                                width: 1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.people), // Add people icon here
                              SizedBox(width: 8), // Adjust spacing as needed
                              Text("People"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    recipes.isEmpty
                        ? Center(child: CircularProgressIndicator())
                        : ListView.separated(
                            padding: EdgeInsets.all(15),
                            itemCount: recipes.length,
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const Divider(),
                            itemBuilder: (context, index) {
                              final recipe = recipes[index];

                              return ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RecipeDetails(recipe: recipes[index]),
                                    ),
                                  );
                                },
                                title: Text(recipe.title,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                leading: recipe.image != null
                                    ? Image.network(
                                        recipe.image!,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      )
                                    : SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: Placeholder(),
                                      ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.access_time),
                                        Text('${recipe.readyInMinutes} min',
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal)),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.local_fire_department),
                                        Text('${recipe.servings} Servings',
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal)),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        // Toggle the isLiked property of the recipe
                                        recipe.isLiked = !recipe.isLiked;
                                        if (recipe.isLiked) {
                                          // If the recipe is liked, set the icon color to red
                                          // and save the like info to Firestore
                                          saveLikeInfo(recipe.id);
                                        }
                                      });
                                    },
                                    style: IconButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      fixedSize: const ui.Size(30, 30),
                                    ),
                                    iconSize: 20,
                                    icon: recipe.isLiked
                                        ? const Icon(
                                            Icons.favorite,
                                            color: Colors.red,
                                          )
                                        : const Icon(Icons.favorite),
                                  ),
                                ),
                              );
                            },
                          ),
                    ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        Post post = posts[index];
                        return Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage:
                                        AssetImage(post.authorImageUrl),
                                  ),
                                  SizedBox(width: 10),
                                  Text(post.email),
                                  Spacer(),
                                  Text(
                                    "${post.title}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                             SizedBox(height: 10),
ClipRRect(
  borderRadius: BorderRadius.circular(10),
  child: Image.network(
    post.imageUrl,
    width: MediaQuery.of(context).size.width,
    height: 200,
    fit: BoxFit.cover,
  ),
),

                              SizedBox(height: 10),
                              Text(
                                post.ingredients,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: favorite_icon,
                                        onPressed: () {
                                          setState(() {
                                            int c = post.likes;

                                            isLiked = !isLiked;
                                            post.likes = ChangeColorToRed(c);
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
                                          // Navigate to comments screen
                                        },
                                      ),
                                      Text("${post.comments} Comments"),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText: 'Add a comment...',
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.send),
                                    onPressed: () {
                                      // Add send comment functionality here
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    ListView.separated(
                      padding: EdgeInsets.all(15),
                      itemCount: people.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                      itemBuilder: (context, index) {
                        Person person = people[index];
                        return ListTile(
                          title: Text(person.name),
                          subtitle: Text(person.email),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(person
                                .imageUrl), // Afficher l'image depuis l'URL
                          ),
                          trailing: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProfilePage2(person: person),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green, // Couleur verte
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10), // Ajouter du padding
                              shape: RoundedRectangleBorder(
                                // Définir une forme arrondie pour le bouton
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text('View Profile',
                                style: TextStyle(
                                    color: Colors
                                        .white)), // Couleur du texte blanc
                          ),
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  previousSearchsItem(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: InkWell(
        onTap: () {},
        child: Dismissible(
          key: GlobalKey(),
          onDismissed: (DismissDirection dir) {
            setState(() {});
            previousSearchs.removeAt(index);
          },
          child: Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              Text(
                previousSearchs[index],
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: AppColors.textColor),
              ),
              const Spacer(),
              const Icon(
                Icons.call_made_outlined,
                color: AppColors.secondaryColor,
              )
            ],
          ),
        ),
      ),
    );
  }

  _custombottomSheetFilter(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      height: 500,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "Add a Filter",
            style: Theme.of(context).textTheme.headline2,
          ),
          CustomCategoriesList(),
          CustomSlider(),
          Row(
            children: [
              Expanded(
                  child: CustomButton(
                onTap: () {
                  Navigator.pop(context);
                },
                text: "Cancel",
                color: Colors.white,
                textColor: Colors.black,
              )),
              SizedBox(
                width: 20,
              ),
              Expanded(
                  child: CustomButton(
                onTap: () {},
                text: "Done",
              ))
            ],
          )
        ],
      ),
    );
  }

  int ChangeColorToRed(int number) {
    int newNumber = number;

    if (isLiked) {
      favorite_icon = Icon(Icons.favorite, color: Colors.red);
      newNumber++;
    } else {
      favorite_icon = Icon(IconlyLight.heart);
      if (newNumber > 0) {
        newNumber--;
      }
    }

    return newNumber;
  }

  late List<Recipe> recipes = [];

  Future<void> fetchRecipesData(String query, int number) async {
    try {
      setState(() {
        recipes.clear();
      });

      final apiKey = APIkey.apikey;
      final response = await http.get(Uri.parse(
          'https://api.spoonacular.com/recipes/complexSearch?query=$query&number=$number&apiKey=$apiKey'));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> results = jsonData['results'];

        // Fetch details for each recipe
        for (var result in results) {
          final int id = result['id'];
          final recipeInfoResponse = await http.get(Uri.parse(
              'https://api.spoonacular.com/recipes/$id/information?apiKey=$apiKey'));
          if (recipeInfoResponse.statusCode == 200) {
            final recipeInfoJson = jsonDecode(recipeInfoResponse.body);
            final recipe = Recipe.fromJson(recipeInfoJson);
            recipe.isLiked = await isRecipeLikedByUser(recipe.id);
            setState(() {
              recipes.add(recipe);
            });
          }
        }
      } else {
        throw Exception('Failed to load recipes');
      }
    } catch (error) {
      // Handle errors if any
      print('Error fetching recipes: $error');
    }
  }

  Future<String?> getUserEmail() async {
    String? userEmail;
    try {
      // Récupérer l'utilisateur actuellement authentifié
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Si l'utilisateur est authentifié, récupérer son adresse e-mail
        userEmail = user.email;
      }
    } catch (e) {
      print('Error getting user email: $e');
    }
    return userEmail;
  }

  Future<void> saveLikeInfo(int recipeId) async {
    try {
      // Get the user's email
      String? userEmail = await getUserEmail();

      // Check if the user email is not null
      if (userEmail != null) {
        // If not null, save the like info to Firestore
        await FirebaseFirestore.instance.collection("favorites").add({
          'recipeId': recipeId,
          'userEmail': userEmail,
        });
        print('Like saved successfully!');
      } else {
        print('User email is null');
      }
    } catch (error) {
      print('Failed to save like: $error');
    }
  }

  Future<bool> isRecipeLikedByUser(int recipeId) async {
    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Check if a document exists in the Firestore collection
        // where both the recipeId and the user's ID match
        QuerySnapshot<Map<String, dynamic>> querySnapshot =
            await FirebaseFirestore.instance
                .collection("favorites")
                .where('recipeId', isEqualTo: recipeId)
                .where('userEmail', isEqualTo: user.email)
                .get();

        // If the document exists, the recipe is liked by the user
        return querySnapshot.docs.isNotEmpty;
      } else {
        // User is not authenticated
        return false;
      }
    } catch (error) {
      // Handle any errors
      print('Error checking if recipe is liked: $error');
      return false;
    }
  }
  Future<void> fetchUserDataByUsername(String username) async {
  try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('registration')
            .where('username', isGreaterThanOrEqualTo: username)
            .where('username', isLessThan: username + 'z')
            .get();

    final List<Person> loadedPeople = snapshot.docs.map((doc) {
      final data = doc.data();
      return Person(
        name: data['username'] ?? '',
        email: data['email'] ?? '',
        imageUrl: data['imageUrl'] ?? '',
      );
    }).toList();

    setState(() {
      people = loadedPeople;
    });
  } catch (error) {
    print('Error fetching user data: $error');
  }
}
}




// Modèle FeedItem
class FeedItem {
  final String? title;
  final String? content;
  final String? imageUrl;
  final String ingredients;
  final String instructions;
  final UserInfo user;

  FeedItem({this.title, this.content, this.imageUrl, required this.ingredients, required this.instructions, required this.user});
}

// Modèle UserInfo
class UserInfo {
  final String fullName;
  final String email;
  final String? imageUrl;

  UserInfo(this.fullName, this.email, this.imageUrl);
}

class ProfilePage2 extends StatefulWidget {
  final Person person;

  // Modifiez le constructeur pour qu'il soit correctement défini
  ProfilePage2({Key? key, required this.person}) : super(key: key);


  @override
  _ProfilePage2State createState() => _ProfilePage2State();
}

class _ProfilePage2State extends State<ProfilePage2> {
  bool isFollowing = false;
  String? fullName;
  String? email;
  String? imageUrl;
  bool isLoading = true;

  // Méthode pour obtenir l'utilisateur connecté
  Future<String?> getLoggedInUserEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.email;
    } else {
      return null;
    }
  }

  // Méthode pour mettre à jour le statut de "friend" dans les préférences partagées
  Future<void> updateFriendStatus(bool isFollowing) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('${widget.person.email}_isFriend', isFollowing);
  }

  // Méthode pour obtenir le statut de "friend" des préférences partagées
  Future<bool> getFriendStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('${widget.person.email}_isFriend') ?? false;
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();

    getFriendStatus().then((value) {
      setState(() {
        isFollowing = value;
      });
    });
  }

  // Méthode pour charger les données utilisateur du profil consulté
  Future<void> _loadUserData() async {
    await Future.delayed(Duration(seconds: 2));

    // Utiliser l'e-mail de la personne du profil
    String? currentUserEmail = widget.person.email;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 244, 206, 54),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: _TopPortion(
              imageUrl: widget.person.imageUrl,
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    widget.person.email,
                    style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FloatingActionButton.extended(
                        onPressed: () {
                          setState(() {
                            isFollowing = !isFollowing;
                            // Mettre à jour le statut de "friend" dans les préférences partagées
                            updateFriendStatus(isFollowing);
                            if (isFollowing) {
                              // Ajouter l'e-mail du follower et du following dans la collection "following"
                              getLoggedInUserEmail().then((loggedInUserEmail) {
                                if (loggedInUserEmail != null) {
                                  FirebaseFirestore.instance
                                      .collection('following')
                                      .add({
                                    'follower': loggedInUserEmail,
                                    'following': widget.person.email,
                                  });
                                }
                              });
                            } else {
                              // Supprimer le document de la collection "following"
                              getLoggedInUserEmail().then((loggedInUserEmail) {
                                if (loggedInUserEmail != null) {
                                  FirebaseFirestore.instance
                                      .collection('following')
                                      .where('follower', isEqualTo: loggedInUserEmail)
                                      .where('following', isEqualTo: widget.person.email)
                                      .get()
                                      .then((QuerySnapshot querySnapshot) {
                                    querySnapshot.docs.forEach((doc) {
                                      doc.reference.delete();
                                    });
                                  });
                                }
                              });
                            }
                          });
                        },
                        heroTag: 'follow',
                        elevation: 0,
                        backgroundColor: isFollowing ? Colors.blue : Color.fromARGB(255, 190, 244, 54),
                        label: Text(isFollowing ? "Friend" : "Follow"),
                        icon: Icon(Icons.person_add_alt_1),
                      ),
                      SizedBox(width: 16.0),
                      FloatingActionButton.extended(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ChatScreen()),
                          );
                        },
                        heroTag: 'message',
                        elevation: 0,
                        backgroundColor: Color.fromARGB(255, 244, 184, 54),
                        label: const Text("Message"),
                        icon: const Icon(Icons.message_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const _ProfileInfoRow(), // Contient Posts, Followers, Followings
                  const SizedBox(height: 16),
                  Text(
                    'Posts',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                    thickness: 2,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Center(
                      child: isLoading
                          ? CircularProgressIndicator()
                          : StreamBuilder(
                              stream: FirebaseFirestore.instance.collection('posts').where('email', isEqualTo: widget.person.email).snapshots(),
                              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                }

                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                }

                                return ListView.builder(
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
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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

class _ProfileInfoRow extends StatelessWidget {
  const _ProfileInfoRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _ProfileInfoItem(title: 'Posts', value: 20), // Remplacez 20 par le nombre de posts
        _ProfileInfoItem(title: 'Followers', value: 100), // Remplacez 100 par le nombre de followers
        _ProfileInfoItem(title: 'Followings', value: 50), // Remplacez 50 par le nombre de followings
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







// ignore: unused_element



  Widget _singleItem(BuildContext context, ProfileInfoItem item) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              item.value.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Text(
            item.title,
            style: Theme.of(context).textTheme.caption,
          )
        ],
      );


class ProfileInfoItem {
  final String title;
  final int value;
  const ProfileInfoItem(this.title, this.value);
}

