import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

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
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 70,
        width: 375,
        decoration: BoxDecoration(
          color: const Color(0xffdafd87),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 8),
            Icon(icon, color: Colors.black),
          ],
        ),
      ),
    );
  }
}
