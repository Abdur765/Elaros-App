import 'package:elaros_mobile_app/data/local/model/health_baseline.dart';
import 'package:elaros_mobile_app/data/local/services/database_helper.dart';

class HealthBaselineRepository {
  final _db = DatabaseHelper.instance;

  Future<List<HealthBaseline>> getAll() async {
    return await _db.getAllHealthBaselines();
  }

  Future<int> insert(HealthBaseline baseline) async {
    return await _db.insertHealthBaseline(baseline);
  }

  Future<HealthBaseline?> getByName(String name) async {
    return await _db.getHealthBaselineByName(name);
  }

  Future<int> update(HealthBaseline baseline) async {
    return await _db.updateHealthBaseline(baseline);
  }

  Future<int> delete(int id) async {
    return await _db.deleteHealthBaseline(id);
  }
}
