class LoginRequest {
  const LoginRequest({
    required this.identifier,
    required this.password,
    required this.rememberMe,
  });

  final String identifier;
  final String password;
  final bool rememberMe;
}

class RegisterRequest {
  const RegisterRequest({
    required this.fullName,
    required this.academicId,
    required this.email,
    required this.password,
  });

  final String fullName;
  final String academicId;
  final String email;
  final String password;
}

class PasswordResetRequest {
  const PasswordResetRequest({required this.identifier});

  final String identifier;
}

class ResetPasswordRequest {
  const ResetPasswordRequest({required this.code, required this.newPassword});

  final String code;
  final String newPassword;
}
