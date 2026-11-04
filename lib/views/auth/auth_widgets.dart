import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../controllers/auth_controller.dart';

const _ink = Color(0xFF173B3F);
const _rust = Color(0xFFC76845);

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.showBack = false,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 22),
              decoration: const BoxDecoration(
                color: _ink,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(22),
                ),
              ),
              child: Row(
                children: [
                  if (showBack) ...[
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      tooltip: 'رجوع',
                      color: Colors.white,
                      icon: const Icon(Icons.arrow_forward),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Container(
                    width: 43,
                    height: 43,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.school_outlined,
                      color: Color(0xFFE7B47F),
                    ),
                  ),
                  const SizedBox(width: 13),
                  const Text(
                    'بوابة الطالب',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'الخدمات الأكاديمية',
                    style: TextStyle(color: Color(0xFFC5D2CE), fontSize: 12),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 30, 24, 28),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 470),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: _ink,
                            fontSize: 27,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            color: Color(0xFF657674),
                            fontSize: 14,
                            height: 1.7,
                          ),
                        ),
                        const SizedBox(height: 25),
                        child,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthField extends StatelessWidget {
  const AuthField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    required this.validator,
    this.icon,
    this.keyboardType,
    this.obscureText = false,
    this.suffix,
    this.textDirection,
    this.inputFormatters,
    this.maxLength,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final IconData? icon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffix;
  final TextDirection? textDirection;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              label,
              style: const TextStyle(
                color: _ink,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          TextFormField(
            controller: controller,
            validator: validator,
            obscureText: obscureText,
            keyboardType: keyboardType,
            textDirection: textDirection,
            inputFormatters: inputFormatters,
            maxLength: maxLength,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Color(0xFF9AA7A2)),
              prefixIcon: icon == null ? null : Icon(icon, size: 20),
              suffixIcon: suffix,
            ),
          ),
        ],
      ),
    );
  }
}

class AuthSubmitButton extends StatelessWidget {
  const AuthSubmitButton({
    super.key,
    required this.label,
    required this.controller,
    required this.onPressed,
  });

  final String label;
  final AuthController controller;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) => SizedBox(
        height: 52,
        child: FilledButton(
          onPressed: controller.isLoading ? null : onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: _ink,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: controller.isLoading
              ? const SizedBox(
                  width: 21,
                  height: 21,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
        ),
      ),
    );
  }
}

Widget authError(AuthController controller) {
  return AnimatedBuilder(
    animation: controller,
    builder: (context, _) {
      if (controller.errorMessage == null) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Text(
          controller.errorMessage!,
          style: const TextStyle(color: Color(0xFFB34331), fontSize: 13),
        ),
      );
    },
  );
}

Widget authLink(BuildContext context, String label, VoidCallback onPressed) {
  return TextButton(
    onPressed: onPressed,
    style: TextButton.styleFrom(foregroundColor: _rust),
    child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
  );
}

Widget authDivider() => const Padding(
  padding: EdgeInsets.symmetric(vertical: 17),
  child: Divider(color: Color(0xFFE0E5DF)),
);
