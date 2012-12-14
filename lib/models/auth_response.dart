import 'user_model.dart';

class AuthResponse {
  final bool success;
  final String message;
  final UserModel? user;

  AuthResponse({
    required this.success,
    required this.message,
    this.user,
  });
}