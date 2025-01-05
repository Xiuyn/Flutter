import 'package:flutter/material.dart';

class NoteDetailPage extends StatefulWidget {
  final String title;
  final String content;
  final ValueChanged<String> onTitleChanged;
  final ValueChanged<String> onContentChanged;

  NoteDetailPage({
    required this.title,
    required this.content,
    required this.onTitleChanged,
    required this.onContentChanged
    });

  @override
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {

  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _contentController = TextEditingController(text: widget.content);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Not Detayı'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Başlık'),
              onChanged: (value) {
                // Başlık değiştikçe parent sayfaya haber veriyoruz
                widget.onTitleChanged(value);
              },
            ),
            SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: InputDecoration(labelText: 'İçerik'),
                maxLines: null,
                expands: true,
                onChanged: (value) {
                  // İçerik değiştikçe parent sayfaya haber veriyoruz
                  widget.onContentChanged(value);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          // Kullanıcı kaydet butonuna bastığında da
          widget.onTitleChanged(_titleController.text);
          widget.onContentChanged(_contentController.text);
          Navigator.of(context).pop();
        },
      ),
    );
  }
}