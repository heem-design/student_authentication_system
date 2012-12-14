import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../models/register_request.dart';
import '../../utils/form_validators.dart';

class RegisterPage extends StatefulWidget {
  final AuthController authController;
  const RegisterPage({super.key, required this.authController});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _academicIdController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePass = true;

  @override
  void dispose() {
    _nameController.dispose();
    _academicIdController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      final success = await widget.authController.register(
        RegisterRequest(
          fullName: _nameController.text.trim(),
          academicId: _academicIdController.text.trim(),
          universityEmail: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? widget.authController.successMessage! : widget.authController.errorMessage!),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
      if (success) Navigator.pop(context); // العودة لشاشة تسجيل الدخول عند النجاح
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء حساب جديد')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'الاسم الكامل', border: OutlineInputBorder()),
                  validator: FormValidators.validateFullName,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _academicIdController,
                  decoration: const InputDecoration(labelText: 'الرقم الأكاديمي', border: OutlineInputBorder()),
                  validator: FormValidators.validateAcademicId,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'البريد الجامعي', border: OutlineInputBorder()),
                  validator: FormValidators.validateEmail,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePass,
                  decoration: InputDecoration(
                    labelText: 'كلمة المرور',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePass ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscurePass = !_obscurePass),
                    ),
                  ),
                  validator: FormValidators.validatePassword,
                ),
                const SizedBox(height: 24),
                AnimatedBuilder(
                  animation: widget.authController,
                  builder: (context, _) => ElevatedButton(
                    onPressed: widget.authController.isLoading ? null : _register,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white, padding: const EdgeInsets.all(14)),
                    child: widget.authController.isLoading
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('تسجيل الحساب', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}