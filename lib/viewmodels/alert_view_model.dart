import 'package:flutter/material.dart';

class AlertViewModel extends ChangeNotifier {
  String message = "No Alerts";

  void triggerAlert() {
    message = "High Intensity Detected!";
    notifyListeners();
  }
}
