import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final Color? color;
  final String text;
  final void Function()? onTap;
  const ButtonWidget(
      {this.color, required this.text, super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(
              12,
            )),
        width: double.infinity,
        height: 60,
        child: Center(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }
}
