class AppSettings {
  final int? id;
  final int? userId;
  final String theme;
  final bool colorBlindMode;

  AppSettings({
    this.id,
    this.userId,
    this.theme = 'light',
    this.colorBlindMode = false,
  });

  factory AppSettings.fromMap(Map<String, dynamic> map) {
    return AppSettings(
      id: map['id'] as int?,
      userId: map['user_id'] as int?,
      theme: (map['theme'] as String?) ?? 'light',
      colorBlindMode: (map['color_blind_mode'] as int) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'theme': theme,
      'color_blind_mode': colorBlindMode ? 1 : 0,
    };
    if (id != null) map['id'] = id;
    if (userId != null) map['user_id'] = userId;
    return map;
  }
}
