import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/form_validators.dart';
import 'reset_password_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  final AuthController authController;
  const ForgotPasswordPage({super.key, required this.authController});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }

  void _sendCode() async {
    if (_formKey.currentState!.validate()) {
      final identifier = _idController.text.trim();
      final success = await widget.authController.sendPasswordResetCode(identifier);
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? widget.authController.successMessage! : widget.authController.errorMessage!),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );

      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ResetPasswordPage(
              authController: widget.authController,
              identifier: identifier,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('استعادة كلمة المرور')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('أدخل البريد الجامعي أو الرقم الأكاديمي لإرسال رمز التحقق.', style: TextStyle(fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _idController,
                  decoration: const InputDecoration(labelText: 'البريد أو الرقم الأكاديمي', border: OutlineInputBorder()),
                  validator: FormValidators.validateIdentifier,
                ),
                const SizedBox(height: 24),
                AnimatedBuilder(
                  animation: widget.authController,
                  builder: (context, _) => ElevatedButton(
                    onPressed: widget.authController.isLoading ? null : _sendCode,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white, padding: const EdgeInsets.all(14)),
                    child: widget.authController.isLoading
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('إرسال رمز التحقق', style: TextStyle(fontSize: 16)),
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