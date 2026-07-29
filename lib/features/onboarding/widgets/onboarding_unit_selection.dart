import 'package:digital_khata/core/providers/unit_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnboardingUnitSelection extends StatelessWidget {
  const OnboardingUnitSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Consumer<UnitProvider>(
      builder: (context, provider, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => provider.toggleUnitSystem(false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 280,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                decoration: BoxDecoration(
                  color: !provider.isImperial
                      ? theme.primaryColor.withValues(alpha: 0.1)
                      : (isDark ? Colors.white.withValues(alpha: 0.03) : Colors.black.withValues(alpha: 0.02)),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: !provider.isImperial ? theme.primaryColor : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.square_foot_rounded,
                      color: !provider.isImperial ? theme.primaryColor : (isDark ? Colors.white30 : Colors.black38),
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Metric System",
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Kilograms (kg) & Centimeters (cm)",
                            style: TextStyle(
                              color: isDark ? Colors.white54 : Colors.black54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!provider.isImperial)
                      Icon(
                        Icons.check_circle_rounded,
                        color: theme.primaryColor,
                        size: 24,
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => provider.toggleUnitSystem(true),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 280,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                decoration: BoxDecoration(
                  color: provider.isImperial
                      ? theme.primaryColor.withValues(alpha: 0.1)
                      : (isDark ? Colors.white.withValues(alpha: 0.03) : Colors.black.withValues(alpha: 0.02)),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: provider.isImperial ? theme.primaryColor : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.scale_rounded,
                      color: provider.isImperial ? theme.primaryColor : (isDark ? Colors.white30 : Colors.black38),
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Imperial System",
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Pounds (lbs) & Feet/Inches (ft/in)",
                            style: TextStyle(
                              color: isDark ? Colors.white54 : Colors.black54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (provider.isImperial)
                      Icon(
                        Icons.check_circle_rounded,
                        color: theme.primaryColor,
                        size: 24,
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Your preferred measurement system",
              style: TextStyle(
                color: isDark ? Colors.white30 : Colors.black38,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        );
      },
    );
  }
}
