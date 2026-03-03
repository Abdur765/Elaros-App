class AlertLogic {
  static bool isHighIntensity(int zone, int minutes) {
    return zone >= 4 && minutes >= 5;
  }

  static bool isLowHRV(double hrv, double baseline) {
    return hrv < baseline * 0.85;
  }
}
