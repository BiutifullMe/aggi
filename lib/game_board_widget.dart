import 'package:flutter/material.dart';
import 'snake_widget.dart';
import 'food_pellet_widget.dart';

class GameBoardWidget extends StatefulWidget {
  @override
  _GameBoardWidgetState createState() => _GameBoardWidgetState();
}

class _GameBoardWidgetState extends State<GameBoardWidget> {
  List<Widget> _gameBoardWidgets = [];

  @override
  void initState() {
    super.initState();
    _generateGameBoard();
  }

  void _generateGameBoard() {
    for (int i = 0; i < 20; i++) {
      for (int j = 0; j < 20; j++) {
        _gameBoardWidgets.add(Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            border: Border.all(width: 0.5),
          ),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 20,
      childAspectRatio: 1,
      children: _gameBoardWidgets,
    );
  }
}