import 'package:flutter/material.dart';

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
          "Height: ${height}cm | Weight: ${weight}kg\nCalculated on: $formattedDate",
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
