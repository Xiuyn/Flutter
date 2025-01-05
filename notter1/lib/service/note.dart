import 'package:cloud_firestore/cloud_firestore.dart';

Future<String> addNote(String title, String content) async {
  final docref = await FirebaseFirestore.instance.collection('notes').add({
    'title': title,
    'content': content,
    'timestamp': FieldValue.serverTimestamp(),
  });
  return docref.id;
}

Future<void> updateNote(String noteId, String newTitle, String newContent) async {
  await FirebaseFirestore.instance.collection('notes').doc(noteId).update({
    'title': newTitle,
    'content': newContent,
  });
}

Future<void> deleteNote(String noteId) async {
  await FirebaseFirestore.instance.collection('notes').doc(noteId).delete();
}
