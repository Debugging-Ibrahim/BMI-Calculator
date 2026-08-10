import 'package:digital_khata/features/auth/screens/login_screen.dart';
import 'package:digital_khata/features/bmi/providers/bmi_provider.dart';
import 'package:digital_khata/features/bmi/widgets/bmi_result_card.dart';
import 'package:digital_khata/features/bmi/widgets/daily_stats_row.dart';
import 'package:digital_khata/features/bmi/widgets/meal_plan_section.dart';
import 'package:digital_khata/features/bmi/widgets/recommendation_item.dart';
import 'package:digital_khata/core/widgets/reusable_button.dart';
import 'package:digital_khata/core/utils/export_helper.dart';
import 'package:digital_khata/l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  Color getCategoryColor(String? category) {
    if (category == null) return Colors.white;
    final cat = category.toLowerCase();
    if (cat.contains('underweight')) {
      return const Color(0xffdafd87);
    } else if (cat.contains('normal') || cat.contains('healthy')) {
      return Colors.greenAccent;
    } else if (cat.contains('overweight')) {
      return Colors.orangeAccent;
    } else if (cat.contains('obese') || cat.contains('obesity')) {
      return Colors.redAccent;
    } else {
      return Colors.white;
    }
  }

  String _getLocalizedCategory(String? cat, AppLocalizations? l10n) {
    if (cat == null) return '';
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

  List<Map<String, String>> getRecommendations(String? category, AppLocalizations? l10n) {
    final cat = category?.toLowerCase() ?? '';
    final isUrdu = l10n?.localeName == 'ur';

    if (cat.contains('underweight')) {
      return [
        {
          'header': isUrdu ? 'زیادہ کیلوریز کھائیں:' : 'Eat More Calories:',
          'desc': isUrdu
              ? 'زیادہ کیلوریز والی غذاؤں جیسے گری دار میوے اور صحت بخش تیل کا استعمال کریں۔'
              : 'Consume more high-calorie foods like nuts, avocados, and healthy oils.'
        },
        {
          'header': isUrdu ? 'خوراک کا سائز:' : 'Portion Size:',
          'desc': isUrdu
              ? 'صحت مند وزن بڑھانے کے لیے کھانوں کے سائز میں اضافہ کریں۔'
              : 'Increase portion sizes during meals to support healthy weight gain.'
        },
        {
          'header': isUrdu ? 'غذائیت سے بھرپور غذاؤں کا انتخاب کریں:' : 'Choose Nutrient-Rich Foods:',
          'desc': isUrdu
              ? 'توانائی برقرار رکھنے کے لیے پروٹین اور پیچیدہ کاربوہائیڈریٹس پر توجہ دیں۔'
              : 'Focus on foods rich in protein (lean meats, fish, eggs, legumes) and complex carbohydrates for sustained energy.'
        }
      ];
    } else if (cat.contains('normal') || cat.contains('healthy')) {
      return [
        {
          'header': isUrdu ? 'توازن برقرار رکھیں:' : 'Maintain Balance:',
          'desc': isUrdu
              ? 'پروٹین، کاربوہائیڈریٹس اور صحت بخش چکنائی کی متوازن غذا پر توجہ دیں۔'
              : 'Focus on a well-rounded diet with a mix of proteins, complex carbs, and healthy fats.'
        },
        {
          'header': isUrdu ? 'پانی کا مناسب استعمال:' : 'Stay Hydrated:',
          'desc': isUrdu
              ? 'میٹابولزم کو بہترین رکھنے کے لیے روزانہ کم از کم 8 سے 10 گلاس پانی پیئیں۔'
              : 'Drink at least 8-10 glasses of water daily to maintain metabolic efficiency.'
        },
        {
          'header': isUrdu ? 'فعال طرز زندگی:' : 'Active Lifestyle:',
          'desc': isUrdu
              ? 'باقاعدگی سے ورزش اور جسمانی سرگرمی کو اپنے معمول کا حصہ بنائیں۔'
              : 'Incorporate regular physical activity including cardiovascular and strength training.'
        }
      ];
    } else if (cat.contains('overweight')) {
      return [
        {
          'header': isUrdu ? 'کیلوریز کا کنٹرول:' : 'Calorie Control:',
          'desc': isUrdu
              ? 'میٹھی چیزوں سے پرہیز اور کیلوریز پر کنٹرول حاصل کریں۔'
              : 'Focus on portion control and reducing calorie intake from sugary foods.'
        },
        {
          'header': isUrdu ? 'فائبر کا استعمال:' : 'Eat More Fiber:',
          'desc': isUrdu
              ? 'پھل، سبزیاں اور اناج آپ کو زیادہ دیر تک سیر رکھتے ہیں۔'
              : 'Fruits, vegetables, and whole grains help you feel full longer.'
        },
        {
          'header': isUrdu ? 'باقاعدہ ورزش:' : 'Regular Exercise:',
          'desc': isUrdu
              ? 'ہفتے میں 150 منٹ کی معتدل ورزش کا ہدف رکھیں۔'
              : 'Aim for 150 minutes of moderate cardiovascular exercise per week.'
        }
      ];
    } else {
      return [
        {
          'header': isUrdu ? 'ماہر سے مشورہ:' : 'Consult a Professional:',
          'desc': isUrdu
              ? 'صحت مند منصوبے کے لیے کسی ڈاکٹر یا ماہر غذائیت سے مشورہ کریں۔'
              : 'Work with a dietitian or healthcare provider to establish a safe health plan.'
        },
        {
          'header': isUrdu ? 'احتیاط سے کھانا:' : 'Mindful Eating:',
          'desc': isUrdu
              ? 'خوراک کی مقدار پر نظر رکھیں اور آہستہ آہستہ کھائیں۔'
              : 'Keep track of food portions, eat slowly, and avoid emotional eating.'
        },
        {
          'header': isUrdu ? 'مسلسل جسمانی سرگرمی:' : 'Consistent Physical Activity:',
          'desc': isUrdu
              ? 'دل کی صحت کے لیے روزانہ باقاعدگی سے ہلکی ورزش کریں۔'
              : 'Incorporate consistent, low-impact exercise daily to support your heart health.'
        }
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bmiProvider = Provider.of<BMIProvider>(context, listen: false);

    final bmi = bmiProvider.bmiResult;
    final category = bmiProvider.category;

    final recommendations = getRecommendations(category, l10n);
    final categoryColor = getCategoryColor(category);
    final localizedCategory = _getLocalizedCategory(category, l10n);

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final onSurface = theme.colorScheme.onSurface;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: onSurface, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actionsPadding: const EdgeInsets.only(right: 15),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: onSurface, size: 20),
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
        title: Text(
          l10n?.bmiCalculator ?? "BMI Calculator",
          style: TextStyle(color: onSurface, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n?.result ?? "Result",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: onSurface,
                ),
              ),
              const SizedBox(height: 20),

              if (bmi != null && category != null) ...[
                BmiResultCard(
                  bmi: bmi,
                  category: category,
                  categoryColor: categoryColor,
                ),
                const SizedBox(height: 16),

                // Share & Export Actions Row
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: Icon(Icons.share_rounded, size: 18, color: theme.primaryColor),
                        label: Text(
                          l10n?.shareText ?? "Share Text",
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(color: theme.primaryColor.withValues(alpha: 0.5), width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          final now = DateTime.now();
                          final dateStr = "${now.day}/${now.month}/${now.year}";
                          ExportHelper.shareSingleResultAsText(
                            bmi: bmi,
                            category: category,
                            height: bmiProvider.height ?? '0',
                            weight: bmiProvider.weight ?? '0',
                            date: dateStr,
                            targetCalories: bmiProvider.targetCalories,
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.picture_as_pdf_rounded, size: 18),
                        label: Text(
                          l10n?.exportPdf ?? "Export PDF",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          foregroundColor: isDark ? Colors.black : Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          final now = DateTime.now();
                          final dateStr = "${now.day}/${now.month}/${now.year}";
                          ExportHelper.exportSinglePdf(
                            bmi: bmi,
                            category: category,
                            height: bmiProvider.height ?? '0',
                            weight: bmiProvider.weight ?? '0',
                            date: dateStr,
                            bmr: bmiProvider.bmr,
                            tdee: bmiProvider.tdee,
                            targetCalories: bmiProvider.targetCalories,
                            recommendations: recommendations,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Daily Energy & Calories Stats Row (BMR, TDEE, Target)
                DailyStatsRow(
                  bmr: bmiProvider.bmr,
                  tdee: bmiProvider.tdee,
                  targetCalories: bmiProvider.targetCalories,
                ),
                const SizedBox(height: 30),

                // Spoonacular Meal Plan Section
                MealPlanSection(
                  targetCalories: bmiProvider.targetCalories ?? 2000,
                ),
                const SizedBox(height: 30),

                // General Diet and Nutrition Recommendations
                Text(
                  localizedCategory,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n?.generalNutritionGuidelines ?? "General Nutrition Guidelines",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white54 : Colors.black54,
                  ),
                ),
                const SizedBox(height: 15),

                ...recommendations.map((rec) => RecommendationItem(
                      header: rec['header']!,
                      desc: rec['desc']!,
                    )),
                const SizedBox(height: 25),

                ReUsableButton(
                  text: l10n?.reCalculate ?? "Re-Calculate",
                  icon: Icons.subdirectory_arrow_left,
                  onTap: () => Navigator.pop(context),
                ),
              ] else ...[
                Center(
                  child: Text(
                    l10n?.noHistoryFound ?? "Error: No BMI calculation data found.",
                    style: TextStyle(fontSize: 18, color: onSurface),
                  ),
                ),
                const SizedBox(height: 30),
                ReUsableButton(
                  text: l10n?.reCalculate ?? "Go to Calculator",
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
