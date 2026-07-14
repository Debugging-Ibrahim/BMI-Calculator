import 'package:digital_khata/features/auth/screens/login_screen.dart';
import 'package:digital_khata/features/bmi/providers/bmi_provider.dart';
import 'package:digital_khata/features/bmi/services/meal_plan_service.dart';
import 'package:digital_khata/features/bmi/widgets/bmi_result_card.dart';
import 'package:digital_khata/features/bmi/widgets/meal_plan_card.dart';
import 'package:digital_khata/features/bmi/widgets/recommendation_item.dart';
import 'package:digital_khata/core/widgets/reusable_button.dart';
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
                const SizedBox(height: 20),

                // Daily Energy & Calories Stats Row
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        title: 'BMR',
                        value: '${bmiProvider.bmr?.toStringAsFixed(0)} kcal',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _StatCard(
                        title: 'TDEE',
                        value: '${bmiProvider.tdee?.toStringAsFixed(0)} kcal',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _StatCard(
                        title: 'Target',
                        value: '${bmiProvider.targetCalories?.toStringAsFixed(0)} kcal',
                        isHighlight: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Spoonacular Meal Plan Section
                const Text(
                  "Spoonacular Meal Plan",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Recommended daily meal options matching your target calories",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white54,
                  ),
                ),
                const SizedBox(height: 15),

                FutureBuilder<MealPlan?>(
                  future: MealPlanService.fetchMealPlan(bmiProvider.targetCalories ?? 2000),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40.0),
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xffdafd87)),
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
                        ),
                        child: Text(
                          'Could not load meal plan: ${snapshot.error}',
                          style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.meals.isEmpty) {
                      return const Text(
                        'No meal plan available for this calorie target.',
                        style: TextStyle(color: Colors.white70),
                      );
                    }

                    final mealPlan = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Daily Nutrient totals pill/bar
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade900,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _NutrientStat(label: 'Protein', value: '${mealPlan.nutrients.protein.round()}g'),
                              _NutrientStat(label: 'Carbs', value: '${mealPlan.nutrients.carbohydrates.round()}g'),
                              _NutrientStat(label: 'Fat', value: '${mealPlan.nutrients.fat.round()}g'),
                              _NutrientStat(label: 'Calories', value: '${mealPlan.nutrients.calories.round()} kcal', isHighlight: true),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        // Meal Plan Cards
                        if (mealPlan.meals.isNotEmpty)
                          MealPlanCard(meal: mealPlan.meals[0], label: 'Meal 1: Breakfast'),
                        if (mealPlan.meals.length > 1)
                          MealPlanCard(meal: mealPlan.meals[1], label: 'Meal 2: Lunch'),
                        if (mealPlan.meals.length > 2)
                          MealPlanCard(meal: mealPlan.meals[2], label: 'Meal 3: Dinner'),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 30),

                // General Diet and Nutrition Recommendations
                Text(
                  category,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "General Nutrition Guidelines",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white54,
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

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final bool isHighlight;

  const _StatCard({
    required this.title,
    required this.value,
    this.isHighlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: isHighlight ? const Color(0xffdafd87).withOpacity(0.1) : Colors.grey.shade900,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isHighlight ? const Color(0xffdafd87) : Colors.transparent,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: isHighlight ? const Color(0xffdafd87) : Colors.white54,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _NutrientStat extends StatelessWidget {
  final String label;
  final String value;
  final bool isHighlight;

  const _NutrientStat({
    required this.label,
    required this.value,
    this.isHighlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: isHighlight ? const Color(0xffdafd87) : Colors.white38,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: isHighlight ? const Color(0xffdafd87) : Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
