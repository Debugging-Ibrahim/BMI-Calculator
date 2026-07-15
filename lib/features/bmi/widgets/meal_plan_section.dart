import 'package:digital_khata/features/bmi/services/meal_plan_service.dart';
import 'package:digital_khata/features/bmi/widgets/meal_plan_card.dart';
import 'package:flutter/material.dart';

class MealPlanSection extends StatelessWidget {
  final double targetCalories;

  const MealPlanSection({super.key, required this.targetCalories});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          style: TextStyle(fontSize: 13, color: Colors.white54),
        ),
        const SizedBox(height: 15),
        FutureBuilder<MealPlan?>(
          future: MealPlanService.fetchMealPlan(targetCalories),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.0),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xffdafd87),
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.redAccent.withValues(alpha: .3),
                  ),
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
                      _NutrientStat(
                        label: 'Protein',
                        value: '${mealPlan.nutrients.protein.round()}g',
                      ),
                      _NutrientStat(
                        label: 'Carbs',
                        value: '${mealPlan.nutrients.carbohydrates.round()}g',
                      ),
                      _NutrientStat(
                        label: 'Fat',
                        value: '${mealPlan.nutrients.fat.round()}g',
                      ),
                      _NutrientStat(
                        label: 'Calories',
                        value: '${mealPlan.nutrients.calories.round()} kcal',
                        isHighlight: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                // Meal Plan Cards
                if (mealPlan.meals.isNotEmpty)
                  MealPlanCard(
                    meal: mealPlan.meals[0],
                    label: 'Meal 1: Breakfast',
                  ),
                if (mealPlan.meals.length > 1)
                  MealPlanCard(meal: mealPlan.meals[1], label: 'Meal 2: Lunch'),
                if (mealPlan.meals.length > 2)
                  MealPlanCard(
                    meal: mealPlan.meals[2],
                    label: 'Meal 3: Dinner',
                  ),
              ],
            );
          },
        ),
      ],
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
