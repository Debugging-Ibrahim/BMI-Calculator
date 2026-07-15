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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: isHighlight ? const Color(0xffdafd87).withOpacity(0.1) : Colors.grey.shade900,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isHighlight ? const Color(0xffdafd87) : Colors.transparent,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: isHighlight ? const Color(0xffdafd87) : Colors.white54,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
