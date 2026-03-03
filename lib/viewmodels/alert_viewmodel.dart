import 'package:flutter/material.dart';
import '../models/alert_model.dart';
import '../utils/alert_logic.dart';
import '../services/notification_service.dart';

class AlertViewModel extends ChangeNotifier {
  final NotificationService _notificationService = NotificationService();

  List<AlertModel> alerts = [];

  bool overexertionEnabled = true;
  bool hrvEnabled = true;

  Future<void> init() async {
    await _notificationService.init();
  }

  void evaluateData(int zone, int duration, double hrv, double baseline) {
    if (overexertionEnabled && AlertLogic.isHighIntensity(zone, duration)) {
      _createAlert(
        "High Intensity Detected",
        "You have been in the Risk Zone for 6 minutes.",
        AlertType.high,
      );
    }

    if (hrvEnabled && AlertLogic.isLowHRV(hrv, baseline)) {
      _createAlert(
        "Recovery Low",
        "Your HRV is below your baseline.",
        AlertType.recovery,
      );
    }
  }

  void _createAlert(String title, String message, AlertType type) {
    final alert = AlertModel(
      title: title,
      message: message,
      time: DateTime.now(),
      type: type,
    );

    alerts.insert(0, alert);
    _notificationService.show(title, message);
    notifyListeners();
  }

  void toggleOverexertion(bool value) {
    overexertionEnabled = value;
    notifyListeners();
  }

  void toggleHRV(bool value) {
    hrvEnabled = value;
    notifyListeners();
  }
}
