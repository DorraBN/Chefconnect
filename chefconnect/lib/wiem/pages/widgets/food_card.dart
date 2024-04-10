
import 'package:flutter/material.dart';
import 'package:chefconnect/khedmet salma/RecipeDetails.dart'; // Adjusted import statement
import 'package:chefconnect/wiem/pages/models/Recipe.dart'; // Import Recipe model
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FoodCard extends StatefulWidget {
  final Recipe recipe; 
  const FoodCard({Key? key, required this.recipe}) : super(key: key); // Change food to recipe

  @override
  _FoodCardState createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> {
  late bool isLiked;

  @override
  void initState() {
    super.initState();
    isLiked = widget.recipe.isLiked;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetails(recipe: widget.recipe), // Change food to recipe
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
                        image: NetworkImage(widget.recipe.image ?? ''), // Use recipe image or default value
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.recipe.title, // Use recipe title
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
                        "${widget.recipe.servings} Cal", // Use servings as calories or default value
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
                        "${widget.recipe.readyInMinutes} Min", // Use readyInMinutes as time or default value
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
                     widget.recipe.isLiked = !widget.recipe.isLiked;
                      if (isLiked) {
                        saveLikeInfo(widget.recipe.id);
                      }
                    });
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    fixedSize: const Size(30, 30),
                  ),
                  iconSize: 20,
                  icon: isLiked
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
