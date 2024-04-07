import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:chefconnect/wiem/pages/widgets/food_card.dart';
import 'package:chefconnect/wiem/pages/widgets/quick_screen_appbar.dart';
import 'package:chefconnect/wiem/pages/models/Recipe.dart';

class QuickFoodsScreen extends StatefulWidget {
  final List<Recipe> recipes; 

  const QuickFoodsScreen({Key? key, required this.recipes}) : super(key: key);

  @override
  State<QuickFoodsScreen> createState() => _QuickFoodsScreenState();
}

class _QuickFoodsScreenState extends State<QuickFoodsScreen> {
  List<Recipe> _randomRecipes = []; 

  @override
  void initState() {
    super.initState();
    _fetchRandomRecipes(); 
  }

  Future<void> _fetchRandomRecipes() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.spoonacular.com/recipes/random?number=10&apiKey=7bb1455e13c6497cb22473a720b75659'));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> recipesList = jsonData['recipes'];
        setState(() {
          _randomRecipes = recipesList.map((recipeJson) => Recipe.fromJson(recipeJson)).toList();
        });
      } else {
        throw Exception('Failed to load random recipes');
      }
    } catch (error) {
      print('Error fetching random recipes: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Combine both lists of recipes
    List<Recipe> allRecipes = [...widget.recipes, ..._randomRecipes];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const QuickScreenAppbar(),
                const SizedBox(height: 60),
                _randomRecipes.isEmpty 
                    ? Center(child: CircularProgressIndicator())
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                        ),
                        itemBuilder: (context, index) {
                          final recipe = allRecipes[index];
                          return FoodCard(
                            recipe: recipe, 
                          );
                        },
                        itemCount: allRecipes.length, 
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}



