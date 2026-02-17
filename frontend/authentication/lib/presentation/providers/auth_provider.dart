import 'package:flutter/material.dart';

import '../../domain/usecases/auth_usecases.dart';

class AuthProvider extends ChangeNotifier {
  final AuthUseCases _useCases;

  AuthProvider(this._useCases);

  bool isLoading = false;
  String? errorMessage;
  String? flowEmail;

  Future<bool> checkLoginState() => _useCases.isLoggedIn();

  Future<bool> login(String email, String password) async {
    return _execute(() async {
      await _useCases.login(email: email, password: password);
      return true;
    });
  }

  Future<bool> register(String name, String email, String password) async {
    return _execute(() async {
      await _useCases.register(name: name, email: email, password: password);
      flowEmail = email;
      return true;
    });
  }

  Future<bool> sendResetOtp(String email) async {
    return _execute(() async {
      await _useCases.sendOtp(email: email);
      flowEmail = email;
      return true;
    });
  }

  Future<bool> verifyOtp(String otpCode, {String context = 'reset'}) async {
    return _execute(() async {
      if (flowEmail == null) throw Exception('Email context missing');
      await _useCases.verifyOtp(email: flowEmail!, otpCode: otpCode, context: context);
      return true;
    });
  }

  Future<bool> resetPassword(String otpCode, String newPassword) async {
    return _execute(() async {
      if (flowEmail == null) throw Exception('Email context missing');
      await _useCases.resetPassword(email: flowEmail!, otpCode: otpCode, newPassword: newPassword);
      return true;
    });
  }

  Future<bool> _execute(Future<bool> Function() action) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      return await action();
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
