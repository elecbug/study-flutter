import 'package:flutter/material.dart';
import 'package:study02/main_page.dart';

void main() {
  runApp(const AApp());
}

class AApp extends StatelessWidget {
  const AApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minesweeper',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(title: 'Minesweeper'),
    );
  }
}
