import 'package:flutter/material.dart';

class BombButton {
  static int bombNum = -1;
  static String empty = "", bomb = "💥";

  late ElevatedButton _button;
  late int _num;
  late bool _isPressed;
  late Function() _onPressed;

  BombButton(Function() onPressed) {
    _num = 0;
    _isPressed = false;
    _onPressed = onPressed;
    _setButton();
  }

  ElevatedButton getButton() => _button;

  void setToBomb() {
    _num = bombNum;
  }

  bool isPressed() => _isPressed;

  bool isBomb() => _num == bombNum;

  void onPressed() {
    _isPressed = true;
    _setButton();
  }

  void setNearBombs(int num) {
    _num = num;
  }

  int getNearBombs() => _num;

  void _setButton() {
    _button = ElevatedButton(
      onPressed: _onPressed,
      style: OutlinedButton.styleFrom(
          minimumSize: const Size(65, 65),
          backgroundColor:
              _isPressed ? Colors.orange.shade500 : Colors.green.shade900),
      child: Text(_isPressed ? (isBomb() ? bomb : _num.toString()) : empty),
    );
  }
}
