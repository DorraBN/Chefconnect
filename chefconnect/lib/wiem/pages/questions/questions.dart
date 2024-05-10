 import 'package:chefconnect/image.dart';
 import 'package:chefconnect/login.dart';
 import 'package:flutter/material.dart';
 import 'package:firebase_core/firebase_core.dart';
 import 'package:cloud_firestore/cloud_firestore.dart';
 import 'package:concentric_transition/page_view.dart';
  // Ajout de l'import pour l'image.dart

// final pages = [
//   const PageData(
//     bgColor: Color.fromARGB(255, 255, 255, 255),
//     textColor: Colors.white,
//     question: "Which cuisine do you prefer?",
//     responses: [
//       "Tunisian", "Italian", "Asian",
//       "British", "French", "Chinese",
//       "Middle East", "Irish", "German",
//       "Korean", "Greek", "Mexican",
//     ],
//     responseBackgroundImages: [
//       "assets/tunisian.png", "assets/italian.png", "assets/asian.png",
//       "assets/british.png", "assets/french.png", "assets/chinese.png",
//       "assets/middleeast.png", "assets/irish.png", "assets/german.png",
//       "assets/korean.png", "assets/greek.png", "assets/mexican.png",
//     ],
//   ),
//   const PageData(
//     bgColor: Color.fromARGB(135, 255, 219, 186),
//     textColor: Color.fromARGB(255, 8, 8, 10),
//     question: "What's your dietary preference?",
//     responses: [
//       "Gluten Free", "Ketogenic", "Vegetarian",
//       "Lacto-Vegetarian", "Ovo-Vegetarian", "Vegan",
//       "Pescetarian", "Paleo", "Primal",
//       "Low FODMAP", "Whole30","Flexitarian",
//     ],
//     responseBackgroundImages: [
//       "assets/glutenfree.png","assets/ketogenic.png","assets/vegetarian.png",
//       "assets/lactovegetarian.png","assets/ovovegetarian.png","assets/vegan.png",
//       "assets/pescetarian.png","assets/paleo.png","assets/primal.png",
//       "assets/lowfoodmaps.png","assets/whole30.png","assets/flexitarien.png",
//     ],
//   ),
//   const PageData(
//     bgColor:Color.fromARGB(136, 211, 253, 193),
//     textColor: Color(0xff3b1790),
//     question: "Which allergies do you have?",
//     responses: [
//       "Gluten", "Dairy", "Sesame",
//       "Seafood", "Egg", "Soy",
//       "Wheat", "Peanut","Tree nuts",
//       "Mustard" , "Lupin" , "Sulfites" ,
//     ],
//     responseBackgroundImages: [
//       "assets/gluten.png", "assets/diary.png", "assets/sesame.png",
//       "assets/seafood.png", "assets/egg.png", "assets/soy.png",
//       "assets/wheat.png", "assets/peanut.png","assets/treenuts.png",
//       "assets/mustard.png", "assets/lupin.png","assets/sulfites.png",
//     ],
//   ),
// ];

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Concentric Onboarding',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: ConcentricAnimationOnboarding(),
//     );
//   }
// }

// class ConcentricAnimationOnboarding extends StatefulWidget {
//   @override
//   _ConcentricAnimationOnboardingState createState() => _ConcentricAnimationOnboardingState();
// }

// class _ConcentricAnimationOnboardingState extends State<ConcentricAnimationOnboarding> {
//   bool isCardSelected = false;

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     return Scaffold(
//       body: ConcentricPageView(
//         colors: pages.map((p) => p.bgColor).toList(),
//         nextButtonBuilder: (context) => Padding(
//           padding: const EdgeInsets.only(left: 3),
//           child: ElevatedButton(
//             onPressed: isCardSelected ? () {} : null,
//             child: Icon(
//               Icons.navigate_next,
//               size: screenWidth * 0.08,
//             ),
//           ),
//         ),
//         itemBuilder: (index) {
//           final page = pages[index % pages.length];
//           return SafeArea(
//             child: _Page(
//               page: page,
//               onCardSelected: () {
//                 setState(() {
//                   isCardSelected = true;
//                 });
//               },
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => LoginPage()),
//           );
//         },
        
//         icon: Icon(Icons.navigate_next),
//         label: Text('Skip'),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
//     );
//   }
// }

// class PageData {
//   final Color bgColor;
//   final Color textColor;
//   final String? question;
//   final List<String>? responses;
//   final List<String>? responseBackgroundImages;

//   const PageData({
//     required this.bgColor,
//     required this.textColor,
//     this.question,
//     this.responses,
//     this.responseBackgroundImages,
//   });
// }

// class _Page extends StatelessWidget {
//   final PageData page;
//   final VoidCallback onCardSelected;

//   const _Page({required this.page, required this.onCardSelected});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         if (page.question != null) ...[
//           const SizedBox(height: 80),
//           Text(
//             page.question!,
//             style: const TextStyle(
//               fontSize: 25,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 20),
      
//         if (page.responses != null && page.responseBackgroundImages != null)
//             _buildResponseRows(context, page.responses!, page.responseBackgroundImages!),
//         ],
//         const Spacer(),
//       ],
//     );
//   }

//   Widget _buildResponseRows(BuildContext context, List<String> responses, List<String> backgroundImages) {
//     List<Widget> rows = [];
//     for (int i = 0; i < responses.length; i += 3) {
//       List<String> currentResponses = responses.sublist(i, i + 3);
//       List<String> currentBackgroundImages = backgroundImages.sublist(i, i + 3);
//       rows.add(_buildResponseRow(context, currentResponses, currentBackgroundImages));
//     }
//     return Column(children: rows);
//   }

//   Widget _buildResponseRow(BuildContext context, List<String> responses, List<String> backgroundImages) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: List.generate(responses.length, (index) {
//         return GestureDetector(
//           onTap: () {
//             onCardSelected();
//             _saveResponseToFirestore(responses[index]); // Enregistrer la réponse dans Firestore
//           },
//           child: _ResponseCard(
//             response: responses[index],
//             backgroundImage: backgroundImages[index
// ],
//           ),
//         );
//       }),
//     );
//   }

//   Future<void> _saveResponseToFirestore(String response) async {
//     try {
//       await FirebaseFirestore.instance.collection('registration').add({
//         'response': response,
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//       print('Response saved to Firestore: $response');
//     } catch (error) {
//       print('Failed to save response to Firestore: $error');
//     }
//   }
// }

// class _ResponseCard extends StatefulWidget {
//   final String response;
//   final String backgroundImage;

//   const _ResponseCard({required this.response, required this.backgroundImage});

//   @override
//   _ResponseCardState createState() => _ResponseCardState();
// }

// class _ResponseCardState extends State<_ResponseCard> {
//   bool isSelected = false;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           isSelected = !isSelected; // Inverser l'état de sélection
//         });
//       },
//       child: Card(
//         color: isSelected ? const Color.fromARGB(255, 171, 174, 172) : null, // Changer la couleur si la carte est sélectionnée
//         child: Container(
//           width: 100,
//           height: 90,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(
//               color: isSelected ? const Color.fromARGB(255, 28, 239, 24) : Colors.transparent, // Couleur de la bordure en fonction de l'état de sélection
//               width: 2, // Largeur de la bordure
//             ),
//             image: DecorationImage(
//               image: AssetImage(widget.backgroundImage),
//               fit: BoxFit.cover,
//               colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
//             ),
//           ),
//           child: Center(
//             child: Text(
//               widget.response,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }



class ConcentricAnimationOnboarding extends StatelessWidget {
  final String userEmail;
    static late String _cachedEmail;

  const ConcentricAnimationOnboarding({Key? key, required this.userEmail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
       _cachedEmail = userEmail;
    return Scaffold(
    
      body: OnboardingPagePresenter(
        pages: [
          OnboardingPageModel(
            backgroundImage: "../../../assets/bg1.png",
            textColor: const Color.fromARGB(255, 0, 0, 0),
            question: "Which cuisine do you prefer?",
            responses: [
              "Tunisian", "Italian", "Asian",
              "British", "French", "Chinese",
              "Middle East", "Irish", "German",
              "Korean", "Greek", "Mexican",
            ],
            responseBackgroundImages: [
              "assets/tunisian.png", "assets/italian.png", "assets/asian.png",
              "assets/british.png", "assets/french.png", "assets/chinese.png",
              "assets/middleeast.png", "assets/irish.png", "assets/german.png",
              "assets/korean.png", "assets/greek.png", "assets/mexican.png",
            ],
          ),
          OnboardingPageModel(
            backgroundImage: "assets/bg1.png",
            textColor: Color.fromARGB(255, 8, 8, 10),
            question: "What's your dietary preference?",
            responses: [
              "Gluten Free", "Ketogenic", "Vegetarian",
              "Lacto-Vegetarian", "Ovo-Vegetarian", "Vegan",
              "Pescetarian", "Paleo", "Primal",
              "Low FODMAP", "Whole30","Flexitarian",
            ],
            responseBackgroundImages: [
              "assets/glutenfree.png","assets/ketogenic.png","assets/vegetarian.png",
              "assets/lactovegetarian.png","assets/ovovegetarian.png","assets/vegan.png",
              "assets/pescetarian.png","assets/paleo.png","assets/primal.png",
              "assets/lowfoodmaps.png","assets/whole30.png","assets/flexitarien.png",
            ],
          ),
          OnboardingPageModel(
            backgroundImage: "assets/bg1.png",
            textColor: Color.fromARGB(255, 0, 0, 0),
            question: "Which allergies do you have?",
            responses: [
              "Gluten", "Dairy", "Sesame",
              "Seafood", "Egg", "Soy",
              "Wheat", "Peanut","Tree nuts",
              "Mustard" , "Lupin" , "Sulfites" ,
            ],
            responseBackgroundImages: [
              "assets/gluten.png", "assets/diary.png", "assets/sesame.png",
              "assets/seafood.png", "assets/egg.png", "assets/soy.png",
              "assets/wheat.png", "assets/peanut.png","assets/treenuts.png",
              "assets/mustard.png", "assets/lupin.png","assets/sulfites.png",
            ],
          ),
        ],
        userEmail: userEmail, // Pass the user's email here
      ),
    );
  }
  static String getCachedEmail() {
    return _cachedEmail;
  }
}




class OnboardingPagePresenter extends StatefulWidget {
  final List<OnboardingPageModel> pages;
  final VoidCallback? onSkip;
  final VoidCallback? onFinish;

  const OnboardingPagePresenter({
    Key? key,
    required this.pages,
    this.onSkip,
    this.onFinish, required String userEmail,
  }) : super(key: key);

  @override
  State<OnboardingPagePresenter> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPagePresenter> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);
  List<Map<String, dynamic>> selectedResponses = []; // Liste pour stocker les paires (question, réponse)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.pages.length,
                  onPageChanged: (idx) {
                    setState(() {
                      _currentPage = idx;
                    });
                  },
                  itemBuilder: (context, idx) {
                    final item = widget.pages[idx];
                    return Stack(
                      children: [
                        Image.asset(
                          item.backgroundImage,
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                        ),
                        Column(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      item.question,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: item.textColor,
                                          ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GridView.builder(
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                      ),
                                      itemCount: item.responses!.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            _toggleResponse(item.question, item.responses![index]);
                                          },
                                          child: Card(
                                            child: SizedBox(
                                              height: 100,
                                              width: 100,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    height: 100,
                                                    width: 100,
                                                    child: Image.asset(
                                                      item.responseBackgroundImages![index],
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(item.responses![index]),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.pages
                    .map((item) => AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: _currentPage ==
                                  widget.pages.indexOf(item)
                              ? 30
                              : 8,
                          height: 8,
                          margin: const EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ))
                    .toList(),
              ),
              SizedBox(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.comfortable,
                        foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: const Text("Skip"),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.comfortable,
                        foregroundColor: Color.fromARGB(255, 10, 10, 10),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        if (_currentPage == widget.pages.length - 1) {
                          _saveSelectedResponsesToFirestore(); // Enregistrer toutes les paires (question, réponse) sélectionnées lorsque l'utilisateur clique sur "Finish"
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                          );
                        } else {
                          _pageController.animateToPage(
                            _currentPage + 1,
                            curve: Curves.easeInOutCubic,
                            duration: const Duration(milliseconds: 250),
                          );
                        }
                      },
                      child: Row(
                        children: [
                          Text(
                            _currentPage == widget.pages.length - 1
                                ? "Finish"
                                : "Next",
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            _currentPage == widget.pages.length - 1
                                ? Icons.done
                                : Icons.arrow_forward,
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
    );
  }

  void _toggleResponse(String question, String response) {
    setState(() {
      bool responseExists = selectedResponses.any((element) => element['question'] == question && element['response'] == response);
      if (responseExists) {
        selectedResponses.removeWhere((element) => element['question'] == question && element['response'] == response); // Supprimer la paire (question, réponse) si elle existe déjà
      } else {
        selectedResponses.add({'question': question, 'response': response}); // Ajouter la paire (question, réponse) si elle n'existe pas déjà
      }
    });
  }
void _saveSelectedResponsesToFirestore() {
  // Enregistrer toutes les paires (question, réponse) sélectionnées dans la collection "responses" de Firestore
 var userEmail = ConcentricAnimationOnboarding.getCachedEmail();

  FirebaseFirestore.instance.collection('allergies').add({
    'email': userEmail, // Utilisez userEmail au lieu de ConcentricAnimationOnboarding.userEmail
    'selected_responses': selectedResponses,
  }).then((value) {
    print('Selected responses saved to Firestore');
  }).catchError((error) {
    print('Failed to save selected responses: $error');
  });

  // Effacer les paires (question, réponse) sélectionnées après l'enregistrement
  selectedResponses.clear();
}
}

class OnboardingPageModel {
  final String backgroundImage;
  final Color textColor;
  final String question;
  final List<String>? responses;
  final List<String>? responseBackgroundImages;

  OnboardingPageModel({
    required this.backgroundImage,
    this.textColor = Colors.white,
    required this.question,
    this.responses,
    this.responseBackgroundImages,
  });
}
