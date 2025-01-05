import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  final bool isDarkTheme;
  final ValueChanged<bool> onThemeChanged;

  SettingsPage({
    required this.isDarkTheme,
    required this.onThemeChanged,
  });

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool _isDarkTheme;

  @override
  void initState() {
    super.initState();
    _isDarkTheme = widget.isDarkTheme;
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkTheme', _isDarkTheme);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ayarlar'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text('Renk Teması'),
            trailing: DropdownButton<bool>(
              value: _isDarkTheme,
              items: [
                DropdownMenuItem(
                  value: false,
                  child: Text('Açık Tema'),
                ),
                DropdownMenuItem(
                  value: true,
                  child: Text('Koyu Tema'),
                ),
              ],
              onChanged: (bool? value) {
                setState(() {
                  _isDarkTheme = value!;
                  widget.onThemeChanged(_isDarkTheme);
                  _savePreferences();
                });
              },
            ),
          ),
         
        ],
      ),
    );
  }
}