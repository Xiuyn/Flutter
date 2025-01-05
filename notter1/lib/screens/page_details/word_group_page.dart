import 'package:flutter/material.dart';
import 'quiz_page.dart';

class WordGroupPage extends StatefulWidget {
  final String listId;
  final String title;
  final List<Map<String, String>> words;
  final Function(String, List<Map<String, String>>) onUpdate;

  WordGroupPage({
    required this.listId,
    required this.title,
    required this.words,
    required this.onUpdate,
  });

  @override
  _WordGroupPageState createState() => _WordGroupPageState();
}

class _WordGroupPageState extends State<WordGroupPage> {
  late TextEditingController _titleController;
  late List<Map<String, String>> _words;
  late TextEditingController _newWordController;
  late TextEditingController _newMeaningController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _newWordController = TextEditingController();
    _newMeaningController = TextEditingController();
    _words = List<Map<String, String>>.from(widget.words);
  }

  void _addWord() {
    setState(() {
      _words.add({'kelime': _newWordController.text, 'anlam': _newMeaningController.text});
      _newWordController.clear();
      _newMeaningController.clear();
    });
  }

  void _removeWord(int index) {
    setState(() {
      _words.removeAt(index);
    });
  }

  void _startQuiz() {
    if (_words.length >= 5) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuizPage(words: _words),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sınav başlatmak için en az 5 kelime ekleyin.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kelime Listesi Detayı'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              widget.onUpdate(
                _titleController.text,
                _words,
              );
              Navigator.of(context).pop();
            },
          ),
          IconButton(
            icon: Icon(Icons.quiz),
            onPressed: _startQuiz,
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
                itemCount: _words.length,
                itemBuilder: (context, index) {
                  final word = _words[index];
                  return ListTile(
                    title: TextField(
                      controller: TextEditingController(text: word['kelime']),
                      decoration: InputDecoration(labelText: 'Kelime'),
                      onChanged: (value) {
                        setState(() {
                          word['kelime'] = value;
                        });
                      },
                    ),
                    subtitle: TextField(
                      controller: TextEditingController(text: word['anlam']),
                      decoration: InputDecoration(labelText: 'Anlam'),
                      onChanged: (value) {
                        setState(() {
                          word['anlam'] = value;
                        });
                      },
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _removeWord(index);
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
                    controller: _newWordController,
                    decoration: InputDecoration(labelText: 'Yeni Kelime'),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _newMeaningController,
                    decoration: InputDecoration(labelText: 'Yeni Anlam'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addWord,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}