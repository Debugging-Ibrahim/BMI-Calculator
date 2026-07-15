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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 200,
        width: 175,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isSelected ? const Color(0xff262826) : Colors.grey.shade900,
          border: isSelected
              ? Border.all(
                  color: const Color(0xffdafd87),
                  width: 1.5,
                )
              : Border.all(color: Colors.transparent),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xffdafd87) : Colors.white60,
              size: 35,
            ),
            const SizedBox(height: 30),
            Text(
              gender.toUpperCase(),
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white60,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
