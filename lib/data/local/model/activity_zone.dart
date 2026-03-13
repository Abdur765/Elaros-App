class ActivityZone {
  final int? id;
  final int userId;
  final int zoneNumber;
  final String zoneName;
  final String? description;
  final int hrLower;
  final int hrUpper;

  ActivityZone({
    this.id,
    required this.userId,
    required this.zoneNumber,
    required this.zoneName,
    this.description,
    required this.hrLower,
    required this.hrUpper,
  });

  factory ActivityZone.fromMap(Map<String, dynamic> map) {
    return ActivityZone(
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      zoneNumber: map['zone_number'] as int,
      zoneName: map['zone_name'] as String,
      description: map['description'] as String?,
      hrLower: map['hr_lower'] as int,
      hrUpper: map['hr_upper'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'user_id': userId,
      'zone_number': zoneNumber,
      'zone_name': zoneName,
      'description': description,
      'hr_lower': hrLower,
      'hr_upper': hrUpper,
    };
    if (id != null) map['id'] = id;
    return map;
  }
}
