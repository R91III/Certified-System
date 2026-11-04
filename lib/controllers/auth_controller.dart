import 'package:flutter/foundation.dart';

import '../models/auth_requests.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

class AuthController extends ChangeNotifier {
  AuthController(this._repository);

  final AuthRepository _repository;
  bool _isLoading = false;
  String? _errorMessage;
  UserModel? _currentUser;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserModel? get currentUser => _currentUser;

  Future<UserModel?> login(LoginRequest request) async {
    return _run(() async => _currentUser = await _repository.login(request));
  }

  Future<UserModel?> register(RegisterRequest request) async {
    return _run(() => _repository.register(request));
  }

  Future<bool> sendPasswordResetCode(PasswordResetRequest request) async {
    final result = await _run(() async {
      await _repository.sendPasswordResetCode(request);
      return true;
    });
    return result != null;
  }

  Future<bool> resetPassword(ResetPasswordRequest request) async {
    final result = await _run(() async {
      await _repository.resetPassword(request);
      return true;
    });
    return result != null;
  }

  Future<T?> _run<T>(Future<T> Function() action) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      return await action();
    } catch (error) {
      _errorMessage = error.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
