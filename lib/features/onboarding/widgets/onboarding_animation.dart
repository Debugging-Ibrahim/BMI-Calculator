import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OnboardingAnimation extends StatelessWidget {
  final String assetPath;

  const OnboardingAnimation({
    super.key,
    required this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 280, maxWidth: 280),
      child: Lottie.asset(
        assetPath,
        fit: BoxFit.contain,
      ),
    );
  }
}
