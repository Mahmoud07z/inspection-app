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
  );
}
