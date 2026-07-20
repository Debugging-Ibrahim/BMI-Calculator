import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class WeightAgeContainer extends StatelessWidget {
  const WeightAgeContainer({
    super.key,
    required this.textUp,
    required this.textBtm,
    required this.value,
    required this.onIncrement,
    required this.onDecrement,
  });

  final String textUp;
  final String textBtm;
  final int value;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final btnIconColor = isDark ? Colors.black : Colors.white;

    return Container(
      height: 175,
      width: 175,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: theme.cardColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Text(
            textUp,
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: onDecrement,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Iconsax.minus, color: btnIconColor),
                ),
              ),
              Text(
                value.toString(),
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              InkWell(
                onTap: onIncrement,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Iconsax.add, color: btnIconColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            textBtm,
            style: TextStyle(
              color: isDark ? Colors.white30 : Colors.black38,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
