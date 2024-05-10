import 'package:chefconnect/myprofile.dart';

import 'package:chefconnect/newpost.dart';
import 'package:chefconnect/wiem/pages/screens/home_screen.dart';
import 'package:chefconnect/wiem/pages/widgets/favorite_api_recipes.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'ChatScreen.dart';

class ChatHome extends StatelessWidget {
  const ChatHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [Color.fromARGB(255, 114, 242, 108), Color.fromARGB(255, 244, 207, 84)],
      ),
    ),
        child: SafeArea(
          child: SingleChildScrollView(
          
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                 padding: EdgeInsets.all(16.0),
             child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Messages',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: ('Quicksand'),
                        fontSize: 30,
                        color: Colors.white),
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 36,
                                   ),
                      ),
                    ],
                  ),
                ),
              SizedBox(
                height: 5,
              ),
           Padding (    padding: EdgeInsets.all(16.0),
            child:   Text(
                'R E C E N T',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
           ),
              SizedBox(
                height: 15,
              ),
             Padding(
           padding: EdgeInsets.only(left: 16.0),
             child:  SizedBox(
                height: 110,
                
                child: ListView(scrollDirection: Axis.horizontal, children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            Image.asset('../../assets/image1.jpeg').image,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Mark doe',
                        style: TextStyle(color: Colors.black, fontSize: 18,fontWeight: FontWeight.bold,),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            Image.asset('../../assets/jane.jpeg').image,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Jane Austen',
                        style: TextStyle(color: Colors.black, fontSize: 18,fontWeight: FontWeight.bold,),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            Image.asset('../../assets/justin.png').image,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'jill',
                        style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold,),
                      )
                    ],
                  ),
                 
               
                 
                ]),
              ),  
             ),
          
              SizedBox(
                height: 20,
              ),
              Container(
                height: 555,
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    )),
                child: ListView(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatScreen()));
                      },
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 26.0, top: 35, right: 10),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  Image.asset('../../assets/image1.jpeg').image,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Mark doe',
                                      style: TextStyle(
                                          color: Colors.black,
                                         fontWeight: FontWeight.bold,
                                          fontFamily: ('Quicksand'),
                                          fontSize: 17),
                                    ),
                                    SizedBox(
                                      width: 100,
                                    ),
                                    Text(
                                      'now',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'welcome you both to chefconnect messagerie',
                                  style: TextStyle(
                                    color: Colors.black,
                             
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 26.0, top: 35, right: 10),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                Image.asset('../../assets/jane.jpeg').image,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Jane austen',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: ('Quicksand'),
                                        fontSize: 17),
                                  ),
                                  SizedBox(
                                    width: 100,
                                  ),
                                  Text(
                                    'now',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'welcome you both to chefconnect messagerie',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 26.0, top: 35, right: 10),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                Image.asset('../../assets/justin.png').image,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Justin Jill',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: ('Quicksand'),
                                        fontSize: 17),
                                  ),
                                  SizedBox(
                                    width: 120,
                                  ),
                                  Text(
                                    'now',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'welcome you both to chefconnect messagerie',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                
                   
                  
                    
                         
                  ],
                ),
              ),
            ],
          ),
        ),
        ),
      ),
      
    );
  }
}
 