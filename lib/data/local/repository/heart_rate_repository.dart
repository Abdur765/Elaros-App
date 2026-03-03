import 'package:elaros_mobile_app/data/local/model/heart_rate.dart';
import 'package:elaros_mobile_app/data/local/services/database_helper.dart';

class HeartRateRepository {
  final _db = DatabaseHelper.instance;

  Future<List<HeartRate>> getAll() async {
    return await _db.getAllHeartRates();
  }

  Future<int> insert(HeartRate hr) async {
    return await _db.insertHeartRate(hr);
  }

  Future<List<HeartRate>> getByDate(String date) async {
    return await _db.getHeartRatesByDate(date);
  }

  Future<HeartRate?> getById(int id) async {
    return await _db.getHeartRateById(id);
  }

  Future<int> update(HeartRate hr) async {
    return await _db.updateHeartRate(hr);
  }

  Future<int> delete(int id) async {
    return await _db.deleteHeartRate(id);
  }
}
