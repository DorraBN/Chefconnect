import 'package:flutter/material.dart';
import 'package:chefconnect/khedmet salma/RecipeDetails.dart'; // Adjusted import statement
import 'package:chefconnect/wiem/pages/models/Recipe.dart'; // Import Recipe model

class FoodCard extends StatelessWidget {
  final Recipe recipe; // Change food to recipe
  const FoodCard({Key? key, required this.recipe}) : super(key: key); // Change food to recipe

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetails(recipe: recipe), // Change food to recipe
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        width: 200,
        child: SingleChildScrollView(
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
                        image: NetworkImage(recipe.image ?? ''), // Use recipe image or default value
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    recipe.title, // Use recipe title
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.flash_auto,
                        size: 18,
                        color: Colors.grey,
                      ),
                      Text(
                        "${recipe.servings} Cal", // Use servings as calories or default value
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
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
                        "${recipe.readyInMinutes} Min", // Use readyInMinutes as time or default value
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
                  onPressed: () {},
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
      ),
    );
  }
}
