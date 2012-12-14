import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../models/password_reset_request.dart';
import '../../utils/form_validators.dart';

class ResetPasswordPage extends StatefulWidget {
  final AuthController authController;
  final String identifier;
  const ResetPasswordPage({super.key, required this.authController, required this.identifier});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  final _newPassController = TextEditingController();
  bool _obscurePass = true;

  @override
  void dispose() {
    _otpController.dispose();
    _newPassController.dispose();
    super.dispose();
  }

  void _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      final success = await widget.authController.resetPassword(
        PasswordResetRequest(
          identifier: widget.identifier,
          otp: _otpController.text.trim(),
          newPassword: _newPassController.text,
        ),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? widget.authController.successMessage! : widget.authController.errorMessage!),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );

      if (success) {
        // العودة إلى شاشة تسجيل الدخول بعد النجاح
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تعيين كلمة المرور الجديدة')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('أدخل رمز التحقق (OTP) المرسل وكلمة المرور الجديدة.', style: TextStyle(fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'رمز التحقق (6 أرقام)', border: OutlineInputBorder()),
                  validator: FormValidators.validateOtp,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _newPassController,
                  obscureText: _obscurePass,
                  decoration: InputDecoration(
                    labelText: 'كلمة المرور الجديدة',
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
                    onPressed: widget.authController.isLoading ? null : _resetPassword,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white, padding: const EdgeInsets.all(14)),
                    child: widget.authController.isLoading
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('حفظ كلمة المرور الجديدة', style: TextStyle(fontSize: 16)),
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