<<<<<<< HEAD
class JwtResponse {
  const JwtResponse({required this.token, required this.type, required this.username, required this.role});
  final String token;     // Signed JWT
  final String type;      // Always "Bearer"
  final String username;
  final String role;      // "ADMIN" | "INSPECTOR"

  factory JwtResponse.fromJson(Map<String, dynamic> j) => JwtResponse(
    token: j['token'] as String, type: j['type'] as String,
    username: j['username'] as String, role: j['role'] as String,
=======
/// Mirrors the backend [JwtResponse] record returned by POST /api/v1/auth/login.
class JwtResponse {
  const JwtResponse({
    required this.token,
    required this.type,
    required this.username,
    required this.role,
  });

  final String token;    // Signed JWT (compact serialisation)
  final String type;     // Always "Bearer"
  final String username;
  final String role;     // "ADMIN" or "INSPECTOR" (ROLE_ prefix stripped by backend)

  factory JwtResponse.fromJson(Map<String, dynamic> json) => JwtResponse(
    token:    json['token']    as String,
    type:     json['type']     as String,
    username: json['username'] as String,
    role:     json['role']     as String,
>>>>>>> 38d35ecc504df7aefda47e8dab5325df5dc5f1a1
  );
}
