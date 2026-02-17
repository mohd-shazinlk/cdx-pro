import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/validators.dart';
import '../providers/auth_provider.dart';
import '../widgets/animated_background.dart';
import '../widgets/primary_button.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final ok = await auth.login(_emailCtrl.text.trim(), _passwordCtrl.text);
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login successful')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(auth.errorMessage ?? 'Login failed')));
    }
  }


  @override
  void dispose() {
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
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 40, end: 0),
              duration: const Duration(milliseconds: 550),
              curve: Curves.easeOutCubic,
              builder: (_, offset, child) => Transform.translate(offset: Offset(0, offset), child: child),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 600),
                opacity: 1,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const Text('Welcome Back', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 24),
                        TextFormField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'Email'), validator: Validators.email),
                        const SizedBox(height: 14),
                        TextFormField(controller: _passwordCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Password'), validator: Validators.password),
                        const SizedBox(height: 20),
                        PrimaryButton(text: 'Login', onPressed: _submit, isLoading: auth.isLoading),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(onPressed: () => Navigator.pushNamed(context, ForgotPasswordScreen.routeName), child: const Text('Forgot Password?')),
                        ),
                        TextButton(onPressed: () => Navigator.pushNamed(context, RegisterScreen.routeName), child: const Text('Create account')),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
