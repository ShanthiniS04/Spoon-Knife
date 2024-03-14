import 'dart:async';
import 'package:flutter/material.dart';

class Bubble extends StatefulWidget {
  final double left;
  final Function(bool) pop; // Accepts a boolean parameter

  const Bubble({Key? key, required this.left, required this.pop}) : super(key: key);

  @override
  State<Bubble> createState() => _BubbleState();

}

class _BubbleState extends State<Bubble> {
  bool show = false;
  bool visible = true;
  double size = 1;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 90), () {
      setState(() {
        show = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  getSize() {
    timer = Timer.periodic(const Duration(milliseconds: 40), (timer) {
      if (timer.isActive) {
        if (mounted) {
          setState(() {
            size = size <= 1 ? 1.5 : 0.6;
          });
        }
      } else {
        timer.cancel();
      }
    });
  }

  bool pop() {
    setState(() {
      visible = false;
      getSize();
    });
    return visible; // Return visibility state to indicate pop
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return AnimatedPositioned(
      bottom: show ? screenHeight : -200,
      left: widget.left,
      duration: const Duration(seconds: 3), // Adjust the duration as needed.
      child: GestureDetector(
        onTap: () {
          setState(() {
            visible = false;
            getSize();
            // Notify the parent widget whether the balloon was popped or not
            widget.pop(visible); // Pass `visible` to indicate if the balloon was popped
          });
        },
        child: AnimatedOpacity(
          opacity: visible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: Transform.scale(
            scale: visible ? 1.0 : size, // Apply pop effect.
            child: Image.asset(
              'assets/images/balloon.png',
              height: 200,
              width: 200,
              color: Colors.blue,
            ),
          ),
        ),
      ),
    );
  }
}
