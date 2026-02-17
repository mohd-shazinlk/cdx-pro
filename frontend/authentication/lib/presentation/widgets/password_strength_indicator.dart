import 'package:flutter/material.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  final String password;
  const PasswordStrengthIndicator({super.key, required this.password});

  int get _score {
    var score = 0;
    if (password.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) score++;
    return score;
  }

  @override
  Widget build(BuildContext context) {
    final score = _score;
    final width = (score / 4).clamp(0, 1).toDouble();
    final color = [Colors.red, Colors.orange, Colors.yellow, Colors.lightGreen, Colors.green][score];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) => Container(
            width: double.infinity,
            height: 6,
            decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(99)),
            child: Align(
              alignment: Alignment.centerLeft,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: constraints.maxWidth * width,
                decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(99)),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          ['Very weak', 'Weak', 'Medium', 'Strong', 'Very strong'][score],
          style: TextStyle(color: color, fontSize: 12),
        )
      ],
    );
  }
}
