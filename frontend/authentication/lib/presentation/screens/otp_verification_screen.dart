import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../widgets/animated_background.dart';
import '../widgets/primary_button.dart';
import 'login_screen.dart';
import 'reset_password_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  static const routeName = '/verify-otp';
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _otpCtrl = TextEditingController();

  Future<void> _submit(String contextFlow) async {
    final auth = context.read<AuthProvider>();
    final ok = await auth.verifyOtp(_otpCtrl.text.trim(), context: contextFlow);
    if (!mounted) return;
    if (ok) {
      if (contextFlow == 'reset') {
        Navigator.pushNamed(context, ResetPasswordScreen.routeName, arguments: _otpCtrl.text.trim());
      } else {
        Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName, (_) => false);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(auth.errorMessage ?? 'OTP verification failed')));
    }
  }


  @override
  void dispose() {
    _otpCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final contextFlow = (ModalRoute.of(context)?.settings.arguments as String?) ?? 'verification';

    return Scaffold(
      body: AnimatedBackground(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Verify OTP', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 14),
                  TextField(controller: _otpCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Enter 6-digit OTP')),
                  const SizedBox(height: 20),
                  PrimaryButton(text: 'Verify OTP', onPressed: () => _submit(contextFlow), isLoading: auth.isLoading),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
