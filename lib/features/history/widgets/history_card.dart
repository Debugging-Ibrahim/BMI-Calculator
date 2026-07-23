import 'package:digital_khata/core/providers/unit_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryCard extends StatelessWidget {
  final double bmi;
  final String category;
  final String height;
  final String weight;
  final String formattedDate;

  const HistoryCard({
    super.key,
    required this.bmi,
    required this.category,
    required this.height,
    required this.weight,
    required this.formattedDate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final unitProvider = context.watch<UnitProvider>();

    final double? heightCm = double.tryParse(height);
    final double? weightKg = double.tryParse(weight);

    String heightDisplay = "${height}cm";
    String weightDisplay = "${weight}kg";

    if (unitProvider.isImperial) {
      if (heightCm != null) {
        final totalInches = heightCm / 2.54;
        final feet = (totalInches / 12).floor();
        final inches = (totalInches % 12).round();
        heightDisplay = "${feet}ft ${inches}in";
      }
      if (weightKg != null) {
        final lbs = weightKg * 2.20462;
        weightDisplay = "${lbs.toStringAsFixed(0)}lbs";
      }
    } else {
      if (heightCm != null) {
        heightDisplay = "${heightCm.toStringAsFixed(0)}cm";
      }
      if (weightKg != null) {
        weightDisplay = "${weightKg.toStringAsFixed(0)}kg";
      }
    }

    return Card(
      color: theme.cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.primaryColor,
          child: Text(
            bmi.toStringAsFixed(1),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.black : Colors.white,
            ),
          ),
        ),
        title: Text(
          category,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          "Height: $heightDisplay | Weight: $weightDisplay\nCalculated on: $formattedDate",
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
        isThreeLine: true,
      ),
    );
  }
}
