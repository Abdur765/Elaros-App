class HRV {
  final int? id;
  final int? userId;
  final String date;
  final double hrvScore;

  HRV({this.id, this.userId, required this.date, required this.hrvScore});

  factory HRV.fromMap(Map<String, dynamic> map) {
    return HRV(
      id: map['id'] as int?,
      userId: map['user_id'] as int?,
      date: map['date'] as String,
      hrvScore: (map['hrv_score'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'date': date,
      'hrv_score': hrvScore,
    };
    if (id != null) map['id'] = id;
    if (userId != null) map['user_id'] = userId;
    return map;
  }
}
