import 'package:flutter/material.dart';

class ReUsableButton extends StatelessWidget {
  const ReUsableButton({super.key, required this.text, required this.icon});

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 250,
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade400,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: .spaceEvenly,
        children: [
          Icon(icon, color: Colors.white),
          Center(
            child: Text(
              text,
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
