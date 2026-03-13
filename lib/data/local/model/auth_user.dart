class AuthUser {
  final int? id;
  final String email;
  final String password;
  final int? userId;
  final String? createdAt;

  AuthUser({
    this.id,
    required this.email,
    required this.password,
    this.userId,
    this.createdAt,
  });

  factory AuthUser.fromMap(Map<String, dynamic> map) {
    return AuthUser(
      id: map['id'] as int?,
      email: map['email'] as String,
      password: map['password'] as String,
      userId: map['user_id'] as int?,
      createdAt: map['created_at'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'email': email,
      'password': password,
    };
    if (id != null) map['id'] = id;
    if (userId != null) map['user_id'] = userId;
    return map;
  }
}
