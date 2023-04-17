import 'dart:math';

import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});
  final String title;

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  final int _defaultEdge = 10, _defaultBombs = 10;
  final String _null = "", _bomb = "💥";
  final int _empty = 0, _danger = -1;

  late List<List<ElevatedButton>> _buttonMatrix;
  late List<List<int>> _matrix;
  late List<List<bool>> _pressed;

  late Row _mainRow;

  void makeBombs(int max, int totalBombs) {
    int sum = 0;

    while (sum < totalBombs) {
      int x = Random(DateTime.now().microsecond * 7).nextInt(max),
          y = Random(DateTime.now().microsecond * 3).nextInt(max);
      if (_matrix[x][y] != _danger) {
        _matrix[x][y] = _danger;
        sum++;
      }
    }
  }

  void makeNums(int max) {
    for (int x = 0; x < _defaultEdge; x++) {
      for (int y = 0; y < _defaultEdge; y++) {
        if (_matrix[x][y] == _danger) continue;

        int nearBombs = 0;
        if (x > 0) {
          if (y > 0 && _matrix[x - 1][y - 1] == _danger) nearBombs++;
          if (y < max - 1 && _matrix[x - 1][y + 1] == _danger) nearBombs++;
          if (_matrix[x - 1][y] == _danger) nearBombs++;
        }
        if (x < max - 1) {
          if (y > 0 && _matrix[x + 1][y - 1] == _danger) nearBombs++;
          if (y < max - 1 && _matrix[x + 1][y + 1] == _danger) nearBombs++;
          if (_matrix[x + 1][y] == _danger) nearBombs++;
        }
        if (y > 0 && _matrix[x][y - 1] == _danger) nearBombs++;
        if (y < max - 1 && _matrix[x][y + 1] == _danger) nearBombs++;

        _matrix[x][y] = nearBombs;
      }
    }
  }

  MainPageState() {
    _buttonMatrix = <List<ElevatedButton>>[];
    _matrix = <List<int>>[];
    _pressed = <List<bool>>[];

    for (int x = 0; x < _defaultEdge; x++) {
      _buttonMatrix.add(<ElevatedButton>[]);
      _matrix.add(<int>[]);
      _pressed.add(<bool>[]);

      for (int y = 0; y < _defaultEdge; y++) {
        _pressed.last.add(false);
        _matrix.last.add(_empty);
      }
    }

    makeBombs(_defaultEdge, _defaultBombs);
    makeNums(_defaultEdge);
  }

  @override
  Widget build(BuildContext context) {
    _mainRow =
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[]);

    for (int x = 0; x < _buttonMatrix.length; x++) {
      _mainRow.children.add(
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[],
        ),
      );

      for (int y = 0; y < _buttonMatrix[x].length; y++) {
        (_mainRow.children.last as Column).children.add(
              _buttonMatrix[x][y] = ElevatedButton(
                onPressed: () {
                  setState(() {
                    _pressed[x][y] = true;
                  });
                },
                style: OutlinedButton.styleFrom(
                    backgroundColor: _pressed[x][y]
                        ? Colors.orange.shade500
                        : Colors.green.shade900),
                child: Text(_pressed[x][y]
                    ? (_matrix[x][y] == _danger
                        ? _bomb
                        : _matrix[x][y].toString())
                    : _null),
              ),
            );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: _mainRow,
      ),
    );
  }
}
