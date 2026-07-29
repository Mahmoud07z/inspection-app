class AppUser {
  const AppUser({required this.id, required this.username, required this.email,
      required this.fullName, required this.role, required this.createdAt, required this.updatedAt});

  final int id;
  final String username;
  final String email;
  final String fullName;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory AppUser.fromJson(Map<String, dynamic> j) => AppUser(
    id: j['id'] as int,
    username: j['username'] as String,
    email: j['email'] as String,
    fullName: j['fullName'] as String? ?? '',
    role: j['role'] as String,
    createdAt: DateTime.parse(j['createdAt'] as String),
    updatedAt: DateTime.parse(j['updatedAt'] as String),
  );
}
