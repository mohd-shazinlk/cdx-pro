import 'package:flutter/material.dart';

class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.size = 110});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.3),
        gradient: const LinearGradient(colors: [Color(0xFF5F7CFF), Color(0xFF244CFF)]),
        boxShadow: const [BoxShadow(color: Color(0x803F6AFF), blurRadius: 26, spreadRadius: 1)],
      ),
      child: const Icon(Icons.shield_rounded, color: Colors.white, size: 56),
    );
  }
}
