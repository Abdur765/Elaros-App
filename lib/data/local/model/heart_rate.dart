class HeartRate {
  final int? id;
  final int? userId;
  final String time;
  final int value;
  final int? zone;

  HeartRate({this.id, this.userId, required this.time, required this.value, this.zone});

  factory HeartRate.fromMap(Map<String, dynamic> map) {
    return HeartRate(
      id: map['id'] != null ? map['id'] as int : null,
      userId: map['user_id'] as int?,
      time: (map['time'] as String?) ?? (map['timestamp'] as String?) ?? '',
      value: map['value'] as int,
      zone: map['zone'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{'timestamp': time, 'value': value};
    if (id != null) map['id'] = id;
    if (userId != null) map['user_id'] = userId;
    if (zone != null) map['zone'] = zone;
    return map;
  }

  HeartRate copyWith({int? id, int? userId, String? time, int? value, int? zone}) {
    return HeartRate(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      time: time ?? this.time,
      value: value ?? this.value,
      zone: zone ?? this.zone,
    );
  }
}
