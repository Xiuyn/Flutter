import 'package:flutter/material.dart';
import 'package:notter1/service/note.dart';
import 'page_details/note_detail_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final List<DocumentSnapshot> _notes = [];

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  Future<void> _fetchNotes() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('notes').get();
    setState(() {
      _notes.clear();
      _notes.addAll(snapshot.docs);
    });
  }

  Future<void> _addNote() async {
    final newNoteId = await addNote(
      'Yeni Not',
      'Not içeriği',
    );
    // _fetchNotes();
    final newDocSnapshot = await FirebaseFirestore.instance.collection('notes').doc(newNoteId).get();
    setState(() {
      _notes.insert(0, newDocSnapshot);
    });
  }

  Future<void> _updateNote(String noteId, String newTitle, String newContent) async {
    await updateNote(
      noteId,
      newTitle,
      newContent,
    );
    await _fetchNotes();
  }

  Future<void> _deleteNote(String noteId) async {
    await deleteNote(noteId);
    _fetchNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notlarım'),
      ),
      body: ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          final note = _notes[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              title: Text(note['title']),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NoteDetailPage(
                      title: note['title'],
                      content: note['content'] ?? '',
                      onTitleChanged: (newTitle) {
                        _updateNote(note.id, newTitle, note['content']);
                      },
                      onContentChanged: (newContent) {
                        _updateNote(note.id, note['title'], newContent);
                      },
                    ),
                  ),
                );
              },
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          String newTitle = note['title'];
                          return AlertDialog(
                            title: Text('Not Başlığını Düzenle'),
                            content: TextField(
                              controller: TextEditingController(text: newTitle),
                              onChanged: (value) {
                                newTitle = value;
                              },
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('İptal'),
                              ),
                              TextButton(
                                onPressed: () {
                                  _updateNote(note.id, newTitle, note['content']);
                                  Navigator.of(context).pop();
                                },
                                child: Text('Kaydet'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _deleteNote(note.id);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        child: Icon(Icons.add),
      ),
    );
  }
}