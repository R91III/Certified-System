import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../controllers/auth_controller.dart';
import '../../models/auth_requests.dart';
import '../../utils/form_validators.dart';
import 'auth_widgets.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key, required this.controller});

  final AuthController controller;

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _hidePassword = true;
  bool _hideConfirmation = true;

  @override
  void dispose() {
    _codeController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await widget.controller.resetPassword(
      ResetPasswordRequest(
        code: _codeController.text.trim(),
        newPassword: _passwordController.text,
      ),
    );
    if (!mounted || !success) return;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.check_circle_outline,
          color: Color(0xFF287A58),
          size: 42,
        ),
        title: const Text('تم تحديث كلمة المرور'),
        content: const Text(
          'يمكنك الآن تسجيل الدخول باستخدام كلمة المرور الجديدة.',
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('متابعة'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'تعيين كلمة مرور جديدة',
      subtitle: 'أدخل رمز التحقق ثم اختر كلمة مرور آمنة لحسابك.',
      showBack: true,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthField(
              label: 'رمز التحقق',
              hint: '6 أرقام',
              controller: _codeController,
              validator: FormValidators.otp,
              icon: Icons.pin_outlined,
              keyboardType: TextInputType.number,
              textDirection: TextDirection.ltr,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              maxLength: 6,
            ),
            AuthField(
              label: 'كلمة المرور الجديدة',
              hint: '8 محارف على الأقل، مع رقم وحرف كبير',
              controller: _passwordController,
              validator: FormValidators.strongPassword,
              icon: Icons.lock_outline,
              obscureText: _hidePassword,
              suffix: IconButton(
                tooltip: _hidePassword
                    ? 'إظهار كلمة المرور'
                    : 'إخفاء كلمة المرور',
                onPressed: () => setState(() => _hidePassword = !_hidePassword),
                icon: Icon(
                  _hidePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              ),
            ),
            AuthField(
              label: 'تأكيد كلمة المرور الجديدة',
              hint: 'أعد إدخال كلمة المرور',
              controller: _confirmController,
              validator: (value) => FormValidators.confirmPassword(
                value,
                _passwordController.text,
              ),
              icon: Icons.lock_reset_outlined,
              obscureText: _hideConfirmation,
              suffix: IconButton(
                tooltip: _hideConfirmation
                    ? 'إظهار كلمة المرور'
                    : 'إخفاء كلمة المرور',
                onPressed: () =>
                    setState(() => _hideConfirmation = !_hideConfirmation),
                icon: Icon(
                  _hideConfirmation
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              ),
            ),
            authError(widget.controller),
            AuthSubmitButton(
              label: 'تحديث كلمة المرور',
              controller: widget.controller,
              onPressed: _resetPassword,
            ),
          ],
        ),
      ),
    );
  }
}
