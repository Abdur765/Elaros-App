import 'package:elaros_mobile_app/utils/database/db.dart';

class HealthDataService {
  /// Get the latest heart rate readings (most recent day of data).
  Future<List<Map<String, dynamic>>> getLatestHeartRateReadings({int limit = 200}) async {
    final db = await DatabaseHelper.database;
    return db.rawQuery('''
      SELECT timestamp, value
      FROM HeartRate
      WHERE value > 0
      ORDER BY timestamp DESC
      LIMIT ?
    ''', [limit]);
  }

  /// Get heart rate summary (min, max, avg) for the most recent day.
  Future<Map<String, dynamic>> getHeartRateSummary() async {
    final db = await DatabaseHelper.database;
    final result = await db.rawQuery('''
      SELECT
        MIN(value) as minHR,
        MAX(value) as maxHR,
        ROUND(AVG(value)) as avgHR,
        (SELECT value FROM HeartRate WHERE value > 0 ORDER BY timestamp DESC LIMIT 1) as latestHR
      FROM HeartRate
      WHERE value > 0
        AND date(timestamp) = (SELECT date(timestamp) FROM HeartRate WHERE value > 0 ORDER BY timestamp DESC LIMIT 1)
    ''');
    return result.isNotEmpty ? result.first : {};
  }

  /// Get hourly average heart rate for the most recent day (for chart).
  Future<List<Map<String, dynamic>>> getHourlyHeartRate() async {
    final db = await DatabaseHelper.database;
    return db.rawQuery('''
      SELECT
        strftime('%H', timestamp) as hour,
        ROUND(AVG(value)) as avgHR,
        MIN(value) as minHR,
        MAX(value) as maxHR
      FROM HeartRate
      WHERE value > 0
        AND date(timestamp) = (SELECT date(timestamp) FROM HeartRate WHERE value > 0 ORDER BY timestamp DESC LIMIT 1)
      GROUP BY strftime('%H', timestamp)
      ORDER BY hour
    ''');
  }

  /// Get daily step totals for the last 7 days of available data.
  Future<List<Map<String, dynamic>>> getDailySteps() async {
    final db = await DatabaseHelper.database;
    return db.rawQuery('''
      SELECT date(timestamp) as date, SUM(steps) as totalSteps
      FROM StepCount
      GROUP BY date(timestamp)
      ORDER BY date DESC
      LIMIT 7
    ''');
  }

  /// Get step count summary for the most recent day.
  Future<Map<String, dynamic>> getStepsSummary() async {
    final db = await DatabaseHelper.database;
    final result = await db.rawQuery('''
      SELECT SUM(steps) as totalSteps
      FROM StepCount
      WHERE date(timestamp) = (SELECT date(timestamp) FROM StepCount ORDER BY timestamp DESC LIMIT 1)
    ''');
    return result.isNotEmpty ? result.first : {};
  }

  /// Get daily calorie totals for the last 7 days of available data.
  Future<List<Map<String, dynamic>>> getDailyCalories() async {
    final db = await DatabaseHelper.database;
    return db.rawQuery('''
      SELECT date(timestamp) as date, ROUND(SUM(calories), 1) as totalCalories
      FROM CaloriesConsumption
      GROUP BY date(timestamp)
      ORDER BY date DESC
      LIMIT 7
    ''');
  }

  /// Get calories summary for the most recent day.
  Future<Map<String, dynamic>> getCaloriesSummary() async {
    final db = await DatabaseHelper.database;
    final result = await db.rawQuery('''
      SELECT ROUND(SUM(calories), 1) as totalCalories
      FROM CaloriesConsumption
      WHERE date(timestamp) = (SELECT date(timestamp) FROM CaloriesConsumption ORDER BY timestamp DESC LIMIT 1)
    ''');
    return result.isNotEmpty ? result.first : {};
  }

  /// Get sleep summary for the most recent night.
  Future<Map<String, dynamic>> getSleepSummary() async {
    final db = await DatabaseHelper.database;
    final result = await db.rawQuery('''
      SELECT
        COUNT(*) as totalMinutes,
        SUM(CASE WHEN value = 1 THEN 1 ELSE 0 END) as asleepMinutes,
        SUM(CASE WHEN value = 2 THEN 1 ELSE 0 END) as restlessMinutes,
        SUM(CASE WHEN value = 3 THEN 1 ELSE 0 END) as awakeMinutes
      FROM SleepLogs
      WHERE date(timestamp) = (SELECT date(timestamp) FROM SleepLogs ORDER BY timestamp DESC LIMIT 1)
    ''');
    return result.isNotEmpty ? result.first : {};
  }

  /// Get sleep data for pie chart breakdown.
  Future<List<Map<String, dynamic>>> getSleepBreakdown() async {
    final db = await DatabaseHelper.database;
    return db.rawQuery('''
      SELECT
        ss.value as state,
        COUNT(*) as minutes
      FROM SleepLogs sl
      JOIN SleepStates ss ON sl.value = ss.id
      WHERE date(sl.timestamp) = (SELECT date(timestamp) FROM SleepLogs ORDER BY timestamp DESC LIMIT 1)
      GROUP BY sl.value
    ''');
  }

  /// Get daily intensity breakdown for the last 7 days.
  Future<List<Map<String, dynamic>>> getDailyIntensity() async {
    final db = await DatabaseHelper.database;
    return db.rawQuery('''
      SELECT
        date(i.timestamp) as date,
        ist.value as state,
        COUNT(*) as minutes
      FROM Intensities i
      JOIN IntensityStates ist ON i.intensity = ist.id
      WHERE date(i.timestamp) IN (
        SELECT DISTINCT date(timestamp) FROM Intensities ORDER BY date(timestamp) DESC LIMIT 7
      )
      GROUP BY date(i.timestamp), i.intensity
      ORDER BY date DESC
    ''');
  }
}
