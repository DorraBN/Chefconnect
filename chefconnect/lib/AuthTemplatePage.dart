import 'package:flutter/material.dart';

class AuthTemplatePage extends StatelessWidget {
  final String pageTitle;
  final Widget content;
  final Widget floatingBtn;

  const AuthTemplatePage({
    Key? key,
    required this.pageTitle,
    required this.content,
    required this.floatingBtn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: floatingBtn,
      body: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.blue.shade500, Colors.green.shade700],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  child: Expanded(child: Container()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 70),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: Colors.white, width: 5),
                          ),
                          child: const Icon(
                            Icons.done,
                            size: 100,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          pageTitle,
                          style: const TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 30),
                        content,
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
