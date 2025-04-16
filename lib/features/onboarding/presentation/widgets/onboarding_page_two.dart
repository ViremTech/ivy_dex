import 'package:flutter/material.dart';

import '../../../../core/constants/color.dart';
import '../../../../core/widgets/button_widget.dart';

class OnboardingPagesTwo extends StatelessWidget {
  final String heading;
  final String subHeading;
  final String imageUrl;
  final void Function()? onTapToContinue;

  const OnboardingPagesTwo({
    super.key,
    required this.heading,
    required this.subHeading,
    required this.imageUrl,
    required this.onTapToContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(
              30.0,
            ),
            child: Image.asset(imageUrl),
          ),
          Text(
            heading,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            subHeading,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          SizedBox(
            height: 70,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: ButtonWidget(
              onTap: onTapToContinue,
              text: 'Continue',
              color: kPrimaryColor,
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
