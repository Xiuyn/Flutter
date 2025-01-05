import 'package:flutter/material.dart';
import 'package:notter1/service/list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notter1/screens/page_details/list_detail_page.dart';

class ListsPage extends StatefulWidget {
  @override
  _ListsPageState createState() => _ListsPageState();
}

class _ListsPageState extends State<ListsPage> {
  final List<DocumentSnapshot> _lists = [];

  @override
  void initState() {
    super.initState();
    _fetchLists();
  }

  Future<void> _fetchLists() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('lists').get();
    setState(() {
      _lists.clear();
      _lists.addAll(snapshot.docs);
    });
  }

  Future<void> _addList() async {
    final newListId = await addList(
      'Yeni Liste',
      ['Öğe 1', 'Öğe 2'],
    );
    final newDocSnapshot = await FirebaseFirestore.instance.collection('lists').doc(newListId).get();
    setState(() {
      _lists.insert(0, newDocSnapshot);
    });
  }

  Future<void> _updateList(String listId, String newTitle, List<String> newItems) async {
    await updateList(
      listId,
      newTitle,
      newItems,
    );
    await _fetchLists();
  }

  Future<void> _deleteList(String listId) async {
    await deleteList(listId);
    _fetchLists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listelerim'),
      ),
      body: ListView.builder(
        itemCount: _lists.length,
        itemBuilder: (context, index) {
          final list = _lists[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              title: Text(list['title']),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListDetailPage(
                      listId: list.id,
                      title: list['title'],
                      items: List<String>.from(list['items']),
                      onUpdate: (newTitle, newItems) {
                        _updateList(list.id, newTitle, newItems);
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
                          String newTitle = list['title'];
                          List<String> newItems = List<String>.from(list['items']);
                          return AlertDialog(
                            title: Text('Listeyi Düzenle'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: TextEditingController(text: newTitle),
                                  onChanged: (value) {
                                    newTitle = value;
                                  },
                                  decoration: InputDecoration(labelText: 'Başlık'),
                                ),
                                TextField(
                                  controller: TextEditingController(text: newItems.join(', ')),
                                  onChanged: (value) {
                                    newItems = value.split(',').map((item) => item.trim()).toList();
                                  },
                                  decoration: InputDecoration(labelText: 'Öğeler (virgülle ayırın)'),
                                ),
                              ],
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
                                  _updateList(list.id, newTitle, newItems);
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
                      _deleteList(list.id);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addList,
        child: Icon(Icons.add),
      ),
    );
  }
}