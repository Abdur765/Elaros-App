class FitnessGoal {
  final int? id;
  final int? userId;
  final String goalType;
  final double targetValue;
  final double currentValue;
  final String unit;
  final String startDate;
  final String? endDate;
  final bool isCompleted;

  FitnessGoal({
    this.id,
    this.userId,
    required this.goalType,
    required this.targetValue,
    this.currentValue = 0,
    required this.unit,
    required this.startDate,
    this.endDate,
    this.isCompleted = false,
  });

  factory FitnessGoal.fromMap(Map<String, dynamic> map) {
    return FitnessGoal(
      id: map['id'] as int?,
      userId: map['user_id'] as int?,
      goalType: map['goal_type'] as String,
      targetValue: (map['target_value'] as num).toDouble(),
      currentValue: (map['current_value'] as num?)?.toDouble() ?? 0,
      unit: map['unit'] as String,
      startDate: map['start_date'] as String,
      endDate: map['end_date'] as String?,
      isCompleted: (map['is_completed'] as int) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'goal_type': goalType,
      'target_value': targetValue,
      'current_value': currentValue,
      'unit': unit,
      'start_date': startDate,
      'end_date': endDate,
      'is_completed': isCompleted ? 1 : 0,
    };
    if (id != null) map['id'] = id;
    if (userId != null) map['user_id'] = userId;
    return map;
  }
}
