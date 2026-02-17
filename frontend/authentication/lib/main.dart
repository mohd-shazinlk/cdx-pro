import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'data/datasources/auth_remote_data_source.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/usecases/auth_usecases.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/screens/forgot_password_screen.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/otp_verification_screen.dart';
import 'presentation/screens/register_screen.dart';
import 'presentation/screens/reset_password_screen.dart';
import 'presentation/screens/splash_screen.dart';

void main() {
  final remoteDataSource = AuthRemoteDataSource();
  final repository = AuthRepositoryImpl(remoteDataSource);
  final useCases = AuthUseCases(repository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(useCases)),
      ],
      child: const AuthApp(),
    ),
  );
}

class AuthApp extends StatelessWidget {
  const AuthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Royal Auth',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkRoyalTheme,
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (_) => const SplashScreen(),
        LoginScreen.routeName: (_) => const LoginScreen(),
        RegisterScreen.routeName: (_) => const RegisterScreen(),
        ForgotPasswordScreen.routeName: (_) => const ForgotPasswordScreen(),
        HomeScreen.routeName: (_) => const HomeScreen(),
        OtpVerificationScreen.routeName: (_) => const OtpVerificationScreen(),
        ResetPasswordScreen.routeName: (_) => const ResetPasswordScreen(),
      },
    );
  }
}
