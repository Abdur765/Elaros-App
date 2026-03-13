class DailySnapshot {
  final int? id;
  final int? userId;
  final String date;
  final int? avgHr;
  final int? restingHr;
  final int? peakHr;
  final int? totalSteps;
  final double? hrvScore;
  final int? dominantZone;
  final bool exertionWarning;

  DailySnapshot({
    this.id,
    this.userId,
    required this.date,
    this.avgHr,
    this.restingHr,
    this.peakHr,
    this.totalSteps,
    this.hrvScore,
    this.dominantZone,
    this.exertionWarning = false,
  });

  factory DailySnapshot.fromMap(Map<String, dynamic> map) {
    return DailySnapshot(
      id: map['id'] as int?,
      userId: map['user_id'] as int?,
      date: map['date'] as String,
      avgHr: map['avg_hr'] as int?,
      restingHr: map['resting_hr'] as int?,
      peakHr: map['peak_hr'] as int?,
      totalSteps: map['total_steps'] as int?,
      hrvScore: (map['hrv_score'] as num?)?.toDouble(),
      dominantZone: map['dominant_zone'] as int?,
      exertionWarning: (map['exertion_warning'] as int) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'date': date,
      'avg_hr': avgHr,
      'resting_hr': restingHr,
      'peak_hr': peakHr,
      'total_steps': totalSteps,
      'hrv_score': hrvScore,
      'dominant_zone': dominantZone,
      'exertion_warning': exertionWarning ? 1 : 0,
    };
    if (id != null) map['id'] = id;
    if (userId != null) map['user_id'] = userId;
    return map;
  }
}
