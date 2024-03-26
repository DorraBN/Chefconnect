import 'package:flutter/material.dart';
import 'package:chefconnect/khedmet salma/RecipeDetails.dart'; // Adjusted import statement
import '../../../khedmet salma/Food.dart';

class FoodCard extends StatelessWidget {
  final Food food;
  const FoodCard({Key? key, required this.food}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
       /* Navigator.push(
          context,
          MaterialPageRoute(
           builder: (context) => RecipeDetails(food: food),
          ),
        );*/
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        width: 200,
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
                      image: AssetImage(food.image),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  food.name,
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
                      "${food.cal} Cal",
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
                      "${food.time} Min",
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
                icon: food.isLiked
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
    );
  }
}
