class SleepLog {
  final int? id;
  final int? userId;
  final String timestamp;
  final int stateId;

  SleepLog({this.id, this.userId, required this.timestamp, required this.stateId});

  factory SleepLog.fromMap(Map<String, dynamic> map) {
    return SleepLog(
      id: map['id'] as int?,
      userId: map['user_id'] as int?,
      timestamp: map['timestamp'] as String,
      stateId: map['state_id'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'timestamp': timestamp,
      'state_id': stateId,
    };
    if (id != null) map['id'] = id;
    if (userId != null) map['user_id'] = userId;
    return map;
  }
}
