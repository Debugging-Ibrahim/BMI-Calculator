import 'package:flutter/material.dart';

class RoundedUnitSelectionContainer extends StatelessWidget {
  const RoundedUnitSelectionContainer({
    super.key,
    this.selected = false,
    required this.text,
    required this.onTap,
  });

  final bool selected;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color containerColor = selected
        ? theme.primaryColor
        : (isDark ? Colors.grey.shade800 : Colors.grey.shade300);

    final Color textColor = selected
        ? (isDark ? Colors.black : Colors.white)
        : (isDark ? Colors.white70 : Colors.black54);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        height: 25,
        width: 25,
        decoration: BoxDecoration(
          color: containerColor,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 10,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
