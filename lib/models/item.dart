import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  const Item({
    required this.id,
    required this.name,
    required this.text,
    required this.date,
  });
  final String id;
  final String name;
  final String text;
  final DateTime date;

  factory Item.fromSnapshot(String id, Map<String, dynamic> document) {
    return Item(
      id: id,
      name: document['name'].toString() ?? '',
      text: document['text'].toString() ?? '',
      date: (document['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}

