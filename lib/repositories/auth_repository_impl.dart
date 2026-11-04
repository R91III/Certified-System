import '../models/auth_requests.dart';
import '../models/user_model.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Map<String, UserModel> _users = {
    '202400001': const UserModel(
      fullName: 'طالب الجامعة',
      academicId: '202400001',
      email: 'student@university.edu',
      password: 'Student1',
    ),
  };

  String? _pendingResetIdentifier;

  Future<void> _simulateNetwork() =>
      Future<void>.delayed(const Duration(milliseconds: 700));

  @override
  Future<UserModel> login(LoginRequest request) async {
    await _simulateNetwork();
    final user =
        _users[request.identifier] ??
        _users.values
            .where((item) => item.email == request.identifier)
            .firstOrNull;
    if (user == null || user.password != request.password) {
      throw const AuthException('المعرف أو كلمة المرور غير صحيحة');
    }
    return user;
  }

  @override
  Future<UserModel> register(RegisterRequest request) async {
    await _simulateNetwork();
    if (_users.containsKey(request.academicId) ||
        _users.values.any((user) => user.email == request.email)) {
      throw const AuthException('الرقم الأكاديمي أو البريد مسجل مسبقاً');
    }
    final user = UserModel(
      fullName: request.fullName,
      academicId: request.academicId,
      email: request.email,
      password: request.password,
    );
    _users[request.academicId] = user;
    return user;
  }

  @override
  Future<void> sendPasswordResetCode(PasswordResetRequest request) async {
    await _simulateNetwork();
    final user =
        _users[request.identifier] ??
        _users.values
            .where((item) => item.email == request.identifier)
            .firstOrNull;
    if (user == null) throw const AuthException('لم نعثر على حساب بهذا المعرف');
    _pendingResetIdentifier = user.academicId;
  }

  @override
  Future<void> resetPassword(ResetPasswordRequest request) async {
    await _simulateNetwork();
    if (request.code != '123456' || _pendingResetIdentifier == null) {
      throw const AuthException('رمز التحقق غير صحيح أو منتهي الصلاحية');
    }
    final oldUser = _users[_pendingResetIdentifier];
    if (oldUser == null) throw const AuthException('تعذر العثور على الحساب');
    _users[_pendingResetIdentifier!] = UserModel(
      fullName: oldUser.fullName,
      academicId: oldUser.academicId,
      email: oldUser.email,
      password: request.newPassword,
    );
    _pendingResetIdentifier = null;
  }
}

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}
