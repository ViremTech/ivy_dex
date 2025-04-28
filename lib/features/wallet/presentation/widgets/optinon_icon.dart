import 'package:flutter/material.dart';
import 'package:ivy_dex/core/constants/gradient_text.dart';
import '../../../../core/constants/color.dart';

class IconOption extends StatelessWidget {
  final IconData? icon;
  final String text;

  const IconOption({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(70),
          ),
          child: ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [kPrimaryColor, Colors.pinkAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(
              Rect.fromLTWH(
                0,
                0,
                bounds.width,
                bounds.height,
              ),
            ),
            child: Icon(
              icon,
              size: 40,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 4),
        GradientText(text: text),
      ],
    );
  }
}
