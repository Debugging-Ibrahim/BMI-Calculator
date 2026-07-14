import 'package:flutter/material.dart';

class BmiGaugeIndicator extends StatelessWidget {
  final double bmi;

  const BmiGaugeIndicator({super.key, required this.bmi});

  double getPositionPercent(double bmi) {
    double positionPercent = 0.0;
    if (bmi < 18.5) {
      positionPercent = ((bmi - 10) / 8.5 * 0.3).clamp(0.0, 0.3);
    } else if (bmi < 25) {
      positionPercent = 0.3 + ((bmi - 18.5) / 6.5 * 0.3).clamp(0.0, 0.3);
    } else if (bmi < 30) {
      positionPercent = 0.6 + ((bmi - 25) / 5.0 * 0.2).clamp(0.0, 0.2);
    } else {
      positionPercent = 0.8 + ((bmi - 30) / 15.0 * 0.2).clamp(0.0, 0.2);
    }
    return positionPercent;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double trackWidth = constraints.maxWidth;
        final double percent = getPositionPercent(bmi);
        final double dotPosition = percent * (trackWidth - 16);
        return Stack(
          alignment: Alignment.centerLeft,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 30,
                  child: Container(
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xffdafd87),
                      borderRadius: BorderRadius.horizontal(left: Radius.circular(3)),
                    ),
                  ),
                ),
                const SizedBox(width: 2),
                Expanded(
                  flex: 30,
                  child: Container(height: 6, color: Colors.greenAccent),
                ),
                const SizedBox(width: 2),
                Expanded(
                  flex: 20,
                  child: Container(height: 6, color: Colors.orangeAccent),
                ),
                const SizedBox(width: 2),
                Expanded(
                  flex: 20,
                  child: Container(
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.horizontal(right: Radius.circular(3)),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              left: dotPosition,
              child: Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  color: Color(0xffdafd87),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
