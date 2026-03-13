class Insight {
  final int? id;
  final int? userId;
  final String date;
  final String category;
  final String title;
  final String description;
  final String severity;

  Insight({
    this.id,
    this.userId,
    required this.date,
    required this.category,
    required this.title,
    required this.description,
    this.severity = 'info',
  });

  factory Insight.fromMap(Map<String, dynamic> map) {
    return Insight(
      id: map['id'] as int?,
      userId: map['user_id'] as int?,
      date: map['date'] as String,
      category: map['category'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      severity: (map['severity'] as String?) ?? 'info',
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'date': date,
      'category': category,
      'title': title,
      'description': description,
      'severity': severity,
    };
    if (id != null) map['id'] = id;
    if (userId != null) map['user_id'] = userId;
    return map;
  }
}
