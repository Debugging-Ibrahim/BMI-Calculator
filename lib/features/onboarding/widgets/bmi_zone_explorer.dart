import 'dart:math' as math;
import 'package:digital_khata/features/onboarding/providers/onboarding_provider.dart';
import 'package:digital_khata/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BmiZoneExplorer extends StatelessWidget {
  const BmiZoneExplorer({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Consumer<OnboardingProvider>(
      builder: (context, provider, child) {
        final sliderValue = provider.sliderValue;

        String categoryName = l10n?.normalWeight ?? "Normal Weight";
        Color categoryColor = Colors.greenAccent;
        String categoryDescription = l10n?.normalWeightAdvice ?? "You have a healthy body weight. Maintain this with a balanced diet and regular activity!";

        if (sliderValue < 18.5) {
          categoryName = l10n?.underweight ?? "Underweight";
          categoryColor = const Color(0xffdafd87);
          categoryDescription = l10n?.underweightAdvice ?? "Below healthy range. Consider consulting a nutritionist to build healthy muscle mass.";
        } else if (sliderValue < 25.0) {
          categoryName = l10n?.normalWeight ?? "Normal Weight";
          categoryColor = const Color(0xff7ca613); // Harmonious premium green
          categoryDescription = l10n?.normalWeightAdvice ?? "Great job! You are in the healthy range. Keep up your active lifestyle.";
        } else if (sliderValue < 30.0) {
          categoryName = l10n?.overweight ?? "Overweight";
          categoryColor = Colors.orangeAccent;
          categoryDescription = l10n?.overweightAdvice ?? "Slightly above healthy range. A balanced caloric intake can help you return to normal range.";
        } else {
          categoryName = l10n?.obesity ?? "Obesity";
          categoryColor = Colors.redAccent;
          categoryDescription = l10n?.obesityAdvice ?? "Significantly above healthy range. Focus on nutrient-rich whole foods and daily movement.";
        }

        // Accessibility Category Text Color (especially for Underweight in Light Mode)
        Color categoryTextColor;
        if (isDark) {
          categoryTextColor = categoryColor;
        } else {
          if (sliderValue < 18.5) {
            categoryTextColor = const Color(0xff5c7a08); // High contrast olive green
          } else if (sliderValue < 25.0) {
            categoryTextColor = const Color(0xff55730d); // High contrast premium green
          } else if (sliderValue < 30.0) {
            categoryTextColor = const Color(0xffc75300); // High contrast dark orange
          } else {
            categoryTextColor = const Color(0xffc91a1a); // High contrast dark red
          }
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Gauge Meter (reduced height to resolve layout overflow)
            Container(
              height: 120,
              width: 280,
              margin: const EdgeInsets.only(top: 8),
              child: CustomPaint(
                painter: BmiMeterPainter(
                  bmiValue: sliderValue,
                  isDark: isDark,
                ),
              ),
            ),
            
            // Value & Classification Card
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 290,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.black.withValues(alpha: 0.02),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: categoryColor.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    sliderValue.toStringAsFixed(1),
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: categoryColor.withValues(alpha: isDark ? 0.15 : 0.25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      categoryName.toUpperCase(),
                      style: TextStyle(
                        color: categoryTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 48,
                    child: Center(
                      child: Text(
                        categoryDescription,
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black87,
                          fontSize: 12,
                          height: 1.35,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            
            // Interactive Slider
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: categoryColor,
                inactiveTrackColor: isDark ? Colors.white10 : Colors.black12,
                thumbColor: categoryColor,
                overlayColor: categoryColor.withValues(alpha: 0.15),
                valueIndicatorColor: categoryColor,
                valueIndicatorTextStyle: TextStyle(
                  color: isDark ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Slider(
                value: sliderValue,
                min: 15.0,
                max: 35.0,
                divisions: 200,
                label: sliderValue.toStringAsFixed(1),
                onChanged: (value) {
                  provider.setSliderValue(value);
                },
              ),
            ),
            Text(
              l10n?.dragSliderPreview ?? "Drag the slider to preview the BMI scale",
              style: TextStyle(
                color: isDark ? Colors.white30 : Colors.black38,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        );
      },
    );
  }
}

class BmiMeterPainter extends CustomPainter {
  final double bmiValue;
  final bool isDark;

  BmiMeterPainter({required this.bmiValue, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.height - 10;

    // Define colors matching the app standards
    const underweightColor = Color(0xffdafd87);
    const normalColor = Color(0xff7ca613);
    const overweightColor = Colors.orangeAccent;
    const obeseColor = Colors.redAccent;

    // Arc properties
    const double strokeWidth = 18.0;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final paintArc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    // Mapping angles for each zone (from 180 degrees [math.pi] to 0 degrees [0])
    // Total span = 20.0 BMI points (from 15 to 35)
    // 1. Underweight: 15.0 to 18.5 (span = 3.5)
    // 2. Normal: 18.5 to 25.0 (span = 6.5)
    // 3. Overweight: 25.0 to 30.0 (span = 5.0)
    // 4. Obesity: 30.0 to 35.0 (span = 5.0)
    
    const double startAngle = math.pi;
    const double underweightAngle = (3.5 / 20.0) * math.pi;
    const double normalAngle = (6.5 / 20.0) * math.pi;
    const double overweightAngle = (5.0 / 20.0) * math.pi;
    const double obeseAngle = (5.0 / 20.0) * math.pi;

    // Draw Underweight arc segment
    paintArc.color = underweightColor;
    canvas.drawArc(rect, startAngle, underweightAngle, false, paintArc);

    // Draw Normal Weight arc segment
    paintArc.color = normalColor;
    canvas.drawArc(rect, startAngle + underweightAngle, normalAngle, false, paintArc);

    // Draw Overweight arc segment
    paintArc.color = overweightColor;
    canvas.drawArc(rect, startAngle + underweightAngle + normalAngle, overweightAngle, false, paintArc);

    // Draw Obesity arc segment
    paintArc.color = obeseColor;
    canvas.drawArc(rect, startAngle + underweightAngle + normalAngle + overweightAngle, obeseAngle, false, paintArc);

    // Calculate needle angle
    final double clampedBmi = bmiValue.clamp(15.0, 35.0);
    final double percent = (clampedBmi - 15.0) / 20.0;
    final double needleAngle = math.pi - (percent * math.pi);

    // Draw Needle Shadow / Indicator Line
    final needlePaint = Paint()
      ..color = isDark ? Colors.white : Colors.black
      ..style = PaintingStyle.fill;

    final double needleLength = radius - 8;
    final needleTip = Offset(
      center.dx + needleLength * math.cos(needleAngle),
      center.dy - needleLength * math.sin(needleAngle),
    );

    // Base thickness perpendicular to needle direction
    const double baseWidth = 5.0;
    final double baseLeftAngle = needleAngle + math.pi / 2;
    final double baseRightAngle = needleAngle - math.pi / 2;

    final baseLeft = Offset(
      center.dx + baseWidth * math.cos(baseLeftAngle),
      center.dy - baseWidth * math.sin(baseLeftAngle),
    );
    final baseRight = Offset(
      center.dx + baseWidth * math.cos(baseRightAngle),
      center.dy - baseWidth * math.sin(baseRightAngle),
    );

    final path = Path()
      ..moveTo(baseLeft.dx, baseLeft.dy)
      ..lineTo(needleTip.dx, needleTip.dy)
      ..lineTo(baseRight.dx, baseRight.dy)
      ..close();

    canvas.drawPath(path, needlePaint);

    // Draw center cap pin
    final pivotPaint = Paint()
      ..color = isDark ? const Color(0xff151615) : const Color(0xfff7f9fa)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 10, pivotPaint);

    final pivotBorderPaint = Paint()
      ..color = isDark ? Colors.white : Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawCircle(center, 10, pivotBorderPaint);
    canvas.drawCircle(center, 3, needlePaint);
  }

  @override
  bool shouldRepaint(covariant BmiMeterPainter oldDelegate) {
    return oldDelegate.bmiValue != bmiValue || oldDelegate.isDark != isDark;
  }
}
