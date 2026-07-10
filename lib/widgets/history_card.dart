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
    return Card(
      color: Colors.grey.shade900,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xffdafd87),
          child: Text(
            bmi.toStringAsFixed(1),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        title: Text(
          category,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          "Height: ${height}cm | Weight: ${weight}kg\nCalculated on: $formattedDate",
          style: const TextStyle(fontSize: 12, color: Colors.white70),
        ),
        isThreeLine: true,
      ),
    );
  }
}
