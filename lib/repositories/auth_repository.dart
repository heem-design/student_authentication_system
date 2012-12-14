import '../models/user_model.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../models/password_reset_request.dart';
import '../models/auth_response.dart';

abstract class AuthRepository {
  Future<AuthResponse> login(LoginRequest request);
  Future<AuthResponse> register(RegisterRequest request);
  Future<AuthResponse> sendPasswordResetCode(String identifier);
  Future<AuthResponse> resetPassword(PasswordResetRequest request);
}