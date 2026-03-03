import 'package:flutter/material.dart';
import 'package:elaros_mobile_app/data/local/services/health_data_service.dart';

// HR Zone definitions matching Figma design
class HRZone {
  final int number;
  final String name;
  final Color color;
  final Color bgColor;
  final Color textColor;
  final String description;

  const HRZone({
    required this.number,
    required this.name,
    required this.color,
    required this.bgColor,
    required this.textColor,
    required this.description,
  });
}

const List<HRZone> hrZones = [
  HRZone(
    number: 1,
    name: 'Recovery',
    color: Color(0xff10b981),
    bgColor: Color(0xffd1fae5),
    textColor: Color(0xff065f46),
    description: 'Safe for rest and recovery',
  ),
  HRZone(
    number: 2,
    name: 'Sustainable',
    color: Color(0xff3b82f6),
    bgColor: Color(0xffdbeafe),
    textColor: Color(0xff1e40af),
    description: 'Light daily activities',
  ),
  HRZone(
    number: 3,
    name: 'Caution',
    color: Color(0xfff59e0b),
    bgColor: Color(0xfffef3c7),
    textColor: Color(0xff92400e),
    description: 'Monitor and limit time',
  ),
  HRZone(
    number: 4,
    name: 'Risk',
    color: Color(0xffef4444),
    bgColor: Color(0xfffee2e2),
    textColor: Color(0xff991b1b),
    description: 'Reduce activity immediately',
  ),
  HRZone(
    number: 5,
    name: 'Overexertion',
    color: Color(0xffdc2626),
    bgColor: Color(0xfffecaca),
    textColor: Color(0xff7f1d1d),
    description: 'Stop and rest now',
  ),
];

class HealthViewModel extends ChangeNotifier {
  final HealthDataService _service = HealthDataService();

  bool isLoading = true;
  String? error;

  // Heart rate
  int latestHR = 0;
  int minHR = 0;
  int maxHR = 0;
  int avgHR = 0;
  List<Map<String, dynamic>> hourlyHeartRate = [];

  // Steps
  int todaySteps = 0;
  List<Map<String, dynamic>> dailySteps = [];

  // Calories
  double todayCalories = 0;
  List<Map<String, dynamic>> dailyCalories = [];

  // Sleep
  int sleepTotalMinutes = 0;
  int sleepAsleepMinutes = 0;
  int sleepRestlessMinutes = 0;
  int sleepAwakeMinutes = 0;
  List<Map<String, dynamic>> sleepBreakdown = [];

  HRZone get currentZone {
    if (latestHR < 80) return hrZones[0];
    if (latestHR < 100) return hrZones[1];
    if (latestHR < 115) return hrZones[2];
    if (latestHR < 130) return hrZones[3];
    return hrZones[4];
  }

  int get recoveryScore {
    // Simple recovery score based on resting HR and sleep
    if (minHR == 0) return 0;
    int score = 100;
    if (minHR > 70) score -= (minHR - 70) * 2;
    if (sleepTotalMinutes < 360) score -= (360 - sleepTotalMinutes) ~/ 10;
    return score.clamp(0, 100);
  }

  Future<void> loadAllData() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await Future.wait([
        _loadHeartRate(),
        _loadSteps(),
        _loadCalories(),
        _loadSleep(),
      ]);
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> _loadHeartRate() async {
    final summary = await _service.getHeartRateSummary();
    latestHR = (summary['latestHR'] as num?)?.toInt() ?? 0;
    minHR = (summary['minHR'] as num?)?.toInt() ?? 0;
    maxHR = (summary['maxHR'] as num?)?.toInt() ?? 0;
    avgHR = (summary['avgHR'] as num?)?.toInt() ?? 0;

    final hourly = await _service.getHourlyHeartRate();
    hourlyHeartRate = hourly.map((row) {
      final hr = (row['avgHR'] as num).toInt();
      return {
        'hour': int.parse(row['hour'] as String),
        'avgHR': hr,
        'zone': _getZoneNumber(hr),
      };
    }).toList();
  }

  int _getZoneNumber(int hr) {
    if (hr < 80) return 1;
    if (hr < 100) return 2;
    if (hr < 115) return 3;
    if (hr < 130) return 4;
    return 5;
  }

  Future<void> _loadSteps() async {
    final summary = await _service.getStepsSummary();
    todaySteps = (summary['totalSteps'] as num?)?.toInt() ?? 0;

    final daily = await _service.getDailySteps();
    dailySteps = daily.reversed.map((row) {
      final dateStr = row['date'] as String;
      final shortDate = dateStr.substring(5);
      return {
        'date': shortDate,
        'steps': (row['totalSteps'] as num?)?.toInt() ?? 0,
      };
    }).toList();
  }

  Future<void> _loadCalories() async {
    final summary = await _service.getCaloriesSummary();
    todayCalories = (summary['totalCalories'] as num?)?.toDouble() ?? 0;

    final daily = await _service.getDailyCalories();
    dailyCalories = daily.reversed.map((row) {
      final dateStr = row['date'] as String;
      final shortDate = dateStr.substring(5);
      return {
        'date': shortDate,
        'calories': (row['totalCalories'] as num?)?.toDouble() ?? 0,
      };
    }).toList();
  }

  Future<void> _loadSleep() async {
    final summary = await _service.getSleepSummary();
    sleepTotalMinutes = (summary['totalMinutes'] as num?)?.toInt() ?? 0;
    sleepAsleepMinutes = (summary['asleepMinutes'] as num?)?.toInt() ?? 0;
    sleepRestlessMinutes = (summary['restlessMinutes'] as num?)?.toInt() ?? 0;
    sleepAwakeMinutes = (summary['awakeMinutes'] as num?)?.toInt() ?? 0;

    final breakdown = await _service.getSleepBreakdown();
    sleepBreakdown = breakdown.map((row) {
      return {
        'state': row['state'] as String,
        'minutes': (row['minutes'] as num).toInt(),
      };
    }).toList();
  }

  String get sleepDuration {
    final hours = sleepTotalMinutes ~/ 60;
    final minutes = sleepTotalMinutes % 60;
    return '${hours}h ${minutes}m';
  }

  String formatNumber(int number) {
    if (number >= 1000) {
      final str = number.toString();
      final buffer = StringBuffer();
      for (var i = 0; i < str.length; i++) {
        if (i > 0 && (str.length - i) % 3 == 0) buffer.write(',');
        buffer.write(str[i]);
      }
      return buffer.toString();
    }
    return number.toString();
  }
}
