import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('gift_generator.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 2, // Увеличена версия базы данных для изменения схемы
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        password TEXT NOT NULL,
        fullName TEXT NOT NULL,
        avatarPath TEXT NOT NULL,
        role TEXT NOT NULL CHECK (role IN ('user', 'admin'))
      )
    ''');

    await db.execute('''
      CREATE TABLE gifts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        imageUrl TEXT NOT NULL,
        cardText TEXT NOT NULL,
        userId INTEGER NOT NULL,
        FOREIGN KEY (userId) REFERENCES users (id)
      )
    ''');
  }

  // Добавление пользователя
  Future<int> createUser(User user) async {
    final db = await instance.database;
    return await db.insert('users', user.toMap());
  }

  // Получение пользователя по логину и паролю
  Future<User?> getUser(String username, String password) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  // Получение всех пользователей
  Future<List<User>> getAllUsers() async {
    final db = await instance.database;
    final result = await db.query('users');
    return result.map((map) => User.fromMap(map)).toList();
  }

  // Удаление пользователя
  Future<void> deleteUser(int userId) async {
    final db = await instance.database;
    await db.delete('users', where: 'id = ?', whereArgs: [userId]);
  }

  // Добавление подарка
  Future<int> addGift(Gift gift) async {
    final db = await instance.database;
    return await db.insert('gifts', gift.toMap());
  }

  Future<List<Gift>> getAllGifts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('gifts');

    return maps.map((map) => Gift.fromMap(map)).toList();
  }



  // Получение подарков по ID пользователя
  Future<List<Gift>> getGiftsByUserId(int userId) async {
    final db = await instance.database;
    final result = await db.query(
      'gifts',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return result.map((map) => Gift.fromMap(map)).toList();
  }
}
