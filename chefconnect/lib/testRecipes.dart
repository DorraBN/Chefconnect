import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconly/iconly.dart';
import 'package:chefconnect/wiem/pages/models/Recipe.dart';

class TestRecipes extends StatefulWidget {
  @override
  _TestRecipesState createState() => _TestRecipesState();
}

class _TestRecipesState extends State<TestRecipes> {
  late List<Recipe> recipes = [];

  @override
  void initState() {
    super.initState();
    fetchRecipesData();
  }

  Future<void> fetchRecipesData() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.spoonacular.com/recipes/complexSearch?query=chicken&apiKey=436c43ec025b43ecaff23cd2915e586e'));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> results = jsonData['results'];

        // Fetch details for each reciper
        for (var result in results) {
          final int id = result['id'];
          final recipeInfoResponse = await http.get(Uri.parse(
              'https://api.spoonacular.com/recipes/$id/information?apiKey=436c43ec025b43ecaff23cd2915e586e'));
          if (recipeInfoResponse.statusCode == 200) {
            final recipeInfoJson = jsonDecode(recipeInfoResponse.body);
            final recipe = Recipe.fromJson(recipeInfoJson);
            recipes.add(recipe);
          }
        }

        setState(() {}); // Refresh the UI
      } else {
        throw Exception('Failed to load recipes');
      }
    } catch (error) {
      // Handle errors if any
      print('Error fetching recipes: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Your app bar content
      ),
      body: recipes.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: EdgeInsets.all(15),
              itemCount: recipes.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                return ListTile(
                  onTap: () {
                   
                  },
                  title: Text(recipe.title,
                      style: TextStyle(fontWeight: FontWeight.bold)),
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
                              style: TextStyle(fontWeight: FontWeight.normal)),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.local_fire_department),
                          Text('${recipe.servings} Servings',
                              style: TextStyle(fontWeight: FontWeight.normal)),
                        ],
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, color: Colors.yellow),
                      Text('${recipe.id}'), // Adjust as per your requirement
                    ],
                  ),
                );
              },
            ),
    );
  }
}
