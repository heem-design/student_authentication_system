class PasswordResetRequest {
  final String identifier; // البريد أو الرقم الأكاديمي
  final String otp; // رمز التحقق المكون من 6 أرقام
  final String newPassword; // كلمة المرور الجديدة

  PasswordResetRequest({
    required this.identifier,
    required this.otp,
    required this.newPassword,
  });

  Map<String, dynamic> toMap() {
    return {
      'identifier': identifier,
      'otp': otp,
      'newPassword': newPassword,
    };
  }
}