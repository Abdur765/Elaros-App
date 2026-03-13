import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/heart_rate.dart';
import '../model/health_baseline.dart';
import '../model/user_profile.dart';
import '../model/hrv.dart';
import '../model/step_count.dart';
import '../model/activity_zone.dart';
import '../model/fitness_goal.dart';
import '../model/daily_snapshot.dart';
import '../model/insight.dart';
import '../model/sleep_log.dart';
import '../model/app_settings.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('elaros.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE UserProfile (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        age INTEGER NOT NULL,
        condition TEXT NOT NULL,
        resting_hr INTEGER NOT NULL,
        max_hr INTEGER NOT NULL,
        created_at TEXT NOT NULL DEFAULT (datetime('now')),
        updated_at TEXT NOT NULL DEFAULT (datetime('now'))
      )
    ''');

    await db.execute('''
      CREATE TABLE HealthBaseline (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        age INTEGER NOT NULL,
        condition TEXT NOT NULL,
        RHR INTEGER NOT NULL,
        MHR INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE HeartRate (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        timestamp TEXT NOT NULL,
        value INTEGER NOT NULL,
        zone INTEGER,
        FOREIGN KEY (user_id) REFERENCES UserProfile(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE HRV (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        date TEXT NOT NULL,
        hrv_score REAL NOT NULL,
        FOREIGN KEY (user_id) REFERENCES UserProfile(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE StepCount (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        timestamp TEXT NOT NULL,
        steps INTEGER NOT NULL,
        FOREIGN KEY (user_id) REFERENCES UserProfile(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE ActivityZone (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        zone_number INTEGER NOT NULL,
        zone_name TEXT NOT NULL,
        description TEXT,
        hr_lower INTEGER NOT NULL,
        hr_upper INTEGER NOT NULL,
        FOREIGN KEY (user_id) REFERENCES UserProfile(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE FitnessGoal (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        goal_type TEXT NOT NULL,
        target_value REAL NOT NULL,
        current_value REAL DEFAULT 0,
        unit TEXT NOT NULL,
        start_date TEXT NOT NULL,
        end_date TEXT,
        is_completed INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (user_id) REFERENCES UserProfile(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE DailySnapshot (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        date TEXT NOT NULL,
        avg_hr INTEGER,
        resting_hr INTEGER,
        peak_hr INTEGER,
        total_steps INTEGER,
        hrv_score REAL,
        dominant_zone INTEGER,
        exertion_warning INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (user_id) REFERENCES UserProfile(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE Insight (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        date TEXT NOT NULL,
        category TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        severity TEXT DEFAULT 'info',
        FOREIGN KEY (user_id) REFERENCES UserProfile(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE CaloriesConsumption (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        timestamp TEXT NOT NULL,
        calories REAL NOT NULL,
        FOREIGN KEY (user_id) REFERENCES UserProfile(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE SleepLog (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        timestamp TEXT NOT NULL,
        state_id INTEGER NOT NULL,
        FOREIGN KEY (user_id) REFERENCES UserProfile(id),
        FOREIGN KEY (state_id) REFERENCES SleepState(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE SleepState (
        id INTEGER PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');
    await db.insert('SleepState', {'id': 1, 'value': 'asleep'});
    await db.insert('SleepState', {'id': 2, 'value': 'restless'});
    await db.insert('SleepState', {'id': 3, 'value': 'awake'});

    await db.execute('''
      CREATE TABLE IntensityState (
        id INTEGER PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');
    await db.insert('IntensityState', {'id': 1, 'value': 'sedentary'});
    await db.insert('IntensityState', {'id': 2, 'value': 'light'});
    await db.insert('IntensityState', {'id': 3, 'value': 'moderate'});
    await db.insert('IntensityState', {'id': 4, 'value': 'vigorous'});

    await db.execute('''
      CREATE TABLE Intensity (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        timestamp TEXT NOT NULL,
        intensity INTEGER NOT NULL,
        FOREIGN KEY (user_id) REFERENCES UserProfile(id),
        FOREIGN KEY (intensity) REFERENCES IntensityState(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE AppSettings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        theme TEXT NOT NULL DEFAULT 'light',
        color_blind_mode INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (user_id) REFERENCES UserProfile(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE Auth (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        user_id INTEGER,
        created_at TEXT NOT NULL DEFAULT (datetime('now')),
        FOREIGN KEY (user_id) REFERENCES UserProfile(id)
      )
    ''');
  }

  // --- HeartRate CRUD ---

  Future<List<HeartRate>> getAllHeartRates() async {
    final db = await instance.database;
    final result = await db.query('HeartRate', orderBy: 'timestamp DESC');
    return result.map((json) => HeartRate.fromMap(json)).toList();
  }

  Future<List<HeartRate>> getHeartRatesByDate(String date) async {
    final db = await instance.database;
    final result = await db.rawQuery(
      "SELECT * FROM HeartRate WHERE date(timestamp) = ? ORDER BY timestamp DESC",
      [date],
    );
    return result.map((json) => HeartRate.fromMap(json)).toList();
  }

  Future<int> insertHeartRate(HeartRate heartRate) async {
    final db = await instance.database;
    return await db.insert('HeartRate', heartRate.toMap());
  }

  Future<HeartRate?> getHeartRateById(int id) async {
    final db = await instance.database;
    final maps = await db.query('HeartRate', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) return HeartRate.fromMap(maps.first);
    return null;
  }

  Future<int> updateHeartRate(HeartRate heartRate) async {
    final db = await instance.database;
    if (heartRate.id == null) return 0;
    return await db.update('HeartRate', heartRate.toMap(), where: 'id = ?', whereArgs: [heartRate.id]);
  }

  Future<int> deleteHeartRate(int id) async {
    final db = await instance.database;
    return await db.delete('HeartRate', where: 'id = ?', whereArgs: [id]);
  }

  // --- HealthBaseline CRUD ---

  Future<List<HealthBaseline>> getAllHealthBaselines() async {
    final db = await instance.database;
    final result = await db.query('HealthBaseline');
    return result.map((map) => HealthBaseline.fromMap(map)).toList();
  }

  Future<int> insertHealthBaseline(HealthBaseline baseline) async {
    final db = await instance.database;
    return await db.insert('HealthBaseline', baseline.toMap());
  }

  Future<HealthBaseline?> getHealthBaselineByName(String name) async {
    final db = await instance.database;
    final maps = await db.query('HealthBaseline', where: 'name = ?', whereArgs: [name]);
    if (maps.isNotEmpty) return HealthBaseline.fromMap(maps.first);
    return null;
  }

  Future<int> updateHealthBaseline(HealthBaseline baseline) async {
    final db = await instance.database;
    if (baseline.id == null) return 0;
    return await db.update('HealthBaseline', baseline.toMap(), where: 'id = ?', whereArgs: [baseline.id]);
  }

  Future<int> deleteHealthBaseline(int id) async {
    final db = await instance.database;
    return await db.delete('HealthBaseline', where: 'id = ?', whereArgs: [id]);
  }

  // --- UserProfile CRUD ---

  Future<int> insertUserProfile(UserProfile profile) async {
    final db = await instance.database;
    return await db.insert('UserProfile', profile.toMap());
  }

  Future<UserProfile?> getUserProfile(int id) async {
    final db = await instance.database;
    final maps = await db.query('UserProfile', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) return UserProfile.fromMap(maps.first);
    return null;
  }

  Future<List<UserProfile>> getAllUserProfiles() async {
    final db = await instance.database;
    final result = await db.query('UserProfile');
    return result.map((map) => UserProfile.fromMap(map)).toList();
  }

  Future<int> updateUserProfile(UserProfile profile) async {
    final db = await instance.database;
    if (profile.id == null) return 0;
    return await db.update('UserProfile', profile.toMap(), where: 'id = ?', whereArgs: [profile.id]);
  }

  Future<int> deleteUserProfile(int id) async {
    final db = await instance.database;
    return await db.delete('UserProfile', where: 'id = ?', whereArgs: [id]);
  }

  // --- HRV CRUD ---

  Future<int> insertHRV(HRV hrv) async {
    final db = await instance.database;
    return await db.insert('HRV', hrv.toMap());
  }

  Future<List<HRV>> getHRVByDateRange(String startDate, String endDate) async {
    final db = await instance.database;
    final result = await db.query('HRV', where: 'date BETWEEN ? AND ?', whereArgs: [startDate, endDate], orderBy: 'date DESC');
    return result.map((map) => HRV.fromMap(map)).toList();
  }

  Future<List<HRV>> getAllHRV() async {
    final db = await instance.database;
    final result = await db.query('HRV', orderBy: 'date DESC');
    return result.map((map) => HRV.fromMap(map)).toList();
  }

  // --- StepCount CRUD ---

  Future<int> insertStepCount(StepCount stepCount) async {
    final db = await instance.database;
    return await db.insert('StepCount', stepCount.toMap());
  }

  Future<List<StepCount>> getStepCountsByDate(String date) async {
    final db = await instance.database;
    final result = await db.rawQuery(
      "SELECT * FROM StepCount WHERE date(timestamp) = ? ORDER BY timestamp ASC",
      [date],
    );
    return result.map((map) => StepCount.fromMap(map)).toList();
  }

  Future<List<StepCount>> getAllStepCounts() async {
    final db = await instance.database;
    final result = await db.query('StepCount', orderBy: 'timestamp DESC');
    return result.map((map) => StepCount.fromMap(map)).toList();
  }

  // --- ActivityZone CRUD ---

  Future<int> insertActivityZone(ActivityZone zone) async {
    final db = await instance.database;
    return await db.insert('ActivityZone', zone.toMap());
  }

  Future<List<ActivityZone>> getActivityZonesForUser(int userId) async {
    final db = await instance.database;
    final result = await db.query('ActivityZone', where: 'user_id = ?', whereArgs: [userId], orderBy: 'zone_number ASC');
    return result.map((map) => ActivityZone.fromMap(map)).toList();
  }

  Future<int> updateActivityZone(ActivityZone zone) async {
    final db = await instance.database;
    if (zone.id == null) return 0;
    return await db.update('ActivityZone', zone.toMap(), where: 'id = ?', whereArgs: [zone.id]);
  }

  Future<int> deleteActivityZone(int id) async {
    final db = await instance.database;
    return await db.delete('ActivityZone', where: 'id = ?', whereArgs: [id]);
  }

  // --- FitnessGoal CRUD ---

  Future<int> insertFitnessGoal(FitnessGoal goal) async {
    final db = await instance.database;
    return await db.insert('FitnessGoal', goal.toMap());
  }

  Future<List<FitnessGoal>> getFitnessGoalsForUser(int userId) async {
    final db = await instance.database;
    final result = await db.query('FitnessGoal', where: 'user_id = ?', whereArgs: [userId]);
    return result.map((map) => FitnessGoal.fromMap(map)).toList();
  }

  Future<int> updateFitnessGoal(FitnessGoal goal) async {
    final db = await instance.database;
    if (goal.id == null) return 0;
    return await db.update('FitnessGoal', goal.toMap(), where: 'id = ?', whereArgs: [goal.id]);
  }

  Future<int> deleteFitnessGoal(int id) async {
    final db = await instance.database;
    return await db.delete('FitnessGoal', where: 'id = ?', whereArgs: [id]);
  }

  // --- DailySnapshot CRUD ---

  Future<int> insertDailySnapshot(DailySnapshot snapshot) async {
    final db = await instance.database;
    return await db.insert('DailySnapshot', snapshot.toMap());
  }

  Future<DailySnapshot?> getDailySnapshot(String date, {int? userId}) async {
    final db = await instance.database;
    String where = 'date = ?';
    List<dynamic> args = [date];
    if (userId != null) {
      where += ' AND user_id = ?';
      args.add(userId);
    }
    final maps = await db.query('DailySnapshot', where: where, whereArgs: args);
    if (maps.isNotEmpty) return DailySnapshot.fromMap(maps.first);
    return null;
  }

  Future<List<DailySnapshot>> getDailySnapshotsByRange(String startDate, String endDate) async {
    final db = await instance.database;
    final result = await db.query('DailySnapshot', where: 'date BETWEEN ? AND ?', whereArgs: [startDate, endDate], orderBy: 'date DESC');
    return result.map((map) => DailySnapshot.fromMap(map)).toList();
  }

  Future<int> updateDailySnapshot(DailySnapshot snapshot) async {
    final db = await instance.database;
    if (snapshot.id == null) return 0;
    return await db.update('DailySnapshot', snapshot.toMap(), where: 'id = ?', whereArgs: [snapshot.id]);
  }

  // --- Insight CRUD ---

  Future<int> insertInsight(Insight insight) async {
    final db = await instance.database;
    return await db.insert('Insight', insight.toMap());
  }

  Future<List<Insight>> getInsightsForDate(String date) async {
    final db = await instance.database;
    final result = await db.query('Insight', where: 'date = ?', whereArgs: [date], orderBy: 'id DESC');
    return result.map((map) => Insight.fromMap(map)).toList();
  }

  Future<List<Insight>> getInsightsByCategory(String category) async {
    final db = await instance.database;
    final result = await db.query('Insight', where: 'category = ?', whereArgs: [category], orderBy: 'date DESC');
    return result.map((map) => Insight.fromMap(map)).toList();
  }

  // --- SleepLog CRUD ---

  Future<int> insertSleepLog(SleepLog log) async {
    final db = await instance.database;
    return await db.insert('SleepLog', log.toMap());
  }

  Future<List<SleepLog>> getSleepLogsByDate(String date) async {
    final db = await instance.database;
    final result = await db.rawQuery(
      "SELECT * FROM SleepLog WHERE date(timestamp) = ? ORDER BY timestamp ASC",
      [date],
    );
    return result.map((map) => SleepLog.fromMap(map)).toList();
  }

  // --- AppSettings CRUD ---

  Future<int> insertAppSettings(AppSettings settings) async {
    final db = await instance.database;
    return await db.insert('AppSettings', settings.toMap());
  }

  Future<AppSettings?> getAppSettings(int userId) async {
    final db = await instance.database;
    final maps = await db.query('AppSettings', where: 'user_id = ?', whereArgs: [userId]);
    if (maps.isNotEmpty) return AppSettings.fromMap(maps.first);
    return null;
  }

  Future<int> updateAppSettings(AppSettings settings) async {
    final db = await instance.database;
    if (settings.id == null) return 0;
    return await db.update('AppSettings', settings.toMap(), where: 'id = ?', whereArgs: [settings.id]);
  }
}
