import 'package:chefconnect/register.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnboardingPagePresenter(
        pages: [
          OnboardingPageModel(
            backgroundImage: const AssetImage('assets/bg1.png'),
            image: "assets/pngegg1.png",
            title: "Welcome to ChefConnect!",
            description:
                "The ultimate social media platform for food enthusiasts and culinary adventurers.",
            textColor: const Color.fromARGB(255, 0, 0, 0),
          ),
          OnboardingPageModel(
            backgroundImage: const AssetImage('assets/bg2.png'),
            title: 'Discover Recipes.',
            description:
                'Explore an extensive collection of recipes spanning various cuisines, dietary preferences, and cooking levels.',
            image: "assets/9.png",
            textColor: const Color.fromARGB(255, 0, 0, 0),
          ),
          OnboardingPageModel(
            backgroundImage: const AssetImage('assets/bg3.png'),
            title: 'Share Creations',
            description:
                'Share your culinary masterpieces with the community through photos, videos, and detailed recipe descriptions.',
            image: 'assets/share.png',
            textColor: const Color.fromARGB(255, 0, 0, 0),
          ),
          OnboardingPageModel(
            backgroundImage: const AssetImage('assets/bg4.png'),
            title: 'Connect with Others',
            description:
                'Follow your favorite cooks, engage in discussions, and exchange cooking tips and tricks with like-minded individuals.',
            image: 'assets/6.png',
            textColor: const Color.fromARGB(255, 0, 0, 0),
          ),
        ],
        onSkip: () {
          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Register()),
                          );
        },
        onFinish: () {
        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Register()),
                          );
        },
      ),
    );
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
    this.onFinish,
  }) : super(key: key);

  @override
  State<OnboardingPagePresenter> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPagePresenter> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

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
                    return Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: item.backgroundImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(25.0),
                              child: Image.asset(
                                item.image,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    item.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: item.textColor,
                                        ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0, vertical: 8.0),
                                  child: Text(
                                    item.description,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        ?.copyWith(
                                          color: item.textColor,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.pages.map((item) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: _currentPage == widget.pages.indexOf(item) ? 30 : 8,
                  height: 8,
                  margin: const EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                )).toList(),
              ),
              SizedBox(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: widget.onSkip,
                      child: const Text("Skip"),
                    ),
                    TextButton(
                      onPressed: () {
                        if (_currentPage == widget.pages.length - 1) {
                          widget.onFinish?.call();
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
}

class OnboardingPageModel {
  final String title;
  final String description;
  final String image;
  final AssetImage backgroundImage;
  final Color textColor;

  OnboardingPageModel({
    required this.title,
    required this.description,
    required this.image,
    required this.backgroundImage,
    this.textColor = const Color.fromARGB(255, 0, 0, 0),
  });
}
