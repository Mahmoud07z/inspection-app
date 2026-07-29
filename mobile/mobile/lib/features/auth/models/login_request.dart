<<<<<<< HEAD
class LoginRequest {
  const LoginRequest({required this.username, required this.password});
  final String username;
  final String password;
  Map<String, dynamic> toJson() => {'username': username, 'password': password};
=======
/// Request body for POST /api/v1/auth/login.
class LoginRequest {
  const LoginRequest({required this.username, required this.password});

  final String username;
  final String password;

  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password,
  };
>>>>>>> 38d35ecc504df7aefda47e8dab5325df5dc5f1a1
}
