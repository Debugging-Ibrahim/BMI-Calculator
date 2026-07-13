import 'package:digital_khata/auth/login_screen.dart';
import 'package:digital_khata/bmi_provider.dart';
import 'package:digital_khata/widgets/bmi_result_card.dart';
import 'package:digital_khata/widgets/recommendation_item.dart';
import 'package:digital_khata/widgets/reusable_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  Color getCategoryColor(String? category) {
    if (category == 'Underweight') {
      return const Color(0xffdafd87);
    } else if (category == 'Normal Weight') {
      return Colors.greenAccent;
    } else if (category == 'Overweight') {
      return Colors.orangeAccent;
    } else if (category == 'Obesity') {
      return Colors.redAccent;
    } else {
      return Colors.white;
    }
  }

  List<Map<String, String>> getRecommendations(String? category) {
    if (category == 'Underweight') {
      return [
        {
          'header': 'Eat More Calories:',
          'desc': 'Consume more high-calorie foods like nuts, avocados, and healthy oils.'
        },
        {
          'header': 'Portion Size:',
          'desc': 'Increase portion sizes during meals to support healthy weight gain.'
        },
        {
          'header': 'Choose Nutrient-Rich Foods:',
          'desc': 'Focus on foods rich in protein (lean meats, fish, eggs, legumes) and complex carbohydrates for sustained energy.'
        }
      ];
    } else if (category == 'Normal Weight' || category == 'Healthy Weight') {
      return [
        {
          'header': 'Maintain Balance:',
          'desc': 'Focus on a well-rounded diet with a mix of proteins, complex carbs, and healthy fats.'
        },
        {
          'header': 'Stay Hydrated:',
          'desc': 'Drink at least 8-10 glasses of water daily to maintain metabolic efficiency.'
        },
        {
          'header': 'Active Lifestyle:',
          'desc': 'Incorporate regular physical activity including cardiovascular and strength training.'
        }
      ];
    } else if (category == 'Overweight') {
      return [
        {
          'header': 'Calorie Control:',
          'desc': 'Focus on portion control and reducing calorie intake from sugary foods.'
        },
        {
          'header': 'Eat More Fiber:',
          'desc': 'Fruits, vegetables, and whole grains help you feel full longer.'
        },
        {
          'header': 'Regular Exercise:',
          'desc': 'Aim for 150 minutes of moderate cardiovascular exercise per week.'
        }
      ];
    } else {
      return [
        {
          'header': 'Consult a Professional:',
          'desc': 'Work with a dietitian or healthcare provider to establish a safe health plan.'
        },
        {
          'header': 'Mindful Eating:',
          'desc': 'Keep track of food portions, eat slowly, and avoid emotional eating.'
        },
        {
          'header': 'Consistent Physical Activity:',
          'desc': 'Incorporate consistent, low-impact exercise daily to support your heart health.'
        }
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final bmiProvider = Provider.of<BMIProvider>(context, listen: false);

    final bmi = bmiProvider.bmiResult;
    final category = bmiProvider.category;

    final recommendations = getRecommendations(category);
    final categoryColor = getCategoryColor(category);

    return Scaffold(
      backgroundColor: const Color(0xff151615),
      appBar: AppBar(
        backgroundColor: const Color(0xff151615),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actionsPadding: const EdgeInsets.only(right: 15),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white, size: 20),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
          ),
        ],
        title: const Text(
          "BMI Calculator",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Result",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              if (bmi != null && category != null) ...[
                BmiResultCard(
                  bmi: bmi,
                  category: category,
                  categoryColor: categoryColor,
                ),
                const SizedBox(height: 30),

                Text(
                  category,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Diet and Nutrition",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white60,
                  ),
                ),
                const SizedBox(height: 15), 

                ...recommendations.map((rec) => RecommendationItem(
                      header: rec['header']!,
                      desc: rec['desc']!,
                    )),
                const SizedBox(height: 25),

                ReUsableButton(
                  text: "Re-Calculate",
                  icon: Icons.subdirectory_arrow_left,
                  onTap: () => Navigator.pop(context),
                ),
              ] else ...[
                const Center(
                  child: Text(
                    "Error: No BMI calculation data found.",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 30),
                ReUsableButton(
                  text: "Go to Calculator",
                  icon: Icons.arrow_back,
                  onTap: () => Navigator.pop(context),
                ),
              ],
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
