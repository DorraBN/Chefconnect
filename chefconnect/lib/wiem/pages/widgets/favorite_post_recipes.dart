
import 'package:chefconnect/wiem/pages/models/food.dart';
import 'package:flutter/material.dart';


class FavoritePostScreen extends StatefulWidget {
  const FavoritePostScreen({super.key});

  @override
  State<FavoritePostScreen> createState() => _FavoritePostScreenState();
}

class _FavoritePostScreenState extends State<FavoritePostScreen> {
      List<Food> likedFoods = foods.where((food) => food.isLiked).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold();
        
   
  }
}