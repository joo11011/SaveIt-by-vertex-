import 'package:flutter/material.dart';

class StaticBackground extends StatelessWidget {
  const StaticBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final double appBarHeight = kToolbarHeight;

    return Container(
      height: MediaQuery.of(context).size.height - appBarHeight,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFa8e6a1), 
            Color(0xFFffffff),
            Color(0xFFbfbaba), 
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
    );
  }
}
