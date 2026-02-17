import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class AuthUseCases {
  final AuthRepository repository;
  AuthUseCases(this.repository);

  Future<void> register({required String name, required String email, required String password}) {
    return repository.register(name: name, email: email, password: password);
  }

  Future<AuthUser> login({required String email, required String password}) {
    return repository.login(email: email, password: password);
  }

  Future<void> sendOtp({required String email}) => repository.sendOtp(email: email);

  Future<void> verifyOtp({required String email, required String otpCode, String context = 'verification'}) {
    return repository.verifyOtp(email: email, otpCode: otpCode, context: context);
  }

  Future<void> resetPassword({required String email, required String otpCode, required String newPassword}) {
    return repository.resetPassword(email: email, otpCode: otpCode, newPassword: newPassword);
  }

  Future<bool> isLoggedIn() => repository.isLoggedIn();
}
