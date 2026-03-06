import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {

  //ensures only one database connection exists
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database; //internal databse object

//private constructor for singletton pattern
  DatabaseHelper._init();

  //getter for database instance
  //if database is already intialized return otherwise intialize
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('health_profile.db');
    return _database!;
  }

//initializes sql db
//created/open db file stored on device
  Future<Database> _initDB(String filePath) async {

    //get the default database directory path
    final dbPath = await getDatabasesPath();

    //combine directory path with file name
    final path = join(dbPath, filePath);

    print("Database Path: $path");

    return await openDatabase(
      path,
      version: 1,

      //run when db created only
      onCreate: (db, version) async {
        print("Database opened. Table should already exist externally.");
      },
    );
  }

  /// Load the first row (existing data)
  Future<Map<String, dynamic>?> getProfile() async {
    final db = await instance.database;

    //first row only
    final result = await db.query('health_profile', limit: 1);
    print("DB Data: $result");
    if (result.isNotEmpty) return result.first;
    return null;
  }

  /// Save profile: remove existing and insert new
  Future<void> saveProfile(Map<String, dynamic> profileData) async {
    final db = await instance.database;

    await db.delete('health_profile'); // Remove old row
    //maintain single profie structure/simplifies data model
    await db.insert('health_profile', profileData); // Insert new row
    print("Profile saved: $profileData");
  }

  /// Clear all data
  Future<void> clearProfile() async {
    final db = await instance.database;
    await db.delete('health_profile');
    print("All data cleared");
  }
}