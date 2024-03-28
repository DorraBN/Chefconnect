import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:html/parser.dart' as htmlParser; // Importer htmlParser
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

        // Fetch details for each recipe
        for (var result in results) {
          final int id = result['id'];
          final recipeInfoResponse = await http.get(Uri.parse(
              'https://api.spoonacular.com/recipes/$id/information?apiKey=436c43ec025b43ecaff23cd2915e586e'));
          if (recipeInfoResponse.statusCode == 200) {
            final recipeInfoJson = jsonDecode(recipeInfoResponse.body);
            final recipe = Recipe.fromJson(recipeInfoJson);
            recipe.description = _removeHtmlTags(recipe.description);
            recipes.add(recipe);
          }
        }

        setState(() {});
      } else {
        throw Exception('Failed to load recipes');
      }
    } catch (error) {
    
      print('Error fetching recipes: $error');
    }
  }

  String _removeHtmlTags(String? htmlText) {
    if (htmlText != null) {
      var document = htmlParser.parse(htmlText); // Utiliser la méthode parse de htmlParser
      String parsedString = document.body!.text; // Récupérer le texte du body
      return parsedString;
    } else {
      return ''; // Retourner une chaîne vide si htmlText est null
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes'),
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
                    // Handle tap
                  },
                  title: Text(recipe.title,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  leading: recipe.image != null
                      ? Image.network(
                          recipe.image!,
                          width: 100,
                          height: 100, 
                          fit: BoxFit.cover, 
                        )
                      : SizedBox(
                          width: 100,
                          height: 100,
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
                      Text(
                        _removeHtmlTags(recipe.description),
                        maxLines: 2, 
                        overflow: TextOverflow.ellipsis, 
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, color: Colors.yellow),
                      Text('${recipe.id}'), 
                    ],
                  ),
                );
              },
            ),
    );
  }
}
