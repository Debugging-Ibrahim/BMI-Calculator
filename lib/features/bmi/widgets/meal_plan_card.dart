import 'package:digital_khata/features/bmi/services/meal_plan_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MealPlanCard extends StatelessWidget {
  final Meal meal;
  final String label;

  const MealPlanCard({
    super.key,
    required this.meal,
    required this.label,
  });

  Future<void> _launchUrl() async {
    if (meal.sourceUrl.isEmpty) return;
    final Uri url = Uri.parse(meal.sourceUrl);
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch ${meal.sourceUrl}');
      }
    } catch (e) {
      print('Could not launch recipe URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade900,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label Pill (Breakfast / Lunch / Dinner)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xffdafd87).withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                label.toUpperCase(),
                style: const TextStyle(
                  color: Color(0xffdafd87),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Title
            Text(
              meal.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            // Specs Row
            Row(
              children: [
                const Icon(Icons.access_time_rounded, color: Colors.white38, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${meal.readyInMinutes} min',
                  style: const TextStyle(color: Colors.white60, fontSize: 13),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.people_outline_rounded, color: Colors.white38, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${meal.servings} servings',
                  style: const TextStyle(color: Colors.white60, fontSize: 13),
                ),
                const Spacer(),
                // View Recipe Text Link
                if (meal.sourceUrl.isNotEmpty)
                  GestureDetector(
                    onTap: _launchUrl,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'View Recipe',
                          style: TextStyle(
                            color: Color(0xffdafd87),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 2),
                        Icon(
                          Icons.arrow_outward_rounded,
                          color: Color(0xffdafd87),
                          size: 14,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
