// Source - https://stackoverflow.com/a/78016268
// Posted by Aprendendo Next
// Retrieved 2026-02-16, License - CC BY-SA 4.0
import 'package:sqflite/sqflite.dart';

import 'package:elaros_mobile_app/utils/database/db_native.dart'
    if (dart.library.html) 'package:elaros_mobile_app/utils/database/db_web.dart'
    as platform_db;

class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await platform_db.openDatabaseFromAssets();
    return _database!;
  }
}
