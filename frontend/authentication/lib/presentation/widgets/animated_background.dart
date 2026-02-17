import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class AnimatedBackground extends StatelessWidget {
  final Widget child;
  const AnimatedBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.appGradient),
      child: SafeArea(child: child),
    );
  }
}
