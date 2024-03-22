import 'package:flutter/material.dart';
import 'package:flutter_application_pfa/pages/models/category.dart';

class Categories extends StatelessWidget {
  const Categories({
    super.key,
    required this.currentCat,
    required this.onCategorySelected,
  });

  final String currentCat;
  final Function(String) onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          catgories.length,
          (index) => GestureDetector(
            onTap: () {
              // Appeler la fonction onCategorySelected avec la catégorie sélectionnée
              onCategorySelected(catgories[index]);
            },
            child: Container(
              decoration: BoxDecoration(
                color: currentCat == catgories[index] ? const Color.fromARGB(255, 126, 217, 87) : Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              margin: const EdgeInsets.only(right: 20),
              child: Text(
                catgories[index],
                style: TextStyle(
                  color: currentCat == catgories[index]
                      ? Colors.white
                      : Colors.grey.shade600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
