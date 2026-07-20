import 'package:flutter/material.dart';

class ReUsableButton extends StatelessWidget {
  const ReUsableButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
  });

  final String text;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foregroundColor = theme.brightness == Brightness.dark ? Colors.black : Colors.white;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 70,
        width: 375,
        decoration: BoxDecoration(
          color: theme.primaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: foregroundColor,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              icon,
              color: foregroundColor,
            ),
          ],
        ),
      ),
    );
  }
}
