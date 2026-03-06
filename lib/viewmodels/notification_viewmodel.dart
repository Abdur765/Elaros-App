import 'package:flutter/material.dart';
import '../data/model/notification_model.dart';

class NotificationViewModel extends ChangeNotifier {
  List<NotificationModel> _notifications = [];

  List<NotificationModel> get notifications => _notifications;

  void loadNotifications() {
    _notifications = [
      NotificationModel(
        title: "High Intensity Detected",
        message: "You are in the Risk Zone.",
        type: "high",
        time: DateTime.now(),
      ),
      notificationmodel(
        title: "Recovery Low",
        message: "Your HRV is below baseline.",
        type: "warning",
        time: DateTime.now(),
      ),
    ];
    notifyListeners();
  }
}
