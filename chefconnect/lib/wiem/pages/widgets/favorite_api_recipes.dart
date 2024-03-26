import 'package:chefconnect/navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chefconnect/wiem/pages/models/food.dart';
import 'package:chefconnect/wiem/pages/screens/recipe_screen.dart';

class FavoriteApiScreen extends StatefulWidget {
  const FavoriteApiScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteApiScreen> createState() => _FavoriteApiScreenState();
}

class _FavoriteApiScreenState extends State<FavoriteApiScreen> {
  List<Food> likedFoods = foods.where((food) => food.isLiked).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Ajout du Scaffold
     appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 244, 206, 54),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Favorites recipes'),
            IconButton(
              icon: Icon(Icons.favorite),
              onPressed: () {
                // Add logic to edit profile
              },
            ),
          ],
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(CupertinoIcons.chevron_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: likedFoods.length,
              itemBuilder: (context, index) {
                Food food = likedFoods[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeScreen(food: food),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20, top: 20, left: 15, right: 15),
                        child: Row(
                          children: [
                            Text(
                              food.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {},
                              icon: food.isLiked
                                  ? const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                                  : const Icon(Icons.favorite),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20, left: 15, right: 15),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.asset(food.image),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
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
                            ),
                            Row(
                              children: [
                                Icon(Icons.star,
                                    color: Colors.yellow.shade700, size: 20),
                                const SizedBox(width: 5),
                                Text(
                                  "${food.rate}/5",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color.fromARGB(255, 117, 117, 117),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "(${food.reviews} Reviews)",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color.fromARGB(255, 189, 189, 189),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      const Divider(
                        height: 20,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    bottomNavigationBar: CustomBottomNavigationBar(),
  );
}
}
