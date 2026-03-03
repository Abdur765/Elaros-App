enum AlertType { high, recovery }

class AlertModel {
  final String title;
  final String message;
  final DateTime time;
  final AlertType type;

  AlertModel({
    required this.title,
    required this.message,
    required this.time,
    required this.type,
  });
}
