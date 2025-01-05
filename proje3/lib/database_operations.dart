import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'personel.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Personel (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        ad TEXT NOT NULL,
        soyad TEXT NOT NULL,
        departman TEXT NOT NULL,
        maas INTEGER NOT NULL
      )
    ''');
  }

  // Veri ekleme
  Future<int> insertPersonel(Map<String, dynamic> personel) async {
    Database db = await database;
    return await db.insert('Personel', personel);
  }

  // Veri silme
  Future<int> deletePersonel(int id) async {
    Database db = await database;
    return await db.delete('Personel', where: 'id = ?', whereArgs: [id]);
  }

  // Veri güncelleme
  Future<int> updatePersonel(int id, Map<String, dynamic> personel) async {
    Database db = await database;
    return await db.update('Personel', personel, where: 'id = ?', whereArgs: [id]);
  }

  // Verileri gruplama (departmana göre gruplama)
  Future<List<Map<String, dynamic>>> groupByDepartman() async {
    Database db = await database;
    return await db.rawQuery('SELECT departman, COUNT(*) AS sayi, AVG(maas) AS ortalama_maas FROM Personel GROUP BY departman');
  }

  // Tüm verileri alma
  Future<List<Map<String, dynamic>>> getAllPersonel() async {
    Database db = await database;
    return await db.query('Personel');
  }
}
