import 'package:flutter/material.dart';
import 'package:ivy_dex/core/constants/color.dart';

class GradientText extends StatelessWidget {
  final String text;
  const GradientText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [kPrimaryColor, Colors.pinkAccent],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(bounds),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }
}
