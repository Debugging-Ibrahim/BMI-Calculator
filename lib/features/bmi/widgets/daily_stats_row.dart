import 'package:flutter/material.dart';

class DailyStatsRow extends StatelessWidget {
  final double? bmr;
  final double? tdee;
  final double? targetCalories;

  const DailyStatsRow({
    super.key,
    required this.bmr,
    required this.tdee,
    required this.targetCalories,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            title: 'BMR',
            value: '${bmr?.toStringAsFixed(0) ?? "0"} kcal',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            title: 'TDEE',
            value: '${tdee?.toStringAsFixed(0) ?? "0"} kcal',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            title: 'Target',
            value: '${targetCalories?.toStringAsFixed(0) ?? "0"} kcal',
            isHighlight: true,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final bool isHighlight;

  const _StatCard({
    required this.title,
    required this.value,
    this.isHighlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color cardColor = isHighlight
        ? theme.primaryColor.withValues(alpha: 0.15)
        : theme.cardColor;

    final Color titleColor = isHighlight
        ? theme.primaryColor
        : (isDark ? Colors.white54 : Colors.black54);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isHighlight ? theme.primaryColor : Colors.transparent,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: titleColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
