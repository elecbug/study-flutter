import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatting',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ChatPage(title: 'Chatting'),
    );
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.title});
  final String title;

  @override
  State<ChatPage> createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  ServerSocket? server;
  Socket? client;
  StreamSubscription? stream;
  TextEditingController controller = TextEditingController();
  String msg = "";

  Future<void> setServer() async {
    server = await ServerSocket.bind('127.0.0.1', 12356).then((value) {
      stream = value.listen(
        (event) {
          controller.text = event.toString();
        },
        onDone: () {},
        onError: () {},
        cancelOnError: true,
      );
    });
  }

  Future<void> setClient() async {
    client = await Socket.connect('127.0.0.1', 12356);
    client?.write('Hello, World!');
  }

  Future<void> send() async {
    if (server == null) {
      client?.write(controller.text);
    }
  }

  @override
  void initState() {
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
          children: <Widget>[
            TextField(
              controller: controller,
            ),
            TextButton(
              onPressed: () {
                send();
              },
              child: const Text("Send/Check"),
            ),
            TextButton(
              onPressed: () {
                setServer();
              },
              child: const Text("Server"),
            ),
            TextButton(
              onPressed: () {
                setClient();
              },
              child: const Text("Client"),
            ),
          ],
        ),
      ),
    );
  }
}
