import 'package:cloud_firestore/cloud_firestore.dart';

Future<String> addList(String title, List<String> items) async {
  final docRef = await FirebaseFirestore.instance.collection('lists').add({
    'title': title,
    'items': items,
    'timestamp': FieldValue.serverTimestamp(),
  });
  return docRef.id;
}

Future<void> updateList(String listId, String newTitle, List<String> newItems) async {
  await FirebaseFirestore.instance.collection('lists').doc(listId).update({
    'title': newTitle,
    'items': newItems,
  });
}

Future<void> deleteList(String listId) async {
  await FirebaseFirestore.instance.collection('lists').doc(listId).delete();
}