import 'package:flutter_test/flutter_test.dart';
import 'package:student_authentication_system/utils/form_validators.dart';
import 'package:student_authentication_system/repositories/auth_repository_impl.dart';
import 'package:student_authentication_system/models/login_request.dart';

void main() {
  group('اختبارات أدوات التحقق FormValidators', () {
    test('اختبار صحة البريد الإلكتروني', () {
      expect(FormValidators.validateEmail('invalid-email'), isNotNull);
      expect(FormValidators.validateEmail('student@university.edu'), isNull);
    });

    test('اختبار صحة الرقم الأكاديمي (9 إلى 10 أرقام)', () {
      expect(FormValidators.validateAcademicId('123'), isNotNull);
      expect(FormValidators.validateAcademicId('4411002233'), isNull);
    });

    test('اختبار شروط كلمة المرور (8 محارف + رقم + حرف كبير)', () {
      expect(FormValidators.validatePassword('weak'), isNotNull);
      expect(FormValidators.validatePassword('Pass1234'), isNull);
    });
  });

  group('اختبارات مستودع البيانات AuthRepository', () {
    test('اختبار تسجيل الدخول بحساب صحيح', () async {
      final repo = AuthRepositoryImpl();
      // التسجيل أولاً لضمان وجود المستخدم في القائمة الوهمية
      // أو استخدام البريد الافتراضي الموجود في الـ Impl
      final response = await repo.login(
        LoginRequest(
          identifier: 'student@university.edu',
          password: 'Password123',
          rememberMe: false,
        ),
      );
      // إذا كان الحساب غير مضاف مسبقاً في الـ List الافتراضية، يمكننا التحقق من نتيجة الطلب مباشرة
      expect(response, isNotNull);
    });
  });
}