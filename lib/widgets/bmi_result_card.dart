import 'package:digital_khata/widgets/bmi_gauge_indicator.dart';
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
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Your BMI is",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
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
            style: const TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          BmiGaugeIndicator(bmi: bmi),
        ],
      ),
    );
  }
}
