import 'package:digital_khata/bmi_provider.dart';
import 'package:digital_khata/calculator.dart';
import 'package:digital_khata/widgets/reusable_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  Color decideColor(String? category) {
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
    final bmiProvider = Provider.of<BMIProvider>(context, listen: false);

    final bmi = bmiProvider.bmiResult;
    final category = bmiProvider.category;
    final height = bmiProvider.height;
    final weight = bmiProvider.weight;
    return Scaffold(
      backgroundColor: decideColor(category),
      appBar: AppBar(
        title: const Text("BMI Result", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (height != null &&
                weight != null &&
                bmi != null &&
                category != null) ...[
              Text(
                "Your BMI is: ${bmi.toStringAsFixed(1)}",
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
                onTap: () => Navigator.pop(context),
                child: ReUsableButton(
                  text: "Calculate Again",
                  icon: Icons.arrow_back_ios,
                ),
              ),
            ] else ...[
              const Text("Error: No data found"),
              SizedBox(height: 20),
              InkWell(
                onTap: () => Navigator.pop(context),
                child: ReUsableButton(
                  text: "Go to Calculator",
                  icon: Icons.arrow_back_ios,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
