import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:chefconnect/wiem/pages/models/Recipe.dart';

Future<List<Recipe>> fetchRecipes(String query) async {
  final apiKey = '95b3ba20d66b4f64bf067d0d213551ee';
  final client = http.Client();
  try {
    final response = await client.get(Uri.parse('https://api.spoonacular.com/recipes/search?apiKey=$apiKey&query=$query'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      List<Future<Recipe>> futureRecipes = results.map((json) async {
        return Recipe.fromJson(json);
      }).toList();

      // Await all futures and convert them to a list of Recipe objects
      List<Recipe> recipes = await Future.wait(futureRecipes);
      return recipes;
    } else {
      throw Exception('Failed to load recipes');
    }
  } finally {
    client.close();
  }
}


