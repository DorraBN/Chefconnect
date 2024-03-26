import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:chefconnect/khedmet%20salma/APIkey.dart';
import 'package:chefconnect/wiem/pages/models/Recipe.dart';
import 'package:chefconnect/khedmet%20salma/styles/app_colors.dart';

class RecipeDetails extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetails({Key? key, required this.recipe}) : super(key: key);

@override
Widget build(BuildContext context) {
  return SafeArea(
    child: Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: recipe.image != null
                  ? Container(
                      width: 150, // Specify the desired width
                      height: 150, // Specify the desired height
                      child: Image.network(
                        recipe.image!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Placeholder(),
            ),
          ),
          _buildBackButton(context),
          _buildScrollContent(context),
        ],
      ),
    ),
  );
}


  Widget _buildBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          clipBehavior: Clip.hardEdge,
          height: 55,
          width: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                size: 40,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScrollContent(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 1.0,
      minChildSize: 0.6,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: const Radius.circular(20),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 5,
                        width: 35,
                        color: Colors.black12,
                      ),
                    ],
                  ),
                ),
                Text(
                  recipe.title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                children: [
                  Icon(Icons.access_time),
                  SizedBox(width: 5),
                  Text(
                    '${recipe.readyInMinutes} min',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.people),
                  SizedBox(width: 5),
                  Text(
                    '${recipe.servings} servings',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
                SizedBox(height: 10),
                SizedBox(width: 70),
                IconButton(
                  icon: Icon(
                    Icons.share,
                    size: 40,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    // Handle onPressed
                  },
                ),
                const SizedBox(height: 2),
                const SizedBox(height: 15),
                const SizedBox(height: 10),
                const SizedBox(height: 10),
                Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  recipe.description,
                  style: TextStyle(
                    color: AppColors.secondaryColor,
                  ),
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 10),
                const SizedBox(height: 15),
                Text(
                  'Ingredients',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
                const SizedBox(height: 10),
                _buildIngredientImage(recipe.id),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildIngredientImage(int recipeId) {
    return FutureBuilder<String>(
      future: fetchIngredientImage(recipeId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error loading ingredient image');
        } else if (snapshot.hasData) {
          return _buildImageWidget(snapshot.data!);
        } else {
          return SizedBox();
        }
      },
    );
  }

  Widget _buildImageWidget(String imageUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        height: 150,
        width: 150,
        child: Image.network(
          imageUrl,
          height: 150,
          width: 150,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Future<String> fetchIngredientImage(int recipeId) async {
    String apiKey = APIkey.apikey;
    final response = await http.get(
      Uri.parse(
        'https://api.spoonacular.com/recipes/$recipeId/ingredientWidget.png?apiKey=$apiKey',
      ),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to fetch ingredient image');
    }
  }
}


