import '../entities/auth_user.dart';

abstract class AuthRepository {
  Future<void> register({required String name, required String email, required String password});
  Future<AuthUser> login({required String email, required String password});
  Future<void> sendOtp({required String email});
  Future<void> verifyOtp({required String email, required String otpCode, String context});
  Future<void> resetPassword({required String email, required String otpCode, required String newPassword});
  Future<bool> isLoggedIn();
}
