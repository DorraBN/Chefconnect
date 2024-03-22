
import 'package:flutter/material.dart';
import 'package:flutter_application_pfa/pages/models/food.dart';

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