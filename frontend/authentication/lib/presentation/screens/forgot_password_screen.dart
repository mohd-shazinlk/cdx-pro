import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/validators.dart';
import '../providers/auth_provider.dart';
import '../widgets/animated_background.dart';
import '../widgets/primary_button.dart';
import 'otp_verification_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const routeName = '/forgot-password';
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final ok = await auth.sendResetOtp(_emailCtrl.text.trim());
    if (!mounted) return;
    if (ok) {
      Navigator.pushNamed(context, OtpVerificationScreen.routeName, arguments: 'reset');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(auth.errorMessage ?? 'Failed to send OTP')));
    }
  }


  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      body: AnimatedBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text('Forgot Password', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    TextFormField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'Email'), validator: Validators.email),
                    const SizedBox(height: 20),
                    PrimaryButton(text: 'Send OTP', onPressed: _submit, isLoading: auth.isLoading),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
