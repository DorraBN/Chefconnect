import 'package:chefconnect/khedmet%20salma/CustomCategoriesList.dart';
import 'package:chefconnect/khedmet%20salma/CustomField.dart';
import 'package:chefconnect/khedmet%20salma/CustomSlider.dart';
import 'package:chefconnect/khedmet%20salma/Food.dart';
import 'package:chefconnect/khedmet%20salma/Post.dart';
import 'package:chefconnect/khedmet%20salma/RecipeDetails.dart';
import 'package:chefconnect/khedmet%20salma/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:chefconnect/testRecipes.dart';

import 'CustomButton.dart';

class SearchHome extends StatefulWidget {
  const SearchHome({Key? key}) : super(key: key);
  @override
  State<SearchHome> createState() => _SearchHome();
}

class _SearchHome extends State<SearchHome> {
  TextEditingController searchController = TextEditingController();
  static List previousSearchs = [];
  bool isLiked = false; // Initialize liked state
  bool isCommentVisible = true;
  Icon favorite_icon = new Icon(IconlyLight.heart);
  List<Post> posts = [
    Post(
      username: "James Elden",
      caption: "Caption for post 1",
      imageUrl: "../../assets/pancakes.jpeg",
      likes: 123,
      comments: 20,
      date: DateTime.now(),
      userProfileImageUrl: "../../assets/chat777.png",
    ),
    // Add more posts as needed
  ];
  @override
  void initState() {
    super.initState();
// Initialize comment visibility state
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 1,
          title: Text(
            "Search",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        body: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: AppColors.textColor,
                          )),
                      Expanded(
                        child: CustomTextField(
                          hint: "Search",
                          prefixIcon: IconlyLight.search,
                          controller: searchController,
                          filled: true,
                          suffixIcon: searchController.text.isEmpty
                              ? null
                              : Icons.cancel_sharp,
                          onTapSuffixIcon: () {
                            searchController.clear();
                          },
                          onChanged: (pure) {
                            setState(() {});
                          },
                          onEditingComplete: () {
                            previousSearchs.add(searchController.text);
                            /*  Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()));
                       */
                          },
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              showModalBottomSheet(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(25),
                                    ),
                                  ),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  context: context,
                                  builder: (context) =>
                                      _custombottomSheetFilter(context));
                            });
                          },
                          icon: const Icon(
                            IconlyBold.filter,
                            color: AppColors.textColor,
                          )),
                    ],
                  ),
                ),
              ),
              Material(
                child: Container(
                  height: 70,
                  color: Colors.white,
                  child: TabBar(
                    physics: const ClampingScrollPhysics(),
                    padding: EdgeInsets.only(
                        top: 10, left: 10, right: 10, bottom: 10),
                    unselectedLabelColor: AppColors.primary,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: AppColors.primary),
                    tabs: [
                      Tab(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                                color: Color.fromARGB(255, 38, 125, 0),
                                width: 1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.restaurant), // Spoon and fork icon
                              SizedBox(width: 8), // Adjust spacing as needed
                              Text("Recipes"),
                            ],
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                                color: Color.fromARGB(255, 38, 125, 0),
                                width: 1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.post_add), // Add posts icon here
                              SizedBox(width: 8), // Adjust spacing as needed
                              Text("Posts"),
                            ],
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                                color: Color.fromARGB(255, 38, 125, 0),
                                width: 1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.people), // Add people icon here
                              SizedBox(width: 8), // Adjust spacing as needed
                              Text("People"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    ListView.separated(
                      padding: EdgeInsets.all(15),
                      itemCount: FoodList.foods.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                      itemBuilder: (context, index) {
                        final recipe = FoodList.foods[index];
                        return ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TestRecipes()),
                            );
                          },
                          title: Text((recipe.name),
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          leading: Image.asset(
                            recipe.image,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          subtitle: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.access_time),
                                  Text('${recipe.time} min',
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.local_fire_department,
                                    weight: 5,
                                  ),
                                  Text('${recipe.cal} Calories',
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal)),
                                ],
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star, color: Colors.yellow),
                              Text(
                                  '${recipe.rate} (${recipe.reviews} reviews)'),
                            ],
                          ),
                        );
                      },
                    ),
                    ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        Post post = posts[index];
                        return Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage:
                                        AssetImage(post.userProfileImageUrl),
                                  ),
                                  SizedBox(width: 10),
                                  Text(post.username),
                                  Spacer(),
                                  Text(
                                    "${post.date.day}/${post.date.month}/${post.date.year}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  post.imageUrl,
                                  width: MediaQuery.of(context).size.width,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                post.caption,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: favorite_icon,
                                        onPressed: () {
                                          setState(() {
                                            int c = post.likes;

                                            isLiked = !isLiked;
                                            post.likes = ChangeColorToRed(c);
                                          });
                                        },
                                      ),
                                      Text("${post.likes} Likes"),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.comment),
                                        onPressed: () {
                                          // Navigate to comments screen
                                        },
                                      ),
                                      Text("${post.comments} Comments"),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText: 'Add a comment...',
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.send),
                                    onPressed: () {
                                      // Add send comment functionality here
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    ListView.separated(
                      padding: EdgeInsets.all(15),
                      itemCount: 20,
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {},
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                AssetImage('../../assets/chat777.png'),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'James Edlen',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Quicksand',
                                  fontSize: 17,
                                ),
                              ),
                              Text(
                                'Tap to view profile',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Quicksand',
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.message),
                            onPressed: () {
                              // Add your message button functionality here
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  previousSearchsItem(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: InkWell(
        onTap: () {},
        child: Dismissible(
          key: GlobalKey(),
          onDismissed: (DismissDirection dir) {
            setState(() {});
            previousSearchs.removeAt(index);
          },
          child: Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              Text(
                previousSearchs[index],
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: AppColors.textColor),
              ),
              const Spacer(),
              const Icon(
                Icons.call_made_outlined,
                color: AppColors.secondaryColor,
              )
            ],
          ),
        ),
      ),
    );
  }

  _custombottomSheetFilter(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      height: 500,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "Add a Filter",
            style: Theme.of(context).textTheme.headline2,
          ),
          CustomCategoriesList(),
          CustomSlider(),
          Row(
            children: [
              Expanded(
                  child: CustomButton(
                onTap: () {
                  Navigator.pop(context);
                },
                text: "Cancel",
                color: Colors.white,
                textColor: Colors.black,
              )),
              SizedBox(
                width: 20,
              ),
              Expanded(
                  child: CustomButton(
                onTap: () {},
                text: "Done",
              ))
            ],
          )
        ],
      ),
    );
  }

  int ChangeColorToRed(int number) {
    int newNumber = number;

    if (isLiked) {
      favorite_icon = Icon(Icons.favorite, color: Colors.red);
      newNumber++;
    } else {
      favorite_icon = Icon(IconlyLight.heart);
      if (newNumber > 0) {
        newNumber--;
      }
    }

    return newNumber;
  }
}
