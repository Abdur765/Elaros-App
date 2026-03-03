import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> openDatabaseFromAssets() async {
  final directory = await getTemporaryDirectory();
  final path = join(directory.path, 'health_lite.db');

  final exists = await File(path).exists();

  if (!exists) {
    ByteData data = await rootBundle.load('assets/database/health_lite.db');
    List<int> bytes = data.buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    );
    await File(path).writeAsBytes(bytes, flush: true);
  }

  return await openDatabase(path, readOnly: true);
}
