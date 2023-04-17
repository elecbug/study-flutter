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
  final String _empty = "", _bomb = "💥";
  final int _emptyNum = 0, _bombNum = -1;

  late int _edge = _defaultEdge, _bombs = _defaultBombs;
  late List<List<ElevatedButton>> _buttonMatrix;
  late List<List<int>> _matrix;
  late List<List<bool>> _pressed;

  late Row _mainRow;
  late Timer _endTimer = Timer(const Duration(seconds: 0), () {});

  void makeBombs(int max, int totalBombs) {
    int sum = 0;

    while (sum < totalBombs) {
      int x = Random(DateTime.now().microsecond * 7).nextInt(max),
          y = Random(DateTime.now().microsecond * 3).nextInt(max);
      if (_matrix[x][y] != _bombNum) {
        _matrix[x][y] = _bombNum;
        sum++;
      }
    }
  }

  void makeNums(int max) {
    for (int x = 0; x < _defaultEdge; x++) {
      for (int y = 0; y < _defaultEdge; y++) {
        if (_matrix[x][y] == _bombNum) continue;

        int nearBombs = 0;
        if (x > 0) {
          if (y > 0 && _matrix[x - 1][y - 1] == _bombNum) nearBombs++;
          if (y < max - 1 && _matrix[x - 1][y + 1] == _bombNum) nearBombs++;
          if (_matrix[x - 1][y] == _bombNum) nearBombs++;
        }
        if (x < max - 1) {
          if (y > 0 && _matrix[x + 1][y - 1] == _bombNum) nearBombs++;
          if (y < max - 1 && _matrix[x + 1][y + 1] == _bombNum) nearBombs++;
          if (_matrix[x + 1][y] == _bombNum) nearBombs++;
        }
        if (y > 0 && _matrix[x][y - 1] == _bombNum) nearBombs++;
        if (y < max - 1 && _matrix[x][y + 1] == _bombNum) nearBombs++;

        _matrix[x][y] = nearBombs;
      }
    }
  }

  void onPressed(int x, int y, int edge, [bool check = false]) {
    _pressed[x][y] = true;

    if (check || _endTimer != null && _endTimer.isActive) {
      return;
    } else if (checkWin()) {
      showSnackBar(context, "You Win!!!");
      _endTimer = Timer(const Duration(seconds: 5), () {
        setState(() {
          restart(_edge, _bombs);
        });
      });
    }

    if (_matrix[x][y] == 0) {
      if (x > 0 && !_pressed[x - 1][y]) {
        onPressed(x - 1, y, edge);
        if (y > 0 && !_pressed[x - 1][y - 1]) onPressed(x - 1, y - 1, edge);
        if (y < edge - 1 && !_pressed[x - 1][y + 1])
          onPressed(x - 1, y + 1, edge);
      }
      if (x < edge - 1 && !_pressed[x + 1][y]) {
        onPressed(x + 1, y, edge);
        if (y > 0 && !_pressed[x + 1][y - 1]) onPressed(x + 1, y - 1, edge);
        if (y < edge - 1 && !_pressed[x + 1][y + 1])
          onPressed(x + 1, y + 1, edge);
      }
      if (y > 0 && !_pressed[x][y - 1]) {
        onPressed(x, y - 1, edge);
      }
      if (y < edge - 1 && !_pressed[x][y + 1]) {
        onPressed(x, y + 1, edge);
      }
    } else if (_matrix[x][y] == _bombNum) {
      for (int x = 0; x < edge; x++) {
        for (int y = 0; y < edge; y++) {
          onPressed(x, y, edge, true);
        }
      }
      showSnackBar(context, "Oops, you stepped on a mine...");
      _endTimer = Timer(const Duration(seconds: 5), () {
        setState(() {
          restart(_edge, _bombs);
        });
      });
    }
  }

  void restart(int edge, int bombs) {
    _buttonMatrix = <List<ElevatedButton>>[];
    _matrix = <List<int>>[];
    _pressed = <List<bool>>[];

    for (int x = 0; x < edge; x++) {
      _buttonMatrix.add(<ElevatedButton>[]);
      _matrix.add(<int>[]);
      _pressed.add(<bool>[]);

      for (int y = 0; y < edge; y++) {
        _pressed.last.add(false);
        _matrix.last.add(_emptyNum);

        _buttonMatrix.last.add(
          ElevatedButton(
            onPressed: () {
              setState(() {
                onPressed(x, y, edge);
              });
            },
            style: OutlinedButton.styleFrom(
                minimumSize: const Size(65, 65),
                backgroundColor: _pressed[x][y]
                    ? Colors.orange.shade500
                    : Colors.green.shade900),
            child: Text(_pressed[x][y]
                ? (_matrix[x][y] == _bombNum ? _bomb : _matrix[x][y].toString())
                : _empty),
          ),
        );
      }
    }

    makeBombs(edge, bombs);
    makeNums(edge);
  }

  void showSnackBar(BuildContext context, String text) {
    SnackBar snackBar = SnackBar(
      content: Text(text),
      duration: const Duration(seconds: 5),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  bool checkWin() {
    for (int x = 0; x < _edge; x++) {
      for (int y = 0; y < _edge; y++) {
        if (!_pressed[x][y] && _matrix[x][y] != _bombNum) {
          return false;
        }
      }
    }

    return true;
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
        _matrix.last.add(_emptyNum);

        _buttonMatrix.last.add(
          ElevatedButton(
            onPressed: () {
              setState(() {
                onPressed(x, y, _defaultEdge);
              });
            },
            style: OutlinedButton.styleFrom(
                minimumSize: const Size(65, 65),
                backgroundColor: _pressed[x][y]
                    ? Colors.orange.shade500
                    : Colors.green.shade900),
            child: Text(_pressed[x][y]
                ? (_matrix[x][y] == _bombNum ? _bomb : _matrix[x][y].toString())
                : _empty),
          ),
        );
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
                    onPressed(x, y, _defaultEdge);
                  });
                },
                style: OutlinedButton.styleFrom(
                    minimumSize: const Size(65, 65),
                    backgroundColor: _pressed[x][y]
                        ? Colors.orange.shade500
                        : Colors.green.shade900),
                child: Text(_pressed[x][y]
                    ? (_matrix[x][y] == _bombNum
                        ? _bomb
                        : _matrix[x][y].toString())
                    : _empty),
              ),
            );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Flexible(
          child: _mainRow,
          flex: 1,
        ),
      ),
    );
  }
}
