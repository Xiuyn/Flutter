import 'package:flutter/material.dart';
import 'database_operations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  
  final TextEditingController _adController = TextEditingController();
  final TextEditingController _soyadController = TextEditingController();
  final TextEditingController _departmanController = TextEditingController();
  final TextEditingController _maasController = TextEditingController();
  int? _editingPersonelId;

  @override
  void initState() {
    super.initState();
    _loadPersonelData();
  }

  Future<void> _loadPersonelData() async {
    setState(() {});
  }

  Future<void> _addOrUpdatePersonel() async {
    final personel = {
      'ad': _adController.text,
      'soyad': _soyadController.text,
      'departman': _departmanController.text,
      'maas': int.tryParse(_maasController.text) ?? 0,
    };

    if (_editingPersonelId == null) {
      // Yeni personel ekleme
      await dbHelper.insertPersonel(personel);
    } else {
      // Var olan personeli güncelleme
      await dbHelper.updatePersonel(_editingPersonelId!, personel);
      _editingPersonelId = null;
    }

    _clearForm();
    _loadPersonelData();
  }

  void _clearForm() {
    _adController.clear();
    _soyadController.clear();
    _departmanController.clear();
    _maasController.clear();
  }

  void _editPersonel(Map<String, dynamic> personel) {
    _editingPersonelId = personel['id'];
    _adController.text = personel['ad'];
    _soyadController.text = personel['soyad'];
    _departmanController.text = personel['departman'];
    _maasController.text = personel['maas'].toString();
  }

  Future<void> _deletePersonel(int id) async {
    await dbHelper.deletePersonel(id);
    _loadPersonelData();
  }

  Future<void> _groupByDepartman() async {
    List<Map<String, dynamic>> result = await dbHelper.groupByDepartman();
    result.forEach((row) {
      print('Departman: ${row['departman']}, Sayı: ${row['sayi']}, Ortalama Maaş: ${row['ortalama_maas']}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personel Veritabanı'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _adController,
                  decoration: InputDecoration(labelText: 'Ad'),
                ),
                TextField(
                  controller: _soyadController,
                  decoration: InputDecoration(labelText: 'Soyad'),
                ),
                TextField(
                  controller: _departmanController,
                  decoration: InputDecoration(labelText: 'Departman'),
                ),
                TextField(
                  controller: _maasController,
                  decoration: InputDecoration(labelText: 'Maaş'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _addOrUpdatePersonel,
                  child: Text(_editingPersonelId == null ? 'Personel Ekle' : 'Güncelle'),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: dbHelper.getAllPersonel(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final personelList = snapshot.data!;
                return ListView.builder(
                  itemCount: personelList.length,
                  itemBuilder: (context, index) {
                    final personel = personelList[index];
                    return ListTile(
                      title: Text('${personel['ad']} ${personel['soyad']}'),
                      subtitle: Text('Departman: ${personel['departman']} - Maaş: ${personel['maas']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _editPersonel(personel),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deletePersonel(personel['id']),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _groupByDepartman,
        child: Icon(Icons.group),
        tooltip: 'Departmana Göre Grupla',
      ),
    );
  }
}
