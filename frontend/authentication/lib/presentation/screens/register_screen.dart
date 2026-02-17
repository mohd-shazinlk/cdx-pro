import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/validators.dart';
import '../providers/auth_provider.dart';
import '../widgets/animated_background.dart';
import '../widgets/password_strength_indicator.dart';
import '../widgets/primary_button.dart';
import 'otp_verification_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final ok = await auth.register(_nameCtrl.text.trim(), _emailCtrl.text.trim(), _passwordCtrl.text);
    if (!mounted) return;
    if (ok) {
      Navigator.pushNamed(context, OtpVerificationScreen.routeName, arguments: 'verification');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(auth.errorMessage ?? 'Register failed')));
    }
  }


  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
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
              constraints: const BoxConstraints(maxWidth: 480),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text('Create Account', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 24),
                    TextFormField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Full Name'), validator: (v) => v == null || v.isEmpty ? 'Name required' : null),
                    const SizedBox(height: 14),
                    TextFormField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'Email'), validator: Validators.email),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _passwordCtrl,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Password'),
                      validator: Validators.password,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 10),
                    PasswordStrengthIndicator(password: _passwordCtrl.text),
                    const SizedBox(height: 20),
                    PrimaryButton(text: 'Register & Send OTP', onPressed: _submit, isLoading: auth.isLoading),
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
