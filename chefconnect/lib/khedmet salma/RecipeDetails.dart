import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Food.dart';
import 'package:flutter_application_1/styles/app_colors.dart';

class RecipeDetails extends StatelessWidget {
  final Food food;

  const RecipeDetails({Key? key, required this.food}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: Image.asset(food.image),
          ),
          buttonArrow(context),
          scroll(),
        ],
      ),
    ));
  }

  buttonArrow(BuildContext context) {
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
              height: 55,
              width: 55,
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

  scroll() {
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
                topRight: const Radius.circular(20)),
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
            Row(
  children: [
    Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      "${food.name}",
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),
    SizedBox(height: 10), // Add space between food name and subtitle
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.access_time),
            Text(
              '${food.time} min',
              style: TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.local_fire_department,
              weight: 5, // There is no weight property in Icon widget
            ),
            Text(
              '${food.cal} Calories',
              style: TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ],
    ),
  ],
),
    SizedBox(width: 70),
    IconButton(
      icon: Icon(
        Icons.share,
        size: 40, // Increase the size of the icon
        color: Colors.black, // Optionally, you can change the color of the icon
      ),
      onPressed: () {
        // Add onPressed functionality here
      },
    ),
  ],
),

                const SizedBox(
                  height: 2,
                ),
                Text(
                  "",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: AppColors.secondaryColor),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Text(
                      "Intolerances:",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontSize: 18)
                          .copyWith(color: AppColors.secondaryColor),
                    ),
                    SizedBox(width: 10), // Adjust spacing between images
                    Column(
                      children: [
                        Image.asset(
                          "assets/images/allergies/peanuts.png",
                          height: 40,
                        ),
                      ],
                    ),
                    SizedBox(width: 10), // Adjust spacing between images
                    Column(
                      children: [
                        Image.asset(
                          "assets/images/allergies/nuts.png",
                          height: 40,
                        ),
                      ],
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        print("recipe favored");
                        // Handle the click event here
                      },
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: AppColors.primary,
                        child: Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),

                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "${food.reviews} Likes",
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall!
                          .copyWith(color: AppColors.textColor, fontSize: 15),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Divider(
                    height: 4,
                  ),
                ),
                Text(
                  "Description",
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge!
                      .copyWith(fontSize: 30),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '${food.description}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: AppColors.secondaryColor),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Divider(
                    height: 4,
                  ),
                ),
                Text(
                  "Ingredients",
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge!
                      .copyWith(fontSize: 30),
                ),
                const SizedBox(
                  height: 10,
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: food.ingredients.length,
                  itemBuilder: (context, index) => ingredientRow(
                      context,
                      food.ingredients.keys.elementAt(index),
                      food.ingredients.values.elementAt(index)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

ingredients(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CircleAvatar(
          backgroundColor: AppColors.primary,
          radius: 12,
          child: Text(
            "${food.ingredients.keys.length}", // Display the total number of ingredients
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var ingredient in food.ingredients.keys)
              ingredientRow(
                context,
                ingredient,
                food.ingredients[ingredient]!,
              ),
          ],
        ),
      ],
    ),
  );
}

Widget ingredientRow(BuildContext context, String ingredientName, String ingredientImage) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      children: [
        CircleAvatar(
          radius: 20, // Adjust the radius of the CircleAvatar
          backgroundColor: Color(0xFFE3FFF8),
          child: Icon(
            Icons.done,
            size: 20,
            color: AppColors.primary,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            ingredientName,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        SizedBox(width: 10),
        SizedBox(
          height: 150, // Adjust the height of the container
          width: 150, // Adjust the width of the container
          child: Align(
            alignment: Alignment.center,
            child: Image.asset(
              ingredientImage,
              height: 150, // Adjust the height of the image
              width: 150, // Adjust the width of the image
            ),
          ),
        ),
      ],
    ),
  );
}




  steps(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary,
            radius: 12,
            child: Text("${index + 1}"),
          ),
          Column(
            children: [
              SizedBox(
                width: 270,
                child: Text(
                  "Your recipe has been uploaded, you can see it on your profile. Your recipe has been uploaded, you can see it on your",
                  maxLines: 3,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.textColor,
                      ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Image.asset(
                "assets/images/Rectangle 219.png",
                height: 155,
                width: 270,
              )
            ],
          )
        ],
      ),
    );
  }
}
