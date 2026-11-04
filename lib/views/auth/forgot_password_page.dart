import 'package:flutter/material.dart';

import '../../controllers/auth_controller.dart';
import '../../models/auth_requests.dart';
import '../../utils/form_validators.dart';
import 'auth_widgets.dart';
import 'reset_password_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key, required this.controller});

  final AuthController controller;

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();

  @override
  void dispose() {
    _identifierController.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await widget.controller.sendPasswordResetCode(
      PasswordResetRequest(identifier: _identifierController.text.trim()),
    );
    if (!mounted || !success) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم إرسال رمز التحقق إلى بيانات حسابك'),
        backgroundColor: Color(0xFF287A58),
      ),
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => ResetPasswordPage(controller: widget.controller),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'استعادة كلمة المرور',
      subtitle: 'أدخل بيانات حسابك لنساعدك على استعادة الوصول.',
      showBack: true,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(17),
              decoration: BoxDecoration(
                color: const Color(0xFFE9F0EA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFD8E4DA)),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.mark_email_read_outlined,
                    color: Color(0xFF287A58),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'سنرسل رمز تحقق إلى وسيلة التواصل المرتبطة بحسابك. استخدم الرمز لتعيين كلمة مرور جديدة.',
                      style: TextStyle(
                        color: Color(0xFF31574A),
                        fontSize: 13,
                        height: 1.7,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'في المحاكاة التعليمية، رمز التحقق هو 123456.',
              style: TextStyle(color: Color(0xFF657674), fontSize: 12),
            ),
            const SizedBox(height: 24),
            AuthField(
              label: 'البريد أو الرقم الأكاديمي',
              hint: 'أدخل البريد أو المعرف الأكاديمي',
              controller: _identifierController,
              validator: FormValidators.identifier,
              icon: Icons.person_search_outlined,
              keyboardType: TextInputType.emailAddress,
              textDirection: TextDirection.ltr,
            ),
            authError(widget.controller),
            AuthSubmitButton(
              label: 'إرسال رمز التحقق',
              controller: widget.controller,
              onPressed: _sendCode,
            ),
            const SizedBox(height: 10),
            Center(
              child: authLink(context, 'العودة لتسجيل الدخول', () {
                Navigator.of(context).pop();
              }),
            ),
          ],
        ),
      ),
    );
  }
}
