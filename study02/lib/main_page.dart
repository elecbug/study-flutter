import 'dart:async';
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
  late List<List<TextButton>> _buttonMatrix;
  late List<List<int>> _matrix;

  void onButtonPressed(int x, int y) {}

  void makeBombs(int max, int totalBombs) {
    int sum = 0;

    while (sum < totalBombs) {
      int x = Random(DateTime(1970).microsecond * 7).nextInt(max),
          y = Random(DateTime(1970).microsecond * 3).nextInt(max);
      if (_matrix[x][y] != _danger) {
        _matrix[x][y] = _danger;
        sum++;
      }
    }
  }

  void makeNums(int max) {/*todo*/}

  @override
  void initState() {
    _buttonMatrix = <List<TextButton>>[];

    for (int x = 0; x < _defaultEdge; x++) {
      _buttonMatrix.add(<TextButton>[]);
      _matrix.add(<int>[]);

      for (int y = 0; y < _defaultEdge; y++) {
        _buttonMatrix.last.add(TextButton(
            onPressed: () {
              onButtonPressed(x, y);
            },
            child: Text(_null)));
        _matrix.last.add(_empty);
      }
    }

    makeBombs(_defaultEdge, _defaultBombs);
    makeNums(_defaultEdge);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[],
        ),
      ),
    );
  }
}
