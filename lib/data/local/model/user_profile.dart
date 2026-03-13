class UserProfile {
  final int? id;
  final String name;
  final int age;
  final String condition;
  final int restingHr;
  final int maxHr;
  final String? createdAt;
  final String? updatedAt;

  UserProfile({
    this.id,
    required this.name,
    required this.age,
    required this.condition,
    required this.restingHr,
    required this.maxHr,
    this.createdAt,
    this.updatedAt,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] as int?,
      name: map['name'] as String,
      age: map['age'] as int,
      condition: map['condition'] as String,
      restingHr: map['resting_hr'] as int,
      maxHr: map['max_hr'] as int,
      createdAt: map['created_at'] as String?,
      updatedAt: map['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'name': name,
      'age': age,
      'condition': condition,
      'resting_hr': restingHr,
      'max_hr': maxHr,
    };
    if (id != null) map['id'] = id;
    if (updatedAt != null) map['updated_at'] = updatedAt;
    return map;
  }

  UserProfile copyWith({
    int? id,
    String? name,
    int? age,
    String? condition,
    int? restingHr,
    int? maxHr,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      condition: condition ?? this.condition,
      restingHr: restingHr ?? this.restingHr,
      maxHr: maxHr ?? this.maxHr,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
