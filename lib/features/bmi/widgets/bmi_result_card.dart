import 'package:digital_khata/features/bmi/widgets/bmi_gauge_indicator.dart';
import 'package:flutter/material.dart';

class BmiResultCard extends StatelessWidget {
  final double bmi;
  final String category;
  final Color categoryColor;

  const BmiResultCard({
    super.key,
    required this.bmi,
    required this.category,
    required this.categoryColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Your BMI is",
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white70 : Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                category,
                style: TextStyle(
                  fontSize: 16,
                  color: categoryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            bmi.toStringAsFixed(1),
            style: TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 20),
          BmiGaugeIndicator(bmi: bmi),
        ],
      ),
    );
  }
}
