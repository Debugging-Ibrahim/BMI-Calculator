import 'package:digital_khata/features/bmi/widgets/bmi_gauge_indicator.dart';
import 'package:digital_khata/l10n/app_localizations.dart';
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

  String _getLocalizedCategory(String cat, AppLocalizations? l10n) {
    final lower = cat.toLowerCase();
    if (lower.contains('underweight')) {
      return l10n?.underweight ?? cat;
    } else if (lower.contains('normal') || lower.contains('healthy')) {
      return l10n?.normalWeight ?? cat;
    } else if (lower.contains('overweight')) {
      return l10n?.overweight ?? cat;
    } else if (lower.contains('obese') || lower.contains('obesity')) {
      return l10n?.obesity ?? cat;
    }
    return cat;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final localizedCat = _getLocalizedCategory(category, l10n);

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
                l10n?.yourBmiIs ?? "Your BMI is",
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white70 : Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                localizedCat,
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
