import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:study02/bomb_button.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});
  final String title;

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  final int _defaultEdge = 10, _defaultBombs = 10;

  late int _edge = _defaultEdge, _bombs = _defaultBombs;
  late List<List<BombButton>> btn;

  late Row _mainRow;
  late Timer _endTimer;

  void makeBombs(int max, int totalBombs) {
    int sum = 0;

    while (sum < totalBombs) {
      int x = Random(DateTime.now().microsecond * 7).nextInt(max),
          y = Random(DateTime.now().microsecond * 3).nextInt(max);
      if (!btn[x][y].isBomb()) {
        btn[x][y].setToBomb();
        sum++;
      }
    }
  }

  void makeNums(int edge) {
    for (int x = 0; x < edge; x++) {
      for (int y = 0; y < edge; y++) {
        if (btn[x][y].isBomb()) continue;

        int nearBombs = 0;
        if (x > 0) {
          if (y > 0 && btn[x - 1][y - 1].isBomb()) nearBombs++;
          if (y < edge - 1 && btn[x - 1][y + 1].isBomb()) nearBombs++;
          if (btn[x - 1][y].isBomb()) nearBombs++;
        }
        if (x < edge - 1) {
          if (y > 0 && btn[x + 1][y - 1].isBomb()) nearBombs++;
          if (y < edge - 1 && btn[x + 1][y + 1].isBomb()) nearBombs++;
          if (btn[x + 1][y].isBomb()) nearBombs++;
        }
        if (y > 0 && btn[x][y - 1].isBomb()) nearBombs++;
        if (y < edge - 1 && btn[x][y + 1].isBomb()) nearBombs++;

        btn[x][y].setNearBombs(nearBombs);
      }
    }
  }

  void onPressed(int x, int y, int edge, [bool check = false]) {
    btn[x][y].onPressed();

    if (check || _endTimer.isActive) {
      return;
    } else if (checkWin()) {
      showSnackBar(context, "You Win!!!");
      _endTimer = Timer(const Duration(seconds: 5), () {
        setState(() {
          restart(_edge, _bombs);
        });
      });
    }

    if (btn[x][y].getNearBombs() == 0) {
      print("$x, $y clicked\r\n");
      if (x > 0) {
        if (!btn[x - 1][y].isPressed()) onPressed(x - 1, y, edge);
        if (y > 0 && !btn[x - 1][y - 1].isPressed())
          onPressed(x - 1, y - 1, edge);
        if (y < edge - 1 && !btn[x - 1][y + 1].isPressed())
          onPressed(x - 1, y + 1, edge);
      }
      if (x < edge - 1) {
        if (!btn[x + 1][y].isPressed()) onPressed(x + 1, y, edge);
        if (y > 0 && !btn[x + 1][y - 1].isPressed())
          onPressed(x + 1, y - 1, edge);
        if (y < edge - 1 && !btn[x + 1][y + 1].isPressed())
          onPressed(x + 1, y + 1, edge);
      }
      if (y > 0 && !btn[x][y - 1].isPressed()) {
        onPressed(x, y - 1, edge);
      }
      if (y < edge - 1 && !btn[x][y + 1].isPressed()) {
        onPressed(x, y + 1, edge);
      }
    } else if (btn[x][y].isBomb()) {
      for (int x = 0; x < edge; x++) {
        for (int y = 0; y < edge; y++) {
          onPressed(x, y, edge, true);
        }
      }

      showSnackBar(context, "Oops, you stepped on a mine...");
      _endTimer = Timer(
        const Duration(seconds: 5),
        () {
          setState(
            () {
              restart(_edge, _bombs);
            },
          );
        },
      );
    }
  }

  void restart(int edge, int bombs) {
    btn = <List<BombButton>>[];

    for (int x = 0; x < edge; x++) {
      btn.add(<BombButton>[]);

      for (int y = 0; y < edge; y++) {
        btn.last.add(
          BombButton(
            () {
              setState(
                () {
                  onPressed(x, y, edge);
                },
              );
            },
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
        if (!btn[x][y].isPressed() && !btn[x][y].isBomb()) {
          return false;
        }
      }
    }

    return true;
  }

  MainPageState() {
    _endTimer = Timer(const Duration(milliseconds: 1), () {});

    btn = <List<BombButton>>[];

    for (int x = 0; x < _defaultEdge; x++) {
      btn.add(<BombButton>[]);

      for (int y = 0; y < _defaultEdge; y++) {
        btn.last.add(
          BombButton(
            () {
              setState(
                () {
                  onPressed(x, y, _defaultEdge);
                },
              );
            },
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

    for (int x = 0; x < btn.length; x++) {
      _mainRow.children.add(
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[],
        ),
      );

      for (int y = 0; y < btn[x].length; y++) {
        (_mainRow.children.last as Column).children.add(btn[x][y].getButton());
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
