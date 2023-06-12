import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqfliteServices {
  static final SqfliteServices _instance = SqfliteServices._internal();

  factory SqfliteServices() => _instance;

  static Database? _database;

  SqfliteServices._internal();

  static const String _databaseName = '75_hard_db.db';
  static const int _databaseVersion = 1;
  static const String _tableName = 'daily_progress';
  static const String _columnId = 'id';
  static const String _columnDay = 'day';
  static const String _columnDiet = 'diet';
  static const String _columnWorkout = 'workout';
  static const String _columnPicture = 'picture';
  static const String _columnWater = 'water';
  static const String _columnReading = 'reading';

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    final String databasePath = await getDatabasesPath();
    final String path = join(databasePath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE $_tableName (
            $_columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $_columnDay INTEGER NOT NULL,
            $_columnDiet REAL NOT NULL,
            $_columnWorkout REAL NOT NULL,
            $_columnPicture REAL NOT NULL,
            $_columnWater REAL NOT NULL,
            $_columnReading REAL NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertData(int day, double diet, double workout, double picture,
      double water, double reading) async {
    final Database db = await database;

    final Map<String, dynamic> data = {
      _columnDay: day,
      _columnDiet: diet,
      _columnWorkout: workout,
      _columnPicture: picture,
      _columnWater: water,
      _columnReading: reading,
    };

    return await db.insert(_tableName, data);
  }

  Future<List<Map<String, dynamic>>> getAllData() async {
    final Database db = await database;
    return await db.query(_tableName);
  }

  Future<int> deleteAllData() async {
    final Database db = await database;
    return await db.delete(_tableName);
  }

  Future<List<Map<String, dynamic>>> getDataByDay(int day) async {
    final Database db = await database;
    return await db.query(
      _tableName,
      where: '$_columnDay = ?',
      whereArgs: [day],
    );
  }

  Future<int> updateDataByDay(int day, double diet, double workout,
      double picture, double water, double reading) async {
    final Database db = await database;

    final Map<String, dynamic> data = {
      _columnDiet: diet,
      _columnWorkout: workout,
      _columnPicture: picture,
      _columnWater: water,
      _columnReading: reading,
    };

    return await db.update(
      _tableName,
      data,
      where: '$_columnDay = ?',
      whereArgs: [day],
    );
  }

  Future<int> deleteDataByDay(int day) async {
    final Database db = await database;

    return await db.delete(
      _tableName,
      where: '$_columnDay = ?',
      whereArgs: [day],
    );
  }
}
