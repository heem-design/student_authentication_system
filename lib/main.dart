import 'package:flutter/material.dart';
import 'controllers/auth_controller.dart';
import 'repositories/auth_repository_impl.dart';
import 'views/auth/login_page.dart';

void main() {
  runApp(const StudentAuthApp());
}

class StudentAuthApp extends StatelessWidget {
  const StudentAuthApp({super.key});

  @override
  Widget build(BuildContext context) {
    // إنشاء كائن من الـ Repository والمتحكم لربطهما بالتطبيق
    final authRepository = AuthRepositoryImpl();
    final authController = AuthController(authRepository: authRepository);

    return MaterialApp(
      title: 'نظام مصادقة الطلاب',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      // تشغيل شاشة تسجيل الدخول وتمرير المتحكم إليها كبداية للتطبيق
      home: LoginPage(authController: authController),
    );
  }
}