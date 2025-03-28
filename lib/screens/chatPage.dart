import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../models/item.dart';

class ChatPage extends StatefulWidget {
  ChatPage({required this.name, required this.room,  super.key});

  String name;
  String room;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Item> items = [];
  late FirebaseFirestore firestore;
  late CollectionReference<Map<String, dynamic>> collection;
  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState(){
    super.initState();
    firestore = FirebaseFirestore.instance;
    collection = firestore.collection('rooms').doc(widget.room).collection('items');
    watch();
  }

  Future<void> watch() async{
    collection.snapshots().listen((event){
      setState(() {
        if (mounted) {
          items = event.docs.reversed.map((document) =>
              Item.fromSnapshot(
                document.id,
                document.data(),
              ),).toList(growable: false);
        }
      });
    });
  }

  Future<void> save() async {
    final now = DateTime.now();
    await collection.doc(now.millisecondsSinceEpoch.toString()).set({
      'date':Timestamp.fromDate(now),
      'name': widget.name,
      'text': textEditingController.text,
    });
    textEditingController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.room)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemBuilder: (context, index) {
                final item = items[index];
                final isMe = item.name == widget.name;
                return Padding(padding:isMe
                    ? EdgeInsets.only(left:80, right: 16, top:16)
                    : EdgeInsets.only(left:16, right: 80, top:16),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)
                    ),
                    tileColor: isMe ? Colors.tealAccent : Colors.black26,
                    subtitle: Text('${item.name} ${item.date.toString().replaceAll('-', '/').substring(5, 16)}'),
                    title: Text(item.text),
                  ),
                );
              },
              itemCount: items.length,
            ),
          ),
          SafeArea(
            child: ListTile(
              title: TextField(controller: textEditingController),
              trailing: ElevatedButton(
                onPressed: () {
                  save();
                },
                child: Text('送信'),
              ),
            ),
          ),
        ],
      ),
    );
  }

}