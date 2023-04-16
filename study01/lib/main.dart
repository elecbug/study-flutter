import 'dart:io';

import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MemoApp());
}

class MemoApp extends StatelessWidget {
  const MemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(title: 'Memo'),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});

  final String title;

  @override
  State<MainPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MainPage> {
  TextEditingController textController = TextEditingController();
  TextEditingController pathController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(5),
            child: Text("File name to save"),
          ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: TextField(
              controller: pathController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter file name',
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(5),
            child: Text("Text data"),
          ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: TextFormField(
              controller: textController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                hintText: 'Enter text',
              ),
              maxLines: 20,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                onPressed: load,
                child: const Text('Load'),
              ),
              TextButton(
                onPressed: save,
                child: const Text('Save'),
              )
            ],
          ),
        ],
      ),
    );
  }

  String getPath(String path) {
    List<String> split;
    if (path.split('/').length != 1) {
      split = path.split('/');
      return split[split.length - 1].split('.')[0];
    } else if (path.split('\\').length != 1) {
      split = path.split('\\');
      return split[split.length - 1].split('.')[0];
    } else {
      return "ERROR";
    }
  }

  String getSpliter(String path) {
    if (path.split('/').length != 1) {
      return ('/');
    } else if (path.split('\\').length != 1) {
      return ('\\');
    } else {
      return ".";
    }
  }

  void showSnackBar(BuildContext context, String text) {
    SnackBar snackBar = SnackBar(
      content: Text(text),
      duration: const Duration(seconds: 4),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> load() async {
    String? filePath = await FilesystemPicker.open(
      title: 'Open file',
      context: context,
      rootDirectory: Directory.current,
      allowedExtensions: ['.txt'],
      fileTileSelectMode: FileTileSelectMode.wholeTile,
    );

    if (filePath != null) {
      pathController.text = getPath(filePath);
      textController.text = await File(filePath).readAsString();
    }
  }

  Future<void> save() async {
    if (pathController.text == "") {
      showSnackBar(context, "Please input file name first!");
      return;
    }

    String? folderPath = await FilesystemPicker.open(
      title: 'Save file',
      context: context,
      contextActions: [
        FilesystemPickerNewFolderContextAction(),
      ],
      rootDirectory: Directory.current,
      fsType: FilesystemType.folder,
      fileTileSelectMode: FileTileSelectMode.wholeTile,
    );

    if (folderPath != null) {
      await File(
              "$folderPath${getSpliter(folderPath)}${pathController.text}.txt")
          .writeAsString(textController.text);
    }
  }
}
