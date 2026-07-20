import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BmiLineChart extends StatelessWidget {
  final List<Map<dynamic, dynamic>> history;

  const BmiLineChart({
    super.key,
    required this.history,
  });

  Color _getBmiColor(double bmi) {
    if (bmi < 18.5) {
      return const Color(0xffdafd87); // Underweight
    } else if (bmi < 24.9) {
      return Colors.greenAccent; // Normal Weight
    } else if (bmi < 29.9) {
      return Colors.orangeAccent; // Overweight
    } else {
      return Colors.redAccent; // Obesity
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Reverse history list to display chronologically from oldest (left) to newest (right)
    final chronologicalHistory = history.reversed.toList();

    final spots = List<FlSpot>.generate(chronologicalHistory.length, (index) {
      final double bmi = chronologicalHistory[index]['value'] ?? 0.0;
      return FlSpot(index.toDouble(), bmi);
    });

    // Calculate Y-axis limits with padding for visual comfort
    double minBmi = 100.0;
    double maxBmi = 0.0;
    for (var entry in chronologicalHistory) {
      final double val = entry['value'] ?? 0.0;
      if (val < minBmi) minBmi = val;
      if (val > maxBmi) maxBmi = val;
    }
    // Fallbacks if history calculations are off
    if (minBmi == 100.0) minBmi = 15.0;
    if (maxBmi == 0.0) maxBmi = 35.0;

    final double yMin = (minBmi - 3).clamp(5.0, 100.0);
    final double yMax = (maxBmi + 3).clamp(0.0, 100.0);

    // Calculate X-axis titles interval dynamically to prevent label overlap
    final double xInterval = (chronologicalHistory.length / 4).clamp(1.0, double.infinity);

    final Color axisLabelColor = isDark ? Colors.white30 : Colors.black38;
    final Color gridLineColor = isDark ? Colors.white10 : Colors.black12;

    return Container(
      height: 220,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 20, 20, 10),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: (chronologicalHistory.length - 1).toDouble(),
          minY: yMin,
          maxY: yMax,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: 5,
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) => FlLine(
              color: gridLineColor,
              strokeWidth: 1,
              dashArray: [4, 4],
            ),
            getDrawingVerticalLine: (value) => FlLine(
              color: gridLineColor,
              strokeWidth: 1,
              dashArray: [4, 4],
            ),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 5,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toStringAsFixed(0),
                    style: TextStyle(
                      color: axisLabelColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  );
                },
                reservedSize: 28,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: xInterval,
                getTitlesWidget: (value, meta) {
                  final int index = value.toInt();
                  if (index >= 0 && index < chronologicalHistory.length) {
                    final String rawDate = chronologicalHistory[index]['date'] ?? '';
                    if (rawDate.isNotEmpty) {
                      final date = DateTime.parse(rawDate);
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "${date.day}/${date.month}",
                          style: TextStyle(
                            color: axisLabelColor,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }
                  }
                  return const SizedBox.shrink();
                },
                reservedSize: 22,
              ),
            ),
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (spot) => isDark ? const Color(0xFF0D0D0D) : Colors.white,
              tooltipBorderRadius: BorderRadius.circular(8),
              tooltipBorder: BorderSide(color: isDark ? Colors.white10 : Colors.black12),
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  final double bmiVal = spot.y;
                  final int idx = spot.x.toInt();
                  String category = 'N/A';
                  if (idx >= 0 && idx < chronologicalHistory.length) {
                    category = chronologicalHistory[idx]['category'] ?? 'N/A';
                  }

                  return LineTooltipItem(
                    "BMI: ${bmiVal.toStringAsFixed(1)}\n$category",
                    TextStyle(
                      color: _getBmiColor(bmiVal),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  );
                }).toList();
              },
            ),
            handleBuiltInTouches: true,
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              barWidth: 3,
              isStrokeCapRound: true,
              color: theme.primaryColor,
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    theme.primaryColor.withValues(alpha: 0.2),
                    theme.primaryColor.withValues(alpha: 0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  final double bmiVal = spot.y;
                  return FlDotCirclePainter(
                    radius: 5,
                    color: _getBmiColor(bmiVal),
                    strokeWidth: 2,
                    strokeColor: theme.cardColor,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
