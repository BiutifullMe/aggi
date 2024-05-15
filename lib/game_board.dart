import 'package:flutter/material.dart';

class GameBoard extends StatefulWidget {
  @override
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  List<List<Color>> _grid;
  int _gridSize = 20;

  @override
  void initState() {
    super.initState();
    _grid = List.generate(_gridSize, (i) => List.generate(_gridSize, (j) => Colors.white));
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _gridSize,
      ),
      itemCount: _gridSize * _gridSize,
      itemBuilder: (context, index) {
        int x = index % _gridSize;
        int y = index ~/ _gridSize;
        return Container(
          color: _grid[x][y],
          child: null,
        );
      },
    );
  }
}