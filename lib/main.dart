import 'dart:math';

import 'package:balloonpopping/balloon_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Balloon {
  double left;
  double top;
  double speed;

  Balloon({required this.left, required this.top, required this.speed});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Balloon Popping',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BubbleScreen(),
    );
  }
}
