class StepCount {
  final int? id;
  final int? userId;
  final String timestamp;
  final int steps;

  StepCount({this.id, this.userId, required this.timestamp, required this.steps});

  factory StepCount.fromMap(Map<String, dynamic> map) {
    return StepCount(
      id: map['id'] as int?,
      userId: map['user_id'] as int?,
      timestamp: map['timestamp'] as String,
      steps: map['steps'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'timestamp': timestamp,
      'steps': steps,
    };
    if (id != null) map['id'] = id;
    if (userId != null) map['user_id'] = userId;
    return map;
  }
}
