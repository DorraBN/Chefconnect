import 'dart:convert';
import 'package:http/http.dart' as http;

class Recipe {
  final int id;
  final String title;
  final String? image;
  final String? sourceUrl;
  final int readyInMinutes;
  final int servings;

  Recipe({
    required this.id,
    required this.title,
    this.image,
    this.sourceUrl,
    required this.readyInMinutes,
    required this.servings,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      title: json['title'],
      image:  json['image'],
      sourceUrl: json['sourceUrl'],
      readyInMinutes: json['readyInMinutes'],
      servings: json['servings'],
    );
  }
}

Future<List<Recipe>> fetchRecipes(String query) async {
  final apiKey = 'cdf1a5fc5dbb4d3c883962891245f760';
  final client = http.Client();
  try {
    final response = await client.get(Uri.parse('https://api.spoonacular.com/recipes/complexSearch?apiKey=$apiKey&query=$query'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      return results.map((json) => Recipe.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load recipes');
    }
  } finally {
    client.close();
  }
}
