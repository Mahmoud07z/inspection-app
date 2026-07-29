class JwtResponse {
  const JwtResponse({required this.token, required this.type, required this.username, required this.role});
  final String token;     // Signed JWT
  final String type;      // Always "Bearer"
  final String username;
  final String role;      // "ADMIN" | "INSPECTOR"

  factory JwtResponse.fromJson(Map<String, dynamic> j) => JwtResponse(
    token: j['token'] as String, type: j['type'] as String,
    username: j['username'] as String, role: j['role'] as String,
  );
}
