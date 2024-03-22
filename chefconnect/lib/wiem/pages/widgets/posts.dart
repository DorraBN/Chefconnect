import 'package:flutter/material.dart';

class Posts extends StatefulWidget {
  const Posts({super.key});

  @override
  
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  bool isLiked = false; // Initialize liked state for each list item
  bool isCommentVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // header of post
                      const Padding(
                        padding: EdgeInsets.only(bottom: 20, top: 20),
                        child: Row(
                          children: [
                            //image du personne qui publie la poste
                            CircleAvatar(
                                  radius: 20,
                                  backgroundImage: AssetImage(
                                      'assets/james.png'), // Replace with profile picture image
                                ),
                            // son nom
                            SizedBox(width: 10),
                                Text(
                                  "James Elden",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                          
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      // image de la poste
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0), // Rayon des coins
                          child: Image.asset('assets/tunisian.png'),
                        ),
                      ),
                      const SizedBox(height: 10),
                      //caption for the post
                      const Text(
                            "Caption for post ", // Replace with your post caption
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //likes
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      // ignore: dead_code
                                      isLiked
                                          // ignore: dead_code
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      // ignore: dead_code
                                      color: isLiked ? Colors.red : null, // Change color when liked
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        // Toggle liked state
                                        isLiked = !isLiked;
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 5),
                                  const Text(
                                    "123 Likes",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              //comments
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.comment),
                                    onPressed: () {
                                      // Toggle visibility state
                                      setState(() {
                                        isCommentVisible =
                                            !isCommentVisible;
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 5),
                                  const Text(
                                    "20 Comments",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                      ),
                      // write a comment
                      if (isCommentVisible)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                                children: [
                                  const Expanded(
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText: "Add a comment...",
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.send),
                                    onPressed: () {
                                      // Add send comment functionality
                                    },
                                  ),
                                ],
                        ),
                      ),




                      Divider(
                        height: 20,
                        color: Colors.grey.shade300,
                      ),





                      Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: const DecorationImage(
                                image: AssetImage('assets/1.png'),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Ramen Noodles",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "400g",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade400,
                            ),
                          )
                        ],
                      ),
                      Divider(
                        height: 20,
                        color: Colors.grey.shade300,
                      ),
                      Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: const DecorationImage(
                                image: AssetImage('assets/1.png'),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Ramen Noodles",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "400g",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade400,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
    );
  }
}

