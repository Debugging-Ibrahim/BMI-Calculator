import 'package:flutter/material.dart';

class GenderSelectionCard extends StatelessWidget {
  final String gender;
  final bool isSelected;
  final IconData icon;
  final VoidCallback onTap;

  const GenderSelectionCard({
    super.key,
    required this.gender,
    required this.isSelected,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color cardBackground = isSelected
        ? theme.primaryColor.withValues(alpha: 0.15)
        : theme.cardColor;

    final Color foregroundColor = isSelected
        ? theme.colorScheme.onSurface
        : (isDark ? Colors.white60 : Colors.black54);

    final Color iconColor = isSelected
        ? theme.primaryColor
        : (isDark ? Colors.white54 : Colors.black38);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 200,
        width: 175,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: cardBackground,
          border: Border.all(
            color: isSelected ? theme.primaryColor : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 35,
            ),
            const SizedBox(height: 30),
            Text(
              gender.toUpperCase(),
              style: TextStyle(
                color: foregroundColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
