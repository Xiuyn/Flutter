import 'package:flutter/material.dart';

class ListDetailPage extends StatefulWidget {
  final String listId;
  final String title;
  final List<String> items;
  final Function(String, List<String>) onUpdate;

  ListDetailPage({
    required this.listId,
    required this.title,
    required this.items,
    required this.onUpdate,
  });

  @override
  _ListDetailPageState createState() => _ListDetailPageState();
}

class _ListDetailPageState extends State<ListDetailPage> {
  late TextEditingController _titleController;
  late List<Map<String, Object>> _items;
  late TextEditingController _newItemController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _newItemController = TextEditingController();
    _items = widget.items.map((item) => {'text': item, 'completed': false}).toList();
  }

  void _addItem(String text) {
    setState(() {
      _items.add({'text': text, 'completed': false});
    });
  }

  void _toggleItemCompletion(int index) {
    setState(() {
      _items[index]['completed'] = !(_items[index]['completed'] as bool);
    });
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste Detayı'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              widget.onUpdate(
                _titleController.text,
                _items.map((item) => item['text'] as String).toList(),
              );
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Başlık'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return ListTile(
                    leading: Checkbox(
                      value: item['completed'] as bool,
                      onChanged: (value) {
                        _toggleItemCompletion(index);
                      },
                    ),
                    title: TextField(
                      controller: TextEditingController(text: item['text'] as String),
                      decoration: InputDecoration(border: InputBorder.none),
                      onChanged: (value) {
                        setState(() {
                          item['text'] = value;
                        });
                      },
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _removeItem(index);
                      },
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newItemController,
                    decoration: InputDecoration(labelText: 'Yeni Öğe Ekle'),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        _addItem(_newItemController.text);
                        _newItemController.clear();
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    _addItem(_newItemController.text);
                    _newItemController.clear();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}