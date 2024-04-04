import 'dart:convert';
import 'package:chefconnect/khedmet%20salma/APIkey.dart';
import 'package:chefconnect/khedmet%20salma/CustomCategoriesList.dart';
import 'package:chefconnect/khedmet%20salma/CustomField.dart';
import 'package:chefconnect/khedmet%20salma/CustomSlider.dart';
import 'package:chefconnect/khedmet%20salma/Food.dart';
import 'package:chefconnect/khedmet%20salma/Post.dart';
import 'package:chefconnect/khedmet%20salma/RecipeDetails.dart';
import 'package:chefconnect/khedmet%20salma/SearchPage.dart';
import 'package:chefconnect/khedmet%20salma/styles/app_colors.dart';
import 'package:chefconnect/wiem/pages/models/Recipe.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:chefconnect/testRecipes.dart';
import 'dart:ui' as ui;
import 'khedmet salma/CustomButton.dart';

class SearchHome extends StatefulWidget {
  const SearchHome({Key? key}) : super(key: key);
  @override
  State<SearchHome> createState() => _SearchHome();
}
class Person {
  final String name;
  final String email;

  Person({required this.name, required this.email});
}
class _SearchHome extends State<SearchHome> {
  TextEditingController searchController = TextEditingController();
  static List previousSearchs = [];
  bool isLiked = false; // Initialize liked state
  bool isCommentVisible = true;
 late List<Person> people = [];
  Icon favorite_icon = new Icon(IconlyLight.heart);
  List<Post> posts = [
    Post(
      username: "James Elden",
      caption: "Caption for post 1",
      imageUrl: "../../assets/pancakes.jpeg",
      likes: 123,
      comments: 20,
      date: DateTime.now(),
      userProfileImageUrl: "../../assets/chat777.png",
    ),
  ];
  @override
  void initState() {
    super.initState();
     fetchPeopleData();
  }
 Future<void> fetchPeopleData() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('registration').get();

      final List<Person> loadedPeople = snapshot.docs.map((doc) {
        final data = doc.data();
        return Person(
          name: data['name'] ?? '',
          email: data['email'] ?? '',
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
                                        AssetImage(post.userProfileImageUrl),
                                  ),
                                  SizedBox(width: 10),
                                  Text(post.username),
                                  Spacer(),
                                  Text(
                                    "${post.date.day}/${post.date.month}/${post.date.year}",
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
                                child: Image.asset(
                                  post.imageUrl,
                                  width: MediaQuery.of(context).size.width,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                post.caption,
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
                        fetchPeopleData();
                        Person person = people[index];
                        return ListTile(
                          title: Text(person.name),
                          subtitle: Text(person.email),
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
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
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

}
