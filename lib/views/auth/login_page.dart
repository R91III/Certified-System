import 'package:flutter/material.dart';

import '../../controllers/auth_controller.dart';
import '../../models/auth_requests.dart';
import '../../utils/form_validators.dart';
import 'auth_widgets.dart';
import 'forgot_password_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.controller});

  final AuthController controller;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _hidePassword = true;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    final user = await widget.controller.login(
      LoginRequest(
        identifier: _identifierController.text.trim(),
        password: _passwordController.text,
        rememberMe: _rememberMe,
      ),
    );
    if (!mounted || user == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('مرحباً ${user.fullName}'),
        backgroundColor: const Color(0xFF287A58),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'تسجيل الدخول',
      subtitle: 'أهلاً بعودتك، أدخل بياناتك للوصول إلى حسابك الأكاديمي.',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthField(
              label: 'المعرف الأكاديمي أو البريد',
              hint: 'أدخل المعرف أو البريد الجامعي',
              controller: _identifierController,
              validator: FormValidators.identifier,
              icon: Icons.badge_outlined,
              keyboardType: TextInputType.emailAddress,
              textDirection: TextDirection.ltr,
            ),
            AuthField(
              label: 'كلمة المرور',
              hint: 'أدخل كلمة المرور',
              controller: _passwordController,
              validator: FormValidators.loginPassword,
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
            Row(
              children: [
                Checkbox.adaptive(
                  value: _rememberMe,
                  activeColor: const Color(0xFF173B3F),
                  onChanged: (value) =>
                      setState(() => _rememberMe = value ?? false),
                ),
                const Text('تذكرني', style: TextStyle(fontSize: 13)),
                const Spacer(),
                authLink(context, 'نسيت كلمة المرور؟', () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) =>
                          ForgotPasswordPage(controller: widget.controller),
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: 9),
            authError(widget.controller),
            AuthSubmitButton(
              label: 'تسجيل الدخول',
              controller: widget.controller,
              onPressed: _login,
            ),
            authDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'ليس لديك حساب؟',
                  style: TextStyle(color: Color(0xFF657674)),
                ),
                authLink(context, 'إنشاء حساب جديد', () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) =>
                          RegisterPage(controller: widget.controller),
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: 14),
            const Text(
              'دخول تجريبي: 202400001  •  Student1',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF8A9993), fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
