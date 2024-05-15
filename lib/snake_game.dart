import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'snake.dart';
import 'food.dart';
import 'game_controller.dart';

abstract class SnakeGame with StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Snake Game'),
      ),
      body: SnakeGameUI(),
    );
}