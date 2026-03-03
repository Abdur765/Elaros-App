import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/heart_rate.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('heart_data.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    // This creates the table if it doesn't exist
    await db.execute('''
      CREATE TABLE HeartRate (
        id INTEGER PRIMARY KEY,
        time TEXT NOT NULL,
        value INTEGER NOT NULL
      )
    ''');
  }

  // Fetch all heart rate records
  Future<List<HeartRate>> getAllHeartRates() async {
    final db = await instance.database;
    final result = await db.query('HeartRate', orderBy: 'time DESC');

    return result.map((json) => HeartRate.fromMap(json)).toList();
  }

  // Fetch heart rate records for a specific date (YYYY-MM-DD)
  // Supports rows that store ISO datetimes in either `time` or `timestamp` column.
  Future<List<HeartRate>> getHeartRatesByDate(String date) async {
    final db = await instance.database;
    final result = await db.rawQuery(
      // Use COALESCE to handle either `time` or `timestamp` column.
      "SELECT * FROM HeartRate WHERE COALESCE(date(time), date(timestamp)) = ? ORDER BY COALESCE(time, timestamp) DESC",
      [date],
    );
    return result.map((json) => HeartRate.fromMap(json)).toList();
  }

  // Insert a new heart rate record. Returns inserted row id.
  Future<int> insertHeartRate(HeartRate heartRate) async {
    final db = await instance.database;
    return await db.insert('HeartRate', heartRate.toMap());
  }

  // Get heart rate by id
  Future<HeartRate?> getHeartRateById(int id) async {
    final db = await instance.database;
    final maps = await db.query('HeartRate', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) return HeartRate.fromMap(maps.first);
    return null;
  }

  // Update existing heart rate. Returns number of rows affected.
  Future<int> updateHeartRate(HeartRate heartRate) async {
    final db = await instance.database;
    if (heartRate.id == null) return 0;
    return await db.update(
      'HeartRate',
      heartRate.toMap(),
      where: 'id = ?',
      whereArgs: [heartRate.id],
    );
  }

  // Delete heart rate by id. Returns number of rows deleted.
  Future<int> deleteHeartRate(int id) async {
    final db = await instance.database;
    return await db.delete('HeartRate', where: 'id = ?', whereArgs: [id]);
  }
}
