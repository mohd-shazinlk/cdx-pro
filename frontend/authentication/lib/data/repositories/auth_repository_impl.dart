import '../../core/services/local_storage_service.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/auth_user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource dataSource;
  final LocalStorageService storageService = LocalStorageService();

  AuthRepositoryImpl(this.dataSource);

  @override
  Future<void> register({required String name, required String email, required String password}) {
    return dataSource.post('/register', {'name': name, 'email': email, 'password': password});
  }

  @override
  Future<AuthUser> login({required String email, required String password}) async {
    final payload = await dataSource.post('/login', {'email': email, 'password': password});
    await storageService.saveToken(payload['token'] as String);
    return AuthUserModel.fromJson(payload['user'] as Map<String, dynamic>);
  }

  @override
  Future<void> sendOtp({required String email}) {
    return dataSource.post('/send-otp', {'email': email});
  }

  @override
  Future<void> verifyOtp({required String email, required String otpCode, String context = 'verification'}) {
    return dataSource.post('/verify-otp', {'email': email, 'otpCode': otpCode, 'context': context});
  }

  @override
  Future<void> resetPassword({required String email, required String otpCode, required String newPassword}) {
    return dataSource.post('/reset-password', {'email': email, 'otpCode': otpCode, 'newPassword': newPassword});
  }

  @override
  Future<bool> isLoggedIn() async => (await storageService.getToken()) != null;
}
