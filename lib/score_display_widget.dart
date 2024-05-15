import 'package:flutter/material.dart';

class ScoreDisplayWidget extends StatelessWidget {
  final int score;

  ScoreDisplayWidget({required this.score});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Score: $score',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}