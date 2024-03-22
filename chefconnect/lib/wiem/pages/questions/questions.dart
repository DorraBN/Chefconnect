import 'package:flutter/material.dart';
import 'package:concentric_transition/concentric_transition.dart';

final pages = [
  const PageData(
    bgColor: Color.fromARGB(255, 255, 255, 255),
    textColor: Colors.white,
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
  const PageData(
    bgColor: Color.fromARGB(135, 255, 219, 186),
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
  const PageData(
    bgColor:Color.fromARGB(136, 211, 253, 193),
    textColor: Color(0xff3b1790),
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
];

class ConcentricAnimationOnboarding extends StatefulWidget {
  const ConcentricAnimationOnboarding({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ConcentricAnimationOnboardingState createState() => _ConcentricAnimationOnboardingState();
}

class _ConcentricAnimationOnboardingState extends State<ConcentricAnimationOnboarding> {
  bool isCardSelected = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ConcentricPageView(
        colors: pages.map((p) => p.bgColor).toList(),
        nextButtonBuilder: (context) => Padding(
          padding: const EdgeInsets.only(left: 3), // visual center
          child: ElevatedButton(
            onPressed: isCardSelected ? () {} : null,
            child: Icon(
              Icons.navigate_next,
              size: screenWidth * 0.08,
            ),
          ),
        ),
        itemBuilder: (index) {
          final page = pages[index % pages.length];
          return SafeArea(
            child: _Page(
              page: page,
              onCardSelected: () {
                setState(() {
                  isCardSelected = true;
                });
              },
            ),
          );
        },
      ),
    );
  }
}

class PageData {
  final Color bgColor;
  final Color textColor;
  final String? question;
  final List<String>? responses;
  final List<String>? responseBackgroundImages;

  const PageData({
    required this.bgColor,
    required this.textColor,
    this.question,
    this.responses,
    this.responseBackgroundImages,
  });
}

class _Page extends StatelessWidget {
  final PageData page;
  final VoidCallback onCardSelected;

  const _Page({required this.page, required this.onCardSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (page.question != null) ...[
          const SizedBox(height: 80),
          Text(
            page.question!,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          if (page.responses != null && page.responseBackgroundImages != null)
            _buildResponseRows(context, page.responses!, page.responseBackgroundImages!),
        ],
        const Spacer(),
      ],
    );
  }

  Widget _buildResponseRows(BuildContext context, List<String> responses, List<String> backgroundImages) {
    List<Widget> rows = [];
    for (int i = 0; i < responses.length; i += 3) {
      List<String> currentResponses = responses.sublist(i, i + 3);
      List<String> currentBackgroundImages = backgroundImages.sublist(i, i + 3);
      rows.add(_buildResponseRow(context, currentResponses, currentBackgroundImages));
    }
    return Column(children: rows);
  }

  Widget _buildResponseRow(BuildContext context, List<String> responses, List<String> backgroundImages) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(responses.length, (index) {
        return GestureDetector(
          onTap: () {
            onCardSelected();
          },
          child: _ResponseCard(
            response: responses[index],
            backgroundImage: backgroundImages[index],
          ),
        );
      }),
    );
  }
}

class _ResponseCard extends StatefulWidget {
  final String response;
  final String backgroundImage;

  const _ResponseCard({required this.response, required this.backgroundImage});

  @override
  _ResponseCardState createState() => _ResponseCardState();
}

class _ResponseCardState extends State<_ResponseCard> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected; // Inverser l'état de sélection
        });
      },
      child: Card(
        color: isSelected ? const Color.fromARGB(255, 171, 174, 172) : null, // Changer la couleur si la carte est sélectionnée
        child: Container(
          width: 100,
          height: 90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? const Color.fromARGB(255, 28, 239, 24) : Colors.transparent, // Couleur de la bordure en fonction de l'état de sélection
              width: 2, // Largeur de la bordure
            ),
            image: DecorationImage(
              image: AssetImage(widget.backgroundImage),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
            ),
          ),
          child: Center(
            child: Text(
              widget.response,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
