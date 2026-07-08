import 'package:digital_khata/calculator.dart';
import 'package:digital_khata/widgets/reusable_button.dart';
import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    super.key,
    required this.height,
    required this.weight,
    required this.bmiResult,
    required this.category,
  });

  final String height;
  final String weight;
  final double bmiResult;
  final String category;

  Color decideColor() {
    if (category == 'Underweight') {
      return Colors.lightBlue;
    } else if (category == 'Normal Weight') {
      return Colors.lightGreen;
    } else if (category == 'Overweight') {
      return Colors.orange;
    } else if (category == 'Obesity') {
      return Colors.red;
    } else {
      return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: decideColor(),
      appBar: AppBar(
        title: const Text("BMI Result", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Your BMI is: ${bmiResult.toStringAsFixed(1)}",
              style: const TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Category: $category",
              style: const TextStyle(
                fontSize: 20,
                color: Colors.amber,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              "Height: $height cm  |  Weight: $weight kg",
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),

            const SizedBox(height: 30),
            InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CalculatorScreen()),
              ),
              child: ReUsableButton(
                text: "Calculate Again",
                icon: Icons.arrow_back_ios,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
