import 'package:flutter/material.dart';

enum Bubble {
  user,
  gemini,
}

class PromtVarient {
  const PromtVarient({required this.msg, required this.bubble});
  final String msg;
  final Bubble bubble;
}

class PromtBubble extends StatelessWidget {
  const PromtBubble({super.key, required this.msg, required this.bubble});
  final String msg;
  final Bubble bubble;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            height: 30,
            width: bubble == Bubble.user ? 50 : 100,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: bubble == Bubble.user ? Colors.green[900] : null,
              gradient: bubble == Bubble.gemini
                  ? const LinearGradient(begin: Alignment.topLeft, colors: [
                      Colors.red,
                      Colors.yellow,
                      Colors.green,
                      Colors.blue,
                    ])
                  : null,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Text(
              bubble == Bubble.user ? "You" : "Capybara",
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            width: bubble == Bubble.gemini ? 350 : 200,
            decoration: BoxDecoration(
              color: bubble == Bubble.user ? Colors.green : Colors.blue,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(msg),
            ),
          ),
        ],
      ),
    );
  }
}
