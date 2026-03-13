class HealthBaseline {
  final int? id;
  final String name;
  final int age;
  final String condition;
  final int rhr;
  final int mhr;

  HealthBaseline({
    this.id,
    required this.name,
    required this.age,
    required this.condition,
    required this.rhr,
    required this.mhr,
  });

  factory HealthBaseline.fromMap(Map<String, dynamic> map) {
    return HealthBaseline(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] as String,
      age: map['age'] as int,
      condition: map['condition'] as String,
      rhr: map['RHR'] as int,
      mhr: map['MHR'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'name': name,
      'age': age,
      'condition': condition,
      'RHR': rhr,
      'MHR': mhr,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  HealthBaseline copyWith({
    int? id,
    String? name,
    int? age,
    String? condition,
    int? rhr,
    int? mhr,
  }) {
    return HealthBaseline(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      condition: condition ?? this.condition,
      rhr: rhr ?? this.rhr,
      mhr: mhr ?? this.mhr,
    );
  }
}
