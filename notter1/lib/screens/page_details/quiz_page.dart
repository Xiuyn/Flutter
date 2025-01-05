import 'package:flutter/material.dart';
import 'dart:math';

class QuizPage extends StatefulWidget {
  final List<Map<String, String>> words;

  QuizPage({required this.words});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late List<Map<String, String>> _questions;
  int _currentQuestionIndex = 0;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _generateQuestions();
  }

  void _generateQuestions() {
    _questions = List.from(widget.words);
    _questions.shuffle();
  }

  void _checkAnswer(String selectedMeaning) {
    if (_questions[_currentQuestionIndex]['anlam'] == selectedMeaning) {
      setState(() {
        _score++;
      });
    }
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _showResult();
    }
  }

  void _showResult() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sınav Sonucu'),
        content: Text('Doğru Sayısı: $_score / ${_questions.length}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text('Tamam'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentQuestionIndex];
    final correctMeaning = question['anlam'];
    final options = <String>[];

    // Doğru cevabı ekle
    options.add(correctMeaning!);

    // Diğer kelimelerden rastgele 3 yanlış cevap ekle
    final random = Random();
    while (options.length < 4) {
      final randomMeaning = widget.words[random.nextInt(widget.words.length)]['anlam'];
      if (randomMeaning != null && !options.contains(randomMeaning)) {
        options.add(randomMeaning);
      }
    }

    // Şıkları karıştır
    options.shuffle();

    return Scaffold(
      appBar: AppBar(
        title: Text('Sınav'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            Text(
              question['kelime']!,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 48),
            ...options.map((option) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () => _checkAnswer(option),
                    child: Text(option),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}