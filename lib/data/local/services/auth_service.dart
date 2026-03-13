import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:elaros_mobile_app/data/local/services/database_helper.dart';
import 'package:elaros_mobile_app/data/local/model/user_profile.dart';

class AuthService {
  static final AuthService instance = AuthService._();
  AuthService._();

  int? _currentUserId;
  int? get currentUserId => _currentUserId;

  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _currentUserId = prefs.getInt('current_user_id');
  }

  bool get isLoggedIn => _currentUserId != null;

  Future<String?> login(String email, String password) async {
    final db = await DatabaseHelper.instance.database;
    final hashedPw = _hashPassword(password);

    final result = await db.query(
      'Auth',
      where: 'email = ? AND password = ?',
      whereArgs: [email.trim().toLowerCase(), hashedPw],
    );

    if (result.isEmpty) return 'Invalid email or password';

    _currentUserId = result.first['user_id'] as int?;
    final prefs = await SharedPreferences.getInstance();
    if (_currentUserId != null) {
      await prefs.setInt('current_user_id', _currentUserId!);
    }
    return null; // success
  }

  Future<String?> signUp({
    required String name,
    required int age,
    required String condition,
    required int restingHr,
    required int maxHr,
    required String email,
    required String password,
  }) async {
    final db = await DatabaseHelper.instance.database;

    // Check if email exists
    final existing = await db.query('Auth', where: 'email = ?', whereArgs: [email.trim().toLowerCase()]);
    if (existing.isNotEmpty) return 'Email already registered';

    // Create user profile
    final profile = UserProfile(
      name: name,
      age: age,
      condition: condition,
      restingHr: restingHr,
      maxHr: maxHr,
    );
    final userId = await DatabaseHelper.instance.insertUserProfile(profile);

    // Create health baseline
    await db.insert('HealthBaseline', {
      'name': name,
      'age': age,
      'condition': condition,
      'RHR': restingHr,
      'MHR': maxHr,
    });

    // Create auth record
    final hashedPw = _hashPassword(password);
    await db.insert('Auth', {
      'email': email.trim().toLowerCase(),
      'password': hashedPw,
      'user_id': userId,
    });

    // Create default activity zones
    final hrr = maxHr - restingHr;
    final zones = [
      {'zone_number': 1, 'zone_name': 'Recovery', 'description': 'Very low intensity; safe baseline activity.', 'hr_lower': restingHr - 10, 'hr_upper': restingHr + (hrr * 0.3).round()},
      {'zone_number': 2, 'zone_name': 'Sustainable', 'description': 'Safe zone for pacing; minimal risk of symptoms.', 'hr_lower': restingHr + (hrr * 0.3).round() + 1, 'hr_upper': restingHr + (hrr * 0.5).round()},
      {'zone_number': 3, 'zone_name': 'Caution', 'description': 'Moderate intensity; fatigue onset possible.', 'hr_lower': restingHr + (hrr * 0.5).round() + 1, 'hr_upper': restingHr + (hrr * 0.65).round()},
      {'zone_number': 4, 'zone_name': 'Risk', 'description': 'High-intensity activity likely to trigger symptoms.', 'hr_lower': restingHr + (hrr * 0.65).round() + 1, 'hr_upper': restingHr + (hrr * 0.8).round()},
      {'zone_number': 5, 'zone_name': 'Overexertion', 'description': 'Should be avoided; high risk for PEM.', 'hr_lower': restingHr + (hrr * 0.8).round() + 1, 'hr_upper': maxHr},
    ];
    for (final zone in zones) {
      await db.insert('ActivityZone', {'user_id': userId, ...zone});
    }

    // Create default app settings
    await db.insert('AppSettings', {'user_id': userId, 'theme': 'light', 'color_blind_mode': 0});

    _currentUserId = userId;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('current_user_id', userId);

    return null; // success
  }

  Future<void> logout() async {
    _currentUserId = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user_id');
  }

  Future<UserProfile?> getCurrentUserProfile() async {
    if (_currentUserId == null) return null;
    return await DatabaseHelper.instance.getUserProfile(_currentUserId!);
  }
}
