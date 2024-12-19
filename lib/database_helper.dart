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

    // Insert default admin user
    await db.insert('users', {
      'username': 'Admin',
      'password': '11111', // Consider hashing the password in production.
      'fullName': 'Administrator Administrator',
      'role': 'admin',
      'avatarPath': '', // Default empty avatar
    });

    await db.insert('gifts', {
      'name': 'Медвежонок',
      'description': 'Милый плюшевый медвежонок для ваших близких.',
      'imageUrl': 'assets/images/teddy_bear.png',
      'cardText': 'Обними меня!',
      'userId': 2, // Или ID конкретного пользователя
    });

    await db.insert('gifts', {
      'name': 'Коробка конфет',
      'description': 'Вкуснейшие ассорти конфет.',
      'imageUrl': 'assets/images/chocolate_box.png',
      'cardText': 'Сладкие моменты!',
      'userId': 2,
    });

    await db.insert('gifts', {
      'name': 'Букет цветов',
      'description': 'Красивый букет свежих цветов.',
      'imageUrl': 'assets/images/flower_bouquet.png',
      'cardText': 'Для особенного дня!',
      'userId': 2,
    });

    await db.insert('gifts', {
      'name': 'Наручные часы',
      'description': 'Элегантные наручные часы с кожаным ремешком.',
      'imageUrl': 'assets/images/wrist_watch.png',
      'cardText': 'Бесценные мгновения!',
      'userId': 2,
    });

    await db.insert('gifts', {
      'name': 'Парфюм',
      'description': 'Роскошный аромат, чтобы оставить неизгладимое впечатление.',
      'imageUrl': 'assets/images/perfume.png',
      'cardText': 'Пахни восхитительно!',
      'userId': 2,
    });

    await db.insert('gifts', {
      'name': 'Книга',
      'description': 'Интересная книга для ума и души.',
      'imageUrl': 'assets/images/book.png',
      'cardText': 'Наслаждайся чтением!',
      'userId': null, // Или ID конкретного пользователя
    });

    await db.insert('gifts', {
      'name': 'Музыкальная колонка',
      'description': 'Портативная колонка для любимой музыки.',
      'imageUrl': 'assets/images/speaker.png',
      'cardText': 'Лови ритм!',
      'userId': null,
    });

    await db.insert('gifts', {
      'name': 'Игровая консоль',
      'description': 'Лучший подарок для любителей игр.',
      'imageUrl': 'assets/images/game_console.png',
      'cardText': 'Играй и побеждай!',
      'userId': null,
    });

    await db.insert('gifts', {
      'name': 'Фотоаппарат',
      'description': 'Цифровая камера для запечатления особенных моментов.',
      'imageUrl': 'assets/images/camera.png',
      'cardText': 'Запечатли воспоминания!',
      'userId': null,
    });

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

  Future<void> updateGiftUser(int giftId, int userId) async {
    final db = await database;
    await db.update(
      'gifts',
      {'userId': userId},
      where: 'id = ?',
      whereArgs: [giftId],
    );
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
