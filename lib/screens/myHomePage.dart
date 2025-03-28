import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'chatPage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String name = '';
  String room = '';

  void showError(String message) {
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            content: Text(message),
          );
        });
  }

  void enter() {
    if (name.isEmpty){
      showError('あなたの名前を入力してください');
      return;
    }
    if (room.isEmpty){
      showError('部屋を入力してください');
      return;
    }
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) {
              return ChatPage(name: name, room: room);
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('チャット')),
      body: ListView(
        children: [
          ListTile(
            title: TextField(
              decoration: InputDecoration(hintText: 'あなたの名前'),
              onChanged: (value) {
                name = value;
              },
            ),
          ),
          ListTile(
            title: TextField(
              decoration: InputDecoration(hintText: '部屋名'),
              onChanged: (value) {
                room = value;
              },
            ),
          ),
          ListTile(
            title: ElevatedButton(
              onPressed: () {
                enter();
              },
              child: Text('入室する'),
            ),
          ),
        ],
      ),
    );
  }
}

