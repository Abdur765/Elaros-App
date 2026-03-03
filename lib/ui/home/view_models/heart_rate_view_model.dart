import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:elaros_mobile_app/data/local/model/heart_rate.dart';
import 'package:elaros_mobile_app/data/local/repository/heart_rate_repository.dart';

class HeartRateViewModel extends ChangeNotifier {
  final HeartRateRepository _repo = HeartRateRepository();
  List<HeartRate> items = [];
  bool isLoading = false;
  DateTime? selectedDate;

  String _formatDate(DateTime d) => d.toIso8601String().split('T').first;

  Future<void> loadAll() async {
    isLoading = true;
    notifyListeners();
    if (selectedDate != null) {
      items = await _repo.getByDate(_formatDate(selectedDate!));
    } else {
      items = await _repo.getAll();
    }
    isLoading = false;
    notifyListeners();
  }

  /// Load records for a specific date (date only: YYYY-MM-DD)
  Future<void> loadByDate(DateTime date) async {
    selectedDate = date;
    isLoading = true;
    notifyListeners();
    items = await _repo.getByDate(_formatDate(date));
    isLoading = false;
    notifyListeners();
  }

  /// Clear selected date and load all records
  Future<void> clearDateFilter() async {
    selectedDate = null;
    await loadAll();
  }

  Future<void> addRandom() async {
    final rnd = Random();
    final hr = HeartRate(
      time: DateTime.now().toIso8601String(),
      value: 60 + rnd.nextInt(80),
    );
    await _repo.insert(hr);
    await loadAll();
  }

  Future<void> increment(HeartRate hr) async {
    final updated = hr.copyWith(value: hr.value + 1);
    await _repo.update(updated);
    await loadAll();
  }

  Future<void> deleteById(int id) async {
    await _repo.delete(id);
    await loadAll();
  }
}
