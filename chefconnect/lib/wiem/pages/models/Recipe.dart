import 'dart:convert';
import 'dart:typed_data';
import 'package:chefconnect/khedmet%20salma/APIkey.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class Recipe {
  final int id;
  final String rating = "4.5/5";
  final String title;
  final String? image;
  final String? sourceUrl;
  final int readyInMinutes;
  final int servings;
  final List<Uint8List> ingredients;
  late final String description;
  bool isLiked;
  Recipe({
    required this.id,
    required this.title,
    this.image,
    this.sourceUrl,
    this.isLiked=false,
    required this.description,
    required this.readyInMinutes,
    required this.servings,
    required this.ingredients,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      sourceUrl: json['sourceUrl'],
      readyInMinutes: json['readyInMinutes'],
      servings: json['servings'],
      description: json['summary'],
      ingredients: [],
    );
  }

  Future<Recipe> createFromJson(Map<String, dynamic> json) async {
    List<dynamic> extendedIngredients = json['extendedIngredients'];
    List<Uint8List> ingredients = [];
    for (var ingredient in extendedIngredients) {
      final int id = ingredient['id'];
      final image = await _fetchIngredientImage(id);
      ingredients.add(image);
    }

    return Recipe(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      sourceUrl: json['sourceUrl'],
      readyInMinutes: json['readyInMinutes'],
      servings: json['servings'],
      description: json['summary'],
      ingredients: ingredients,
    );
  }

  Future<Uint8List> _fetchIngredientImage(int recipeId) async {
    String apiKey = APIkey.apikey;
    final url =
        'https://api.spoonacular.com/recipes/$recipeId/ingredientWidget.png?apiKey=$apiKey';
    final response = await http.get(Uri.parse(url));

    print('Fetching image from URI: $url');

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to fetch ingredient image');
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
