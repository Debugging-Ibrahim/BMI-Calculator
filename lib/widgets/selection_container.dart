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
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 25,
        width: 25,
        decoration: BoxDecoration(
          color: selected ? const Color(0xffdafd87) : Colors.grey.shade700,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: selected ? Colors.black : Colors.white70,
              fontSize: 10,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
