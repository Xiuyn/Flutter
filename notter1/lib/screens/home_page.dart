import 'package:flutter/material.dart';
import 'main_page.dart';
import 'notes_page.dart';
import 'lists_page.dart';
import 'words_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  final bool isDarkTheme;
  final ValueChanged<bool> onThemeChanged;

  HomePage({
    required this.isDarkTheme,
    required this.onThemeChanged,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      MainPage(),
      NotesPage(),
      ListsPage(),
      WordsPage(),
      SettingsPage(
        isDarkTheme: widget.isDarkTheme,
        onThemeChanged: widget.onThemeChanged,
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notter'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menü',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              title: Text('Ana Sayfa'),
              onTap: () => _onItemTapped(0),
            ),
            ListTile(
              title: Text('Notlarım'),
              onTap: () => _onItemTapped(1),
            ),
            ListTile(
              title: Text('Listelerim'),
              onTap: () => _onItemTapped(2),
            ),
            ListTile(
              title: Text('Kelimelerim'),
              onTap: () => _onItemTapped(3),
            ),
            ListTile(
              title: Text('Ayarlar'),
              onTap: () => _onItemTapped(4),
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}
