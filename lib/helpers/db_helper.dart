import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task.dart';

class DBHelper {
  // Inisialisasi database
  static Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'tasks.db');
    return openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT, isCompleted INTEGER, createdAt TEXT)',
        );
      },
      version: 1,
    );
  }

  // Menambahkan task baru ke dalam database
  static Future<int> insertTask(Task task) async {
    final db = await _initDB();
    return await db.insert('tasks', task.toMap());
  }

  // Mengambil semua task dari database
  static Future<List<Task>> getTasks() async {
    final db = await _initDB();
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
  }

  // Memperbarui task yang sudah ada
  static Future<int> updateTask(Task task) async {
    final db = await _initDB();
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // Menghapus task berdasarkan ID
  static Future<int> deleteTask(int id) async {
    final db = await _initDB();
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
