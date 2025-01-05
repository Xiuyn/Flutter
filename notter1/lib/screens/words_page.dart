import 'package:flutter/material.dart';
import 'package:notter1/service/words.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notter1/screens/page_details/word_group_page.dart';

class WordsPage extends StatefulWidget {
  @override
  _WordsPageState createState() => _WordsPageState();
}

class _WordsPageState extends State<WordsPage> {
  final List<DocumentSnapshot> _wordLists = [];

  @override
  void initState() {
    super.initState();
    _fetchWordLists();
  }

  Future<void> _fetchWordLists() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('wordLists').get();
    setState(() {
      _wordLists.clear();
      _wordLists.addAll(snapshot.docs);
    });
  }

  Future<void> _addWordList() async {
    final newListId = await addWordList(
      'Yeni Kelime Listesi',
      [{'kelime': 'örnek', 'anlam': 'örnek anlam'}],
    );
    final newDocSnapshot = await FirebaseFirestore.instance.collection('wordLists').doc(newListId).get();
    setState(() {
      _wordLists.insert(0, newDocSnapshot);
    });
  }

  Future<void> _updateWordList(String listId, String newTitle, List<Map<String, String>> newWords) async {
    await updateWordList(
      listId,
      newTitle,
      newWords,
    );
    await _fetchWordLists();
  }

  Future<void> _deleteWordList(String listId) async {
    await deleteWordList(listId);
    _fetchWordLists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kelime Listelerim'),
      ),
      body: ListView.builder(
        itemCount: _wordLists.length,
        itemBuilder: (context, index) {
          final wordList = _wordLists[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              title: Text(wordList['title']),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WordGroupPage(
                      listId: wordList.id,
                      title: wordList['title'],
                      words: (wordList['words'] as List<dynamic>).map((word) {
                        return {
                          'kelime': word['kelime'] as String,
                          'anlam': word['anlam'] as String,
                        };
                      }).toList(),
                      onUpdate: (newTitle, newWords) {
                        _updateWordList(wordList.id, newTitle, newWords);
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
                          String newTitle = wordList['title'];
                          return AlertDialog(
                            title: Text('Listeyi Düzenle'),
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
                                  List<Map<String, String>> newWords = (wordList['words'] as List<dynamic>).map((word) {
                                    return {
                                      'kelime': word['kelime'] as String,
                                      'anlam': word['anlam'] as String,
                                    };
                                  }).toList();
                                  _updateWordList(wordList.id, newTitle, newWords);
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
                      _deleteWordList(wordList.id);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addWordList,
        child: Icon(Icons.add),
      ),
    );
  }
}