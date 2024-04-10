import 'dart:convert';
import 'package:chefconnect/khedmet%20salma/APIkey.dart';
import 'package:chefconnect/khedmet%20salma/RecipeDetails.dart';
import 'package:http/http.dart' as http;
import 'package:chefconnect/navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chefconnect/khedmet salma/Food.dart';

import '../models/Recipe.dart'; // Adjusted import statement

class FavoriteApiScreen extends StatefulWidget {
  const FavoriteApiScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteApiScreen> createState() => _FavoriteApiScreenState();
}

class _FavoriteApiScreenState extends State<FavoriteApiScreen> {
  List<Recipe> likedRecipes = [];
@override
void initState() {
  super.initState();
  fetchAndSetLikedRecipes();
}

Future<Set<int>> fetchLikedRecipeIds() async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection("favorites")
              .where('userEmail', isEqualTo: user.email)
              .get();
      Set<int> likedRecipeIds = querySnapshot.docs.map((doc) => doc['recipeId'] as int).toSet();
      return likedRecipeIds;
    } else {
      return {};
    }
  } catch (error) {
    print('Error fetching liked recipe IDs: $error');
    throw error;
  }
}
Future<Recipe> fetchRecipeById(int recipeId) async {
  try {
    String apiKey = APIkey.apikey;
    final response = await http.get(Uri.parse('https://api.spoonacular.com/recipes/$recipeId/information?apiKey=ddcfa9a1d9114bc8921bb717753e05e8'));
    
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      return Recipe.fromJson(json);
    } else {
      throw Exception('Failed to fetch recipe information');
    }
  } catch (error) {
    print('Error fetching recipe: $error');
    throw error;
  }
}

Future<List<Recipe>> fetchRecipesByIds(Set<int> recipeIds) async {
  List<Recipe> recipes = [];
  try {
    for (int recipeId in recipeIds) {
      Recipe recipe = await fetchRecipeById(recipeId);
      recipes.add(recipe);
    }
    return recipes;
  } catch (error) {
    print('Error fetching recipes by IDs: $error');
    throw error;
  }
}

Future<void> fetchAndSetLikedRecipes() async {
  try {
    Set<int> likedRecipeIds = await fetchLikedRecipeIds();
    List<Recipe> recipes = await fetchRecipesByIds(likedRecipeIds);
    setState(() {
      likedRecipes = recipes;
    });
  } catch (error) {
    print('Error fetching and setting liked recipes: $error');
    // Handle error appropriately
  }
}



 @override
Widget build(BuildContext context) {
  return Scaffold(
    body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: likedRecipes.length,
            itemBuilder: (context, index) {
              Recipe recipe = likedRecipes[index];
              return GestureDetector(
                onTap: () {
                  // Navigate to RecipeDetails screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecipeDetails(recipe: recipe),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
  padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
  child: Row(
    children: [
      Expanded( 
        child: Text(
          recipe.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          overflow: TextOverflow.ellipsis, 
        ),
      ),
      const Spacer(),
      IconButton(
        onPressed: () {},
        icon: recipe.isLiked
            ? const Icon(
                Icons.favorite,
                color: Colors.red,
                size: 24,
              )
            : const Icon(
                Icons.favorite,
                size: 24,
              ),
      ),
    ],
  ),
),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: recipe.image != null
                            ? Image.network(
                                recipe.image!,
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                              )
                            : Container(), // Handle case where image is null
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.dinner_dining, // Icon for servings
                                size: 20,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '${recipe.servings} Servings',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time, // Icon for readyInMinutes
                                size: 20,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '${recipe.readyInMinutes} min',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 20,
                      color: Colors.black87, // Change divider color
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    ),
  );
}

}
