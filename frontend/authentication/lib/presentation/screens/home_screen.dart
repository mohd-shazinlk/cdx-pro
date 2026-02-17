import 'package:flutter/material.dart';

import '../widgets/animated_background.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AnimatedBackground(
        child: Center(
          child: Text('You are logged in', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
