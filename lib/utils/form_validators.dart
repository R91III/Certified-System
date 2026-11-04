class FormValidators {
  FormValidators._();

  static String? identifier(String? value) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) return 'هذا الحقل مطلوب';
    if (input.contains('@')) {
      return email(input);
    }
    if (!RegExp(r'^\d{5,}$').hasMatch(input)) {
      return 'أدخل بريداً صحيحاً أو معرفاً أكاديمياً من 5 أرقام على الأقل';
    }
    return null;
  }

  static String? loginPassword(String? value) {
    final input = value ?? '';
    if (input.isEmpty) return 'كلمة المرور مطلوبة';
    if (input.length < 6) return 'أدخل 6 محارف على الأقل';
    return null;
  }

  static String? fullName(String? value) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) return 'الاسم الكامل مطلوب';
    if (input.length < 3) return 'أدخل 3 محارف على الأقل';
    return null;
  }

  static String? academicId(String? value) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) return 'الرقم الأكاديمي مطلوب';
    if (!RegExp(r'^\d{9,10}$').hasMatch(input)) {
      return 'أدخل 9 أو 10 أرقام';
    }
    return null;
  }

  static String? email(String? value) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) return 'البريد الجامعي مطلوب';
    if (!RegExp(r'^[\w.+-]+@[\w-]+(?:\.[\w-]+)+$').hasMatch(input)) {
      return 'أدخل بريداً إلكترونياً صحيحاً';
    }
    return null;
  }

  static String? strongPassword(String? value) {
    final input = value ?? '';
    if (input.isEmpty) return 'كلمة المرور مطلوبة';
    if (input.length < 8 ||
        !RegExp(r'\d').hasMatch(input) ||
        !RegExp(r'[A-Z]').hasMatch(input)) {
      return '8 محارف على الأقل، مع رقم وحرف كبير';
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) return 'تأكيد كلمة المرور مطلوب';
    if (value != password) return 'كلمتا المرور غير متطابقتين';
    return null;
  }

  static String? otp(String? value) {
    final input = value?.trim() ?? '';
    if (!RegExp(r'^\d{6}$').hasMatch(input)) {
      return 'أدخل رمزاً مكوناً من 6 أرقام';
    }
    return null;
  }
}
