import 'package:flutter/foundation.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../models/password_reset_request.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

class AuthController extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthController({required AuthRepository authRepository})
      : _authRepository = authRepository;

  // الحالات المتغيرة (State Variables)
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  UserModel? _currentUser;

  // Getters لقراءة الحالات من الواجهات
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  UserModel? get currentUser => _currentUser;

  // دالة تسجيل الدخول
  Future<bool> login(LoginRequest request) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    final response = await _authRepository.login(request);

    _isLoading = false;
    if (response.success) {
      _currentUser = response.user;
      _successMessage = response.message;
      notifyListeners();
      return true;
    } else {
      _errorMessage = response.message;
      notifyListeners();
      return false;
    }
  }

  // دالة إنشاء حساب جديد
  Future<bool> register(RegisterRequest request) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    final response = await _authRepository.register(request);

    _isLoading = false;
    if (response.success) {
      _successMessage = response.message;
      notifyListeners();
      return true;
    } else {
      _errorMessage = response.message;
      notifyListeners();
      return false;
    }
  }

  // دالة إرسال رمز التحقق لاستعادة كلمة المرور
  Future<bool> sendPasswordResetCode(String identifier) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    final response = await _authRepository.sendPasswordResetCode(identifier);

    _isLoading = false;
    if (response.success) {
      _successMessage = response.message;
      notifyListeners();
      return true;
    } else {
      _errorMessage = response.message;
      notifyListeners();
      return false;
    }
  }

  // دالة تعيين كلمة المرور الجديدة
  Future<bool> resetPassword(PasswordResetRequest request) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    final response = await _authRepository.resetPassword(request);

    _isLoading = false;
    if (response.success) {
      _successMessage = response.message;
      notifyListeners();
      return true;
    } else {
      _errorMessage = response.message;
      notifyListeners();
      return false;
    }
  }

  // مسح الرسائل عند التنقل بين الشاشات
  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }
}