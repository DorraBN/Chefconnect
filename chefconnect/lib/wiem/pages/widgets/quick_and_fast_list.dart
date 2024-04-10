import 'dart:convert';

import 'package:chefconnect/khedmet%20salma/RecipeDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:chefconnect/khedmet salma/Food.dart';
import 'package:chefconnect/wiem/pages/models/Recipe.dart';
import 'package:chefconnect/wiem/pages/screens/quick_foods_screen.dart';

class QuickAndFastList extends StatefulWidget {
  const QuickAndFastList({Key? key}) : super(key: key);

  @override
  State<QuickAndFastList> createState() => _QuickAndFastListState();
}

class _QuickAndFastListState extends State<QuickAndFastList> {
  late List<Recipe> _randomRecipes = []; // Variable to hold random recipes

  @override
  void initState() {
    super.initState();
    fetchRandomRecipes(); // Fetch random recipes when the widget initializes
  }

  Future<void> fetchRandomRecipes() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.spoonacular.com/recipes/random?number=10&apiKey=26defb92453348b3ae5252d8c8ea9206'));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> recipesList = jsonData['recipes'];
        for (var recipeJson in recipesList) {
          final recipe = Recipe.fromJson(recipeJson);
       
          setState(() {
            _randomRecipes.add(recipe);
          });
        }
      } else {
        throw Exception('Failed to load random recipes');
      }
    } catch (error) {
      print('Error fetching random recipes: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Quick & Fast",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuickFoodsScreen(recipes: _randomRecipes),
                  ),
                );
              },
              child: const Text("View all"),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _randomRecipes.map((recipe) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecipeDetails(recipe: recipe),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  height:250,
                  width: 200,
                  child: Stack(
                   children: [
  Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: double.infinity,
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: NetworkImage(recipe.image ?? ''),
            fit: BoxFit.fill,
          ),
        ),
      ),
      const SizedBox(height: 10),
     Text(
          recipe.title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
     const SizedBox(height: 10),
      Row(
        children: [
          const Icon(
            Icons.people,
            size: 18,
            color: Colors.grey,
          ),
          Text(
            "${recipe.servings} servings",
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
           const SizedBox(height: 10),
          const Text(
            " · ",
            style: TextStyle(color: Colors.grey),
          ),
          const Icon(
            Icons.alarm,
            size: 18,
            color: Colors.grey,
          ),
          Text(
            "${recipe.readyInMinutes} Min",
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      )
    ],
  ),
  Positioned(
    top: 1,
    right: 1,
    child: IconButton(
      onPressed: () {
        setState(() {
          recipe.isLiked = !recipe.isLiked;
          if (recipe.isLiked) {
            saveLikeInfo(recipe.id);
          }
        });
      },
      style: IconButton.styleFrom(
        backgroundColor: Colors.white,
        fixedSize: const Size(30, 30),
      ),
      iconSize: 20,
      icon: recipe.isLiked
          ? const Icon(
              Icons.favorite,
              color: Colors.red,
            )
          : const Icon(Icons.favorite),
    ),
  )
],

                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
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
}
