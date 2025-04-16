import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final Widget? suffixIcon;
  final String text;
  final void Function()? onTap;
  final bool obscureText;
  const PasswordField(
      {super.key,
      required this.text,
      required this.suffixIcon,
      required this.onTap,
      required this.obscureText,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: GoogleFonts.spaceGrotesk(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      decoration: InputDecoration(
        labelText: text,
        suffixIcon: GestureDetector(
          onTap: onTap,
          child: suffixIcon,
        ),
      ),
    );
  }
}
