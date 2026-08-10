import 'package:digital_khata/features/bmi/services/meal_plan_service.dart';
import 'package:digital_khata/l10n/app_localizations.dart';
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
      debugPrint('Could not launch recipe URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final onSurface = theme.colorScheme.onSurface;

    return Card(
      color: theme.cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: theme.primaryColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                label.toUpperCase(),
                style: TextStyle(
                  color: theme.primaryColor,
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
              style: TextStyle(
                color: onSurface,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            // Specs Row
            Row(
              children: [
                Icon(
                  Icons.access_time_rounded,
                  color: isDark ? Colors.white38 : Colors.black38,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '${meal.readyInMinutes} ${l10n?.min ?? "min"}',
                  style: TextStyle(
                    color: isDark ? Colors.white60 : Colors.black54,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.people_outline_rounded,
                  color: isDark ? Colors.white38 : Colors.black38,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '${meal.servings} ${l10n?.servings ?? "servings"}',
                  style: TextStyle(
                    color: isDark ? Colors.white60 : Colors.black54,
                    fontSize: 13,
                  ),
                ),
                const Spacer(),
                // View Recipe Text Link
                if (meal.sourceUrl.isNotEmpty)
                  GestureDetector(
                    onTap: _launchUrl,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l10n?.viewRecipe ?? 'View Recipe',
                          style: TextStyle(
                            color: theme.primaryColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: theme.primaryColor,
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
