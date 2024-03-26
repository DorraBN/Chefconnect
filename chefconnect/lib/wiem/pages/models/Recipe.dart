import 'dart:convert';
import 'dart:typed_data';
import 'package:chefconnect/khedmet%20salma/APIkey.dart';
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
  final String description;

  Recipe({
    required this.id,
    required this.title,
    this.image,
    this.sourceUrl,
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
   final url = 'https://api.spoonacular.com/recipes/$recipeId/ingredientWidget.png?apiKey=$apiKey';
    final response = await http.get(Uri.parse(url));

  print('Fetching image from URI: $url');

  if (response.statusCode == 200) {
    return response.bodyBytes;
  } else {
    throw Exception('Failed to fetch ingredient image');
  }
}

}






