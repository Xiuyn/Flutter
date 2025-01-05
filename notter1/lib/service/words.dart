import 'package:cloud_firestore/cloud_firestore.dart';

Future<String> addWordList(String title, List<Map<String, String>> words) async {
  final docRef = await FirebaseFirestore.instance.collection('wordLists').add({
    'title': title,
    'words': words,
    'timestamp': FieldValue.serverTimestamp(),
  });
  return docRef.id;
}

Future<void> updateWordList(String listId, String newTitle, List<Map<String, String>> newWords) async {
  await FirebaseFirestore.instance.collection('wordLists').doc(listId).update({
    'title': newTitle,
    'words': newWords,
  });
}

Future<void> deleteWordList(String listId) async {
  await FirebaseFirestore.instance.collection('wordLists').doc(listId).delete();
}