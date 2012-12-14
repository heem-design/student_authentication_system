import '../models/user_model.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../models/password_reset_request.dart';
import '../models/auth_response.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  // قائمة مؤقتة لتخزين المستخدمين في الذاكرة أثناء تشغيل التطبيق
  static final List<UserModel> _fakeDatabase = [];

  // تخزين مؤقت لرمز التحقق OTP المرتبط بالمعرف لاستعادة كلمة المرور
  static final Map<String, String> _otpStorage = {};

  @override
  Future<AuthResponse> register(RegisterRequest request) async {
    // محاكاة تأخير الشبكة (ثانية ونصف)
    await Future.delayed(const Duration(milliseconds: 1500));

    // فحص ما إذا كان البريد الجامعي مسجلاً من قبل
    bool emailExists = _fakeDatabase.any(
      (user) => user.universityEmail.toLowerCase() == request.universityEmail.toLowerCase()
    );

    if (emailExists) {
      return AuthResponse(
        success: false,
        message: 'البريد الجامعي مستخدم مسبقاً، يرجى استخدام بريد آخر.',
      );
    }

    // فحص ما إذا كان الرقم الأكاديمي مسجلاً من قبل
    bool academicIdExists = _fakeDatabase.any(
      (user) => user.academicId == request.academicId
    );

    if (academicIdExists) {
      return AuthResponse(
        success: false,
        message: 'الرقم الأكاديمي مسجل مسبقاً لحساب آخر.',
      );
    }

    // إنشاء كود مستخدم فريد وتخزينه
    final newUser = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fullName: request.fullName,
      academicId: request.academicId,
      universityEmail: request.universityEmail,
      password: request.password,
    );

    _fakeDatabase.add(newUser);

    return AuthResponse(
      success: true,
      message: 'تم إنشاء الحساب بنجاح! يمكنك تسجيل الدخول الآن.',
      user: newUser,
    );
  }

  @override
  Future<AuthResponse> login(LoginRequest request) async {
    // محاكاة تأخير الشبكة
    await Future.delayed(const Duration(milliseconds: 1500));

    // البحث عن المستخدم إما بالبريد الجامعي أو بالرقم الأكاديمي
    UserModel? foundUser;
    try {
      foundUser = _fakeDatabase.firstWhere(
        (user) => 
          user.universityEmail.toLowerCase() == request.identifier.toLowerCase() ||
          user.academicId == request.identifier
      );
    } catch (e) {
      foundUser = null;
    }

    if (foundUser == null) {
      return AuthResponse(
        success: false,
        message: 'الحساب غير موجود، يرجى التحقق من المدخل أو إنشاء حساب جديد.',
      );
    }

    if (foundUser.password != request.password) {
      return AuthResponse(
        success: false,
        message: 'كلمة المرور غير صحيحة، يرجى المحاولة مرة أخرى.',
      );
    }

    return AuthResponse(
      success: true,
      message: 'تم تسجيل الدخول بنجاح، مرحباً بك!',
      user: foundUser,
    );
  }

  @override
  Future<AuthResponse> sendPasswordResetCode(String identifier) async {
    // محاكاة تأخير الشبكة
    await Future.delayed(const Duration(milliseconds: 1200));

    // التحقق من وجود المستخدم
    UserModel? foundUser;
    try {
      foundUser = _fakeDatabase.firstWhere(
        (user) => 
          user.universityEmail.toLowerCase() == identifier.toLowerCase() ||
          user.academicId == identifier
      );
    } catch (e) {
      foundUser = null;
    }

    if (foundUser == null) {
      return AuthResponse(
        success: false,
        message: 'عذراً، هذا الحساب غير مسجل في النظام.',
      );
    }

    // توليد رمز تحقق تجريبي ثابت أو عشوائي (مثلاً: 123456 لتسهيل الاختبار)
    const String simulatedOtp = '123456';
    _otpStorage[identifier] = simulatedOtp;

    return AuthResponse(
      success: true,
      message: 'تم إرسال رمز التحقق بنجاح. (رمز التجربة: $simulatedOtp)',
    );
  }

  @override
  Future<AuthResponse> resetPassword(PasswordResetRequest request) async {
    // محاكاة تأخير الشبكة
    await Future.delayed(const Duration(milliseconds: 1500));

    // التحقق من صحة رمز OTP المخزن
    final storedOtp = _otpStorage[request.identifier];
    if (storedOtp == null || storedOtp != request.otp) {
      return AuthResponse(
        success: false,
        message: 'رمز التحقق غير صحيح، يرجى إدخال الرمز الصحيح.',
      );
    }

    // البحث عن المستخدم وتحديث كلمة المرور الخاصة به
    int index = _fakeDatabase.indexWhere(
      (user) => 
        user.universityEmail.toLowerCase() == request.identifier.toLowerCase() ||
        user.academicId == request.identifier
    );

    if (index != -1) {
      final oldUser = _fakeDatabase[index];
      // إنشاء كود محدث بكلمة المرور الجديدة
      final updatedUser = UserModel(
        id: oldUser.id,
        fullName: oldUser.fullName,
        academicId: oldUser.academicId,
        universityEmail: oldUser.universityEmail,
        password: request.newPassword,
      );
      _fakeDatabase[index] = updatedUser;
      
      // تنظيف الرمز بعد الاستخدام
      _otpStorage.remove(request.identifier);

      return AuthResponse(
        success: true,
        message: 'تم تحديث كلمة المرور بنجاح، يمكنك تسجيل الدخول الآن.',
      );
    }

    return AuthResponse(
      success: false,
      message: 'حدث خطأ ما، يرجى المحاولة لاحقاً.',
    );
  }
}