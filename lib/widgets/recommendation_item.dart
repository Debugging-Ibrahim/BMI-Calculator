import 'package:flutter/material.dart';

class RecommendationItem extends StatelessWidget {
  final String header;
  final String desc;

  const RecommendationItem({
    super.key,
    required this.header,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            header,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            desc,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
