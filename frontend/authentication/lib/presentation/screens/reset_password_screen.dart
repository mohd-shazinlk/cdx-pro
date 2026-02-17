import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/validators.dart';
import '../providers/auth_provider.dart';
import '../widgets/animated_background.dart';
import '../widgets/primary_button.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const routeName = '/reset-password';
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordCtrl = TextEditingController();

  Future<void> _submit(String otpCode) async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final ok = await auth.resetPassword(otpCode, _passwordCtrl.text);
    if (!mounted) return;
    if (ok) {
      Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName, (_) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(auth.errorMessage ?? 'Reset failed')));
    }
  }


  @override
  void dispose() {
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final otpCode = (ModalRoute.of(context)?.settings.arguments as String?) ?? '';

    return Scaffold(
      body: AnimatedBackground(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Reset Password', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordCtrl,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'New Password'),
                      validator: Validators.password,
                    ),
                    const SizedBox(height: 20),
                    PrimaryButton(text: 'Update Password', onPressed: () => _submit(otpCode), isLoading: auth.isLoading),
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
