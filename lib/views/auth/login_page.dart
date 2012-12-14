import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../models/login_request.dart';
import '../../utils/form_validators.dart';
import 'register_page.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  final AuthController authController;
  const LoginPage({super.key, required this.authController});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _passController = TextEditingController();
  bool _obscure = true;
  bool _remember = false;

  @override
  void dispose() {
    _idController.dispose();
    _passController.dispose();
    super.dispose();
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final success = await widget.authController.login(
        LoginRequest(identifier: _idController.text.trim(), password: _passController.text, rememberMe: _remember),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? widget.authController.successMessage! : widget.authController.errorMessage!),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.school, size: 70, color: Colors.indigo),
                  const SizedBox(height: 16),
                  const Text('تسجيل الدخول', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo)),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _idController,
                    decoration: const InputDecoration(labelText: 'البريد أو الرقم الأكاديمي', border: OutlineInputBorder()),
                    validator: FormValidators.validateIdentifier,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passController,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      labelText: 'كلمة المرور',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    validator: (v) => v!.isEmpty ? 'يرجى إدخال كلمة المرور' : null,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(value: _remember, onChanged: (v) => setState(() => _remember = v!)),
                          const Text('تذكرني'),
                        ],
                      ),
                      TextButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ForgotPasswordPage(authController: widget.authController))),
                        child: const Text('نسيت كلمة المرور؟'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AnimatedBuilder(
                    animation: widget.authController,
                    builder: (context, _) => ElevatedButton(
                      onPressed: widget.authController.isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white, padding: const EdgeInsets.all(14)),
                      child: widget.authController.isLoading
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text('دخول', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('ليس لديك حساب؟'),
                      TextButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterPage(authController: widget.authController))),
                        child: const Text('إنشاء حساب'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}