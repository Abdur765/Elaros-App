import 'package:flutter/services.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> openDatabaseFromAssets() async {
  final factory = databaseFactoryFfiWeb;

  const dbName = 'health_lite.db';

  // Check if database already exists in IndexedDB
  final exists = await factory.databaseExists(dbName);

  if (!exists) {
    // Load from assets and write to IndexedDB
    ByteData data = await rootBundle.load('assets/database/health_lite.db');
    final bytes = data.buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    );
    await factory.writeDatabaseBytes(dbName, bytes);
  }

  return await factory.openDatabase(dbName);
}
