import 'package:digital_khata/bmi_provider.dart';
import 'package:digital_khata/result_screen.dart';
import 'package:digital_khata/widgets/input_field.dart';
import 'package:digital_khata/widgets/reusable_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final heightcontroller = TextEditingController();
  final weightcontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // void navigateToResultScreen() {
  //   final double? height = double.tryParse(heightcontroller.text);
  //   final double? weight = double.tryParse(weightcontroller.text);

  //   if (height != null && weight != null && height > 0) {
  //     final double heightInMeters = height / 100;
  //     final double bmi = weight / (heightInMeters * heightInMeters);

  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => ResultScreen(
  //           bmiResult: bmi,
  //           category: getBMICategory(bmi),
  //           height: height.toString(),
  //           weight: weight.toString(),

  //         ),
  //       ),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Please enter valid height and weight values'),
  //       ),
  //     );
  //   }
  // }

  @override
  void dispose() {
    heightcontroller.dispose();
    weightcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text(
          "BMI Calculator",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 30),
                InputFieldBMI(
                  text: "What is your Height (in cm)?",
                  controller: heightcontroller,
                ),
                const SizedBox(height: 30),
                InputFieldBMI(
                  text: "What is your Weight (in kg)?",
                  controller: weightcontroller,
                  isheight: false,
                ),
                const SizedBox(height: 50),
                InkWell(
                  onTap: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      context.read<BMIProvider>().calculateAndSave(
                        heightcontroller.text,
                        weightcontroller.text,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ResultScreen()),
                      );
                    }
                  },
                  child: ReUsableButton(
                    text: 'Calculate',
                    icon: Icons.calculate,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
