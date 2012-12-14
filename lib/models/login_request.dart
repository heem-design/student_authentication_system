class LoginRequest {
  final String identifier; // البريد الإلكتروني أو الرقم الأكاديمي
  final String password;
  final bool rememberMe;

  LoginRequest({
    required this.identifier,
    required this.password,
    required this.rememberMe,
  });

  Map<String, dynamic> toMap() {
    return {
      'identifier': identifier,
      'password': password,
      'rememberMe': rememberMe,
    };
  }
}