class FormValidators {
  // 1. التحقق من حقل المعرف (تسجيل الدخول / استعادة كلمة المرور)
  static String? validateIdentifier(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال البريد الإلكتروني أو الرقم الأكاديمي';
    }
    if (value.trim().length < 5) {
      return 'يجب ألا يقل المدخل عن 5 خانات';
    }
    return null;
  }

  // 2. التحقق من الاسم الكامل (3 محارف على الأقل)
  static String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال الاسم الكامل';
    }
    if (value.trim().length < 3) {
      return 'الاسم يجب أن يكون 3 محارف على الأقل';
    }
    return null;
  }

  // 3. التحقق من الرقم الأكاديمي (أرقام فقط، من 9 إلى 10 خانات حصراً)
  static String? validateAcademicId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال الرقم الأكاديمي';
    }
    final numericRegExp = RegExp(r'^[0-9]+$');
    if (!numericRegExp.hasMatch(value.trim())) {
      return 'الرقم الأكاديمي يجب أن يتكون من أرقام فقط';
    }
    if (value.trim().length < 9 || value.trim().length > 10) {
      return 'الرقم الأكاديمي يجب أن يكون بين 9 إلى 10 خانات';
    }
    return null;
  }

  // 4. التحقق من البريد الإلكتروني الجامعي (صيغة صحيحة)
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال البريد الجامعي';
    }
    // تعبير منتظم للتحقق من صحة صيغة البريد الإلكتروني
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value.trim())) {
      return 'صيغة البريد الإلكتروني غير صحيحة';
    }
    return null;
  }

  // 5. التحقق من كلمة المرور (8 محارف، رقم واحد، وحرف إنجليزي كبير واحد على الأقل)
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال كلمة المرور';
    }
    if (value.length < 8) {
      return 'كلمة المرور يجب ألا تقل عن 8 محارف';
    }
    // التحقق من وجود رقم واحد على الأقل
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'كلمة المرور يجب أن تحتوي على رقم واحد على الأقل';
    }
    // التحقق من وجود حرف إنجليزي كبير واحد على الأقل
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'كلمة المرور يجب أن تحتوي على حرف إنجليزي كبير واحد على الأقل (A-Z)';
    }
    return null;
  }

  // 6. التحقق من تطابق تأكيد كلمة المرور
  static String? validateConfirmPassword(String? value, String originalPassword) {
    if (value == null || value.isEmpty) {
      return 'يرجى تأكيد كلمة المرور';
    }
    if (value != originalPassword) {
      return 'كلمتا المرور غير متطابقتين';
    }
    return null;
  }

  // 7. التحقق من رمز التحقق OTP (أرقام فقط، 6 أرقام بالضبط)
  static String? validateOtp(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال رمز التحقق';
    }
    final numericRegExp = RegExp(r'^[0-9]{6}$');
    if (!numericRegExp.hasMatch(value.trim())) {
      return 'رمز التحقق يجب أن يكون 6 أرقام بالضبط';
    }
    return null;
  }
}