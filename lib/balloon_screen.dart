import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

import 'balloon.dart'; // Assuming this imports your Bubble widget

class BubbleScreen extends StatefulWidget {
  const BubbleScreen({Key? key}) : super(key: key);

  @override
  State<BubbleScreen> createState() => _BubbleScreenState();
}

class _BubbleScreenState extends State<BubbleScreen>
    with WidgetsBindingObserver {
  late Timer timer;
  List<Bubble> bubbles = [];
  Random random = Random();
  int score = 0;
  late Size size;
  bool start = false;
  int remainingSeconds = 120; // Initial remaining time in seconds

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    startGame();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      if (timer.isActive) {
        timer.cancel();
      }
    } else if (state == AppLifecycleState.resumed) {
      restartGame();
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (timer.isActive) {
      timer.cancel();
    }
  }

  void startGame() {
    // Set the timer for 2 minutes (120 seconds)
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        remainingSeconds--;
        if (remainingSeconds == 0) {
          endGame();
        }
      });
    });

    // Generate bubbles every 900 milliseconds (0.9 seconds)
    Timer.periodic(const Duration(milliseconds: 900), (timer) {
      if (timer.isActive) {
        generateBubble();
      } else {
        timer.cancel();
      }
    });
  }

  void generateBubble() {
    double left = random.nextDouble() * (size.width - 110);
    setState(() {
      bubbles.add(Bubble(
        left: left,
        pop: pop,
      ));
    });
  }

  void pop(bool bubblePop) {
    score += 2; // Award 2 points
    setState(() {});
  }

  void endGame() {
    setState(() {
      start = true;
      bubbles.clear();
      timer.cancel(); // Ensure timer is canceled
    });
  }

  void restartGame() {
    bubbles.clear();
    score = 0;
    start = false;
    remainingSeconds = 120; // Reset remaining time
    startGame();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Display timer in top left corner
            Positioned(
              top: 20.0,
              left: 20.0,
              child: Text(
                'Time: ${remainingSeconds.toString().padLeft(2, '0')}s', // Format time with leading zeros
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                ),
              ),
            ),
            !start
                ? Stack(children: [
              for (int i = 0; i < bubbles.length; i++) bubbles[i],
            ])
                : Center(
              child: Transform.scale(
                scale: 1.5,
                child: Text(
                  'You Scored \n $score',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              if (start) {
                restartGame();
              }
            },
            child: Text(start ? 'Restart' : 'Your Score: $score'),
          ),
        ),
      ),
    );
  }
}
