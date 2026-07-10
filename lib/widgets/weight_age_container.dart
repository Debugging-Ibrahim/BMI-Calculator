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
    return Container(
      height: 175,
      width: 175,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade900,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(textUp, style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: onDecrement,
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xffdafd87),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Iconsax.minus, color: Colors.black),
                ),
              ),
              Text(
                value.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: onIncrement,
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xffdafd87),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Iconsax.add, color: Colors.black),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),
          Text(textBtm, style: TextStyle(color: Colors.grey[400])),
        ],
      ),
    );
  }
}
