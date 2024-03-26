import 'package:chefconnect/navigation.dart';
import 'package:chefconnect/wiem/pages/widgets/favorite_api_recipes.dart';
import 'package:chefconnect/wiem/pages/widgets/favorite_post_recipes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class FavoriteRecipesScreen extends StatefulWidget {
  const FavoriteRecipesScreen({Key? key}) : super(key: key);

  @override
  _FavoriteRecipesScreenState createState() => _FavoriteRecipesScreenState();
}

class _FavoriteRecipesScreenState extends State<FavoriteRecipesScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 0;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedIndex == 0 ? Colors.green : null,
                    ),
                    child: const Text('Favorite Recipes',style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 1;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedIndex == 1 ? Colors.green : null,
                    ),
                    child: const Text('Favorite Posts',style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _selectedIndex == 0
                  ? const FavoriteApiScreen()
                  : const FavoritePostScreen(),
            ),
          ],
        ),
      ),
  );
}
}