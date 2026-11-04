import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../controllers/auth_controller.dart';
import '../../models/auth_requests.dart';
import '../../utils/form_validators.dart';
import 'auth_widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.controller});

  final AuthController controller;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _acceptedTerms = false;
  bool _hidePassword = true;
  bool _hideConfirmation = true;

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    final user = await widget.controller.register(
      RegisterRequest(
        fullName: _nameController.text.trim(),
        academicId: _idController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
    if (!mounted || user == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم إنشاء الحساب بنجاح. يمكنك تسجيل الدخول الآن.'),
        backgroundColor: Color(0xFF287A58),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'إنشاء حساب طالب',
      subtitle: 'أكمل بياناتك الأكاديمية لبدء استخدام خدمات الجامعة.',
      showBack: true,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthField(
              label: 'الاسم الكامل',
              hint: 'كما يظهر في السجل الأكاديمي',
              controller: _nameController,
              validator: FormValidators.fullName,
              icon: Icons.person_outline,
            ),
            AuthField(
              label: 'الرقم الأكاديمي',
              hint: '9 أو 10 أرقام',
              controller: _idController,
              validator: FormValidators.academicId,
              icon: Icons.numbers_outlined,
              keyboardType: TextInputType.number,
              textDirection: TextDirection.ltr,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              maxLength: 10,
            ),
            AuthField(
              label: 'البريد الجامعي',
              hint: 'name@university.edu',
              controller: _emailController,
              validator: FormValidators.email,
              icon: Icons.mail_outline,
              keyboardType: TextInputType.emailAddress,
              textDirection: TextDirection.ltr,
            ),
            AuthField(
              label: 'كلمة المرور',
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
              label: 'تأكيد كلمة المرور',
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
            FormField<bool>(
              initialValue: _acceptedTerms,
              validator: (accepted) =>
                  accepted == true ? null : 'الموافقة على الشروط مطلوبة',
              builder: (field) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    value: field.value ?? false,
                    activeColor: const Color(0xFF173B3F),
                    onChanged: (value) {
                      _acceptedTerms = value ?? false;
                      field.didChange(_acceptedTerms);
                    },
                    title: const Text(
                      'أوافق على اللوائح والشروط الأكاديمية',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                  if (field.errorText != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Text(
                        field.errorText!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            authError(widget.controller),
            AuthSubmitButton(
              label: 'إنشاء الحساب',
              controller: widget.controller,
              onPressed: _register,
            ),
          ],
        ),
      ),
    );
  }
}
