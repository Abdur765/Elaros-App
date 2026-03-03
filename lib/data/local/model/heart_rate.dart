class HeartRate {
  final int? id;
  final String time;
  final int value;

  HeartRate({this.id, required this.time, required this.value});

  factory HeartRate.fromMap(Map<String, dynamic> map) {
    return HeartRate(
      id: map['id'] != null ? map['id'] as int : null,
      time: (map['time'] as String?) ?? (map['timestamp'] as String?) ?? '',
      value: map['value'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{'time': time, 'value': value};
    if (id != null) map['id'] = id;
    return map;
  }

  HeartRate copyWith({int? id, String? time, int? value}) {
    return HeartRate(
      id: id ?? this.id,
      time: time ?? this.time,
      value: value ?? this.value,
    );
  }
}
