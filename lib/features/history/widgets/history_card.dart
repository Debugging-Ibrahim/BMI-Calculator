import 'package:digital_khata/core/providers/unit_provider.dart';
import 'package:digital_khata/core/utils/export_helper.dart';
import 'package:digital_khata/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryCard extends StatelessWidget {
  final double bmi;
  final String category;
  final String height;
  final String weight;
  final String formattedDate;
  final double? bmr;
  final double? tdee;
  final double? targetCalories;

  const HistoryCard({
    super.key,
    required this.bmi,
    required this.category,
    required this.height,
    required this.weight,
    required this.formattedDate,
    this.bmr,
    this.tdee,
    this.targetCalories,
  });

  String _getLocalizedCategory(String cat, AppLocalizations? l10n) {
    final lower = cat.toLowerCase();
    if (lower.contains('underweight')) {
      return l10n?.underweight ?? cat;
    } else if (lower.contains('normal') || lower.contains('healthy')) {
      return l10n?.normalWeight ?? cat;
    } else if (lower.contains('overweight')) {
      return l10n?.overweight ?? cat;
    } else if (lower.contains('obese') || lower.contains('obesity')) {
      return l10n?.obesity ?? cat;
    }
    return cat;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final unitProvider = context.watch<UnitProvider>();

    final double? heightCm = double.tryParse(height);
    final double? weightKg = double.tryParse(weight);

    String heightDisplay = "${height}cm";
    String weightDisplay = "${weight}kg";

    if (unitProvider.isImperial) {
      if (heightCm != null) {
        final totalInches = heightCm / 2.54;
        final feet = (totalInches / 12).floor();
        final inches = (totalInches % 12).round();
        heightDisplay = "${feet}ft ${inches}in";
      }
      if (weightKg != null) {
        final lbs = weightKg * 2.20462;
        weightDisplay = "${lbs.toStringAsFixed(0)}lbs";
      }
    } else {
      if (heightCm != null) {
        heightDisplay = "${heightCm.toStringAsFixed(0)}cm";
      }
      if (weightKg != null) {
        weightDisplay = "${weightKg.toStringAsFixed(0)}kg";
      }
    }

    final localizedCat = _getLocalizedCategory(category, l10n);
    final heightLabelText = l10n?.heightLabel ?? "Height";
    final weightLabelText = l10n?.weightLabel ?? "Weight";
    final calculatedOnText = l10n?.calculatedOn ?? "Calculated on";

    return Card(
      color: theme.cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: () => _showExportOptionsBottomSheet(context),
        leading: CircleAvatar(
          backgroundColor: theme.primaryColor,
          child: Text(
            bmi.toStringAsFixed(1),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.black : Colors.white,
            ),
          ),
        ),
        title: Text(
          localizedCat,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          "$heightLabelText: $heightDisplay | $weightLabelText: $weightDisplay\n$calculatedOnText: $formattedDate",
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
        isThreeLine: true,
        trailing: IconButton(
          icon: Icon(Icons.share_rounded, color: theme.primaryColor, size: 22),
          tooltip: "Export Options",
          onPressed: () => _showExportOptionsBottomSheet(context),
        ),
      ),
    );
  }

  void _showExportOptionsBottomSheet(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white24 : Colors.black26,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  l10n?.shareOrExportRecord ?? "Share or Export Record",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 15),
                ListTile(
                  leading: Icon(Icons.share_rounded, color: theme.primaryColor),
                  title: Text(
                    l10n?.shareAsText ?? "Share as Text",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  subtitle: Text(
                    l10n?.shareAsTextSub ?? "Share the result as a text message",
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white54 : Colors.black54,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    Navigator.pop(context);
                    ExportHelper.shareSingleResultAsText(
                      bmi: bmi,
                      category: category,
                      height: height,
                      weight: weight,
                      date: formattedDate.split(' at ')[0],
                      targetCalories: targetCalories,
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.picture_as_pdf_rounded, color: Colors.redAccent),
                  title: Text(
                    l10n?.exportAsPdf ?? "Export as PDF",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  subtitle: Text(
                    l10n?.exportAsPdfSub ?? "Download or print a formatted PDF report",
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white54 : Colors.black54,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    Navigator.pop(context);
                    ExportHelper.exportSinglePdf(
                      bmi: bmi,
                      category: category,
                      height: height,
                      weight: weight,
                      date: formattedDate,
                      bmr: bmr,
                      tdee: tdee,
                      targetCalories: targetCalories,
                      recommendations: _getRecommendations(category),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Map<String, String>> _getRecommendations(String category) {
    final cat = category.toLowerCase();
    if (cat.contains('underweight')) {
      return [
        {'header': 'Eat More Calories:', 'desc': 'Consume more high-calorie foods like nuts, avocados, and healthy oils.'},
        {'header': 'Portion Size:', 'desc': 'Increase portion sizes during meals to support healthy weight gain.'},
        {'header': 'Choose Nutrient-Rich Foods:', 'desc': 'Focus on protein and complex carbs for sustained energy.'}
      ];
    } else if (cat.contains('normal') || cat.contains('healthy')) {
      return [
        {'header': 'Maintain Balance:', 'desc': 'Focus on a well-rounded diet with a mix of proteins, complex carbs, and healthy fats.'},
        {'header': 'Stay Hydrated:', 'desc': 'Drink at least 8-10 glasses of water daily to maintain metabolic efficiency.'},
        {'header': 'Active Lifestyle:', 'desc': 'Incorporate regular physical activity including cardiovascular and strength training.'}
      ];
    } else if (cat.contains('overweight')) {
      return [
        {'header': 'Calorie Control:', 'desc': 'Focus on portion control and reducing calorie intake from sugary foods.'},
        {'header': 'Eat More Fiber:', 'desc': 'Fruits, vegetables, and whole grains help you feel full longer.'},
        {'header': 'Regular Exercise:', 'desc': 'Aim for 150 minutes of moderate cardiovascular exercise per week.'}
      ];
    } else {
      return [
        {'header': 'Consult a Professional:', 'desc': 'Work with a dietitian or healthcare provider to establish a safe health plan.'},
        {'header': 'Mindful Eating:', 'desc': 'Keep track of food portions, eat slowly, and avoid emotional eating.'},
        {'header': 'Consistent Physical Activity:', 'desc': 'Incorporate consistent, low-impact exercise daily to support your heart health.'}
      ];
    }
  }
}
