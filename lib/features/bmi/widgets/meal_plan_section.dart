import 'package:digital_khata/features/bmi/services/meal_plan_service.dart';
import 'package:digital_khata/features/bmi/widgets/meal_plan_card.dart';
import 'package:digital_khata/core/providers/connectivity_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MealPlanSection extends StatelessWidget {
  final double targetCalories;

  const MealPlanSection({super.key, required this.targetCalories});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isOffline = context.watch<ConnectivityProvider>().isOffline;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Spoonacular Meal Plan",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Recommended daily meal options matching your target calories",
          style: TextStyle(
            fontSize: 13,
            color: isDark ? Colors.white54 : Colors.black54,
          ),
        ),
        const SizedBox(height: 15),
        if (isOffline)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.black12,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.cloud_off_rounded,
                  color: isDark ? Colors.white30 : Colors.black38,
                  size: 40,
                ),
                const SizedBox(height: 12),
                Text(
                  "Meal Plan Offline",
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Please connect to the internet to load your custom daily meal plan options.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDark ? Colors.white54 : Colors.black54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          )
        else
          FutureBuilder<MealPlan?>(
            future: MealPlanService.fetchMealPlan(targetCalories),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40.0),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme.primaryColor,
                      ),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                final errStr = snapshot.error.toString();
                final isSocketError = errStr.contains('SocketException') || errStr.contains('Failed host lookup');
                final displayError = isSocketError
                    ? 'Connection error. Please check your internet connection and try again.'
                    : 'Could not load meal plan: ${snapshot.error}';
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
                    displayError,
                    style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.meals.isEmpty) {
              return Text(
                'No meal plan available for this calorie target.',
                style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
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
                    color: theme.cardColor,
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color labelColor = isHighlight
        ? theme.primaryColor
        : (isDark ? Colors.white38 : Colors.black38);

    final Color valueColor = isHighlight
        ? theme.primaryColor
        : theme.colorScheme.onSurface;

    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: labelColor,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
