import 'package:flutter/material.dart';
import 'package:concentric_transition/concentric_transition.dart';

final pages = <PageData>[
  const PageData(
    icon: Icons.lock,
    title: "Forgot password?",
    text: "Don't worry! it happens. Please enter your email or phone",
    bgColor: Color.fromARGB(255, 23, 144, 47),
    textColor: Colors.white,
  ),
  const PageData(
    icon: Icons.phone,
    title: "Enter the code",
    bgColor: Color(0xfffab800),
    textColor: Color.fromARGB(255, 23, 144, 47),
    text: "Enter the code received",
  ),
  const PageData(
    icon: Icons.check,
    title: "Reset Password",
    bgColor: Color(0xffffffff),
    textColor: Color.fromARGB(255, 23, 144, 47),
    text: "Tap a new password",
  ),
];

class RememberPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ConcentricPageView(
        colors: pages.map((p) => p.bgColor).toList(),
        radius: screenWidth * 0.1,
        nextButtonBuilder: (context) => Padding(
          padding: const EdgeInsets.only(left: 3),
          child: Icon(
            Icons.navigate_next,
            size: screenWidth * 0.08,
          ),
        ),
        itemBuilder: (index) {
          final page = pages[index % pages.length];
          return SafeArea(
            child: _Page(page: page, pageIndex: index),
          );
        },
      ),
    );
  }
}

class PageData {
  final String? title;
  final IconData? icon;
  final Color bgColor;
  final Color textColor;
  final String? text;

  const PageData({
    this.title,
    this.icon,
    this.bgColor = Colors.white,
    this.textColor = Colors.black,
    this.text,
  });
}

class _Page extends StatelessWidget {
  final PageData page;
  final int pageIndex;

  const _Page({Key? key, required this.page, required this.pageIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: page.textColor,
          ),
          child: Icon(
            page.icon,
            size: screenHeight * 0.1,
            color: page.bgColor,
          ),
        ),
        Text(
          page.title ?? "",
          style: TextStyle(
            color: page.textColor,
            fontSize: screenHeight * 0.035,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        if (page.text != null) _buildTextField(page, screenWidth, context),
      ],
    );
  }

  Widget _buildTextField(
      PageData page, double screenWidth, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          SizedBox(height: 30.0),
          Text(
            page.text!,
            style: TextStyle(
              color: page.textColor,
              fontSize: 14.0,
            ),
            textAlign: TextAlign.center,
          ),
          if (page.title == "Forgot password?")
            Column(
              children: [
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email or Phone',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    hintText: 'Enter your email or phone',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.13),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ],
            ),
          if (page.title == "Enter the code")
            Column(
              children: [
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(4, (index) => _buildCodeSquare()),
                ),
                SizedBox(height: 15.0),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .popUntil((route) => route.settings.name == '/');
                  },
                  child: Text(
                    "No code received?",
                    style: TextStyle(
                      color: page.textColor,
                      fontSize: 14.0,
                      decoration: TextDecoration.underline,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          if (page.title == "Reset Password")
            Column(
              children: [
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    hintText: 'Enter your new password',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.13),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 15.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    hintText: 'Confirm your new password',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.13),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 20.0),
                if (pageIndex == 2) // Vérifiez si c'est la troisième page
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: Icon(
                      Icons.navigate_next,
                      size: screenWidth * 0.08,
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildCodeSquare() {
    return Container(
      width: 30,
      height: 30,
      margin: EdgeInsets.all(3),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(3),
      ),
      alignment: Alignment.center,
      child: TextField(
        textAlign: TextAlign.center,
        maxLength: 1,
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: 16),
        decoration: InputDecoration(
          counterText: '',
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: RememberPage(),
  ));
}
