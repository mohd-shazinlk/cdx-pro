import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../widgets/animated_background.dart';
import '../widgets/brand_logo.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600))..forward();
    // Keep branding animation visible for 3 seconds, then check login state.
    Timer(const Duration(seconds: 3), _goNext);
  }

  Future<void> _goNext() async {
    final isLoggedIn = await context.read<AuthProvider>().checkLoginState();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, isLoggedIn ? HomeScreen.routeName : LoginScreen.routeName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackground(
        child: Center(
          child: FadeTransition(
            opacity: CurvedAnimation(parent: _controller, curve: Curves.easeIn),
            child: ScaleTransition(
              scale: Tween(begin: 0.72, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut)),
              child: const BrandLogo(),
            ),
          ),
        ),
      ),
    );
  }
}
