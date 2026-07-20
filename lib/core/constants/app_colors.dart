import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // App Theme Accents
  static const Color accent = Color(0xffdafd87); // Lime-green accent for dark mode
  static const Color accentDark = Color(0xff7ca613); // High-contrast green for light mode

  // BMI classification colors (used in results/gauges/charts)
  static const Color underweight = Color(0xffdafd87);
  static const Color normal = Colors.greenAccent;
  static const Color overweight = Colors.orangeAccent;
  static const Color obese = Colors.redAccent;

  // Dark Mode Theme Palette
  static const Color bgDark = Color(0xff151615);
  static const Color cardDark = Color(0xff212121); // grey.shade900
  static const Color textPrimaryDark = Colors.white;
  static const Color textSecondaryDark = Colors.white60;
  static const Color borderDark = Colors.white10;

  // Light Mode Theme Palette
  static const Color bgLight = Color(0xfff7f9fa);
  static const Color cardLight = Colors.white;
  static const Color textPrimaryLight = Color(0xff151615);
  static const Color textSecondaryLight = Colors.black54;
  static const Color borderLight = Colors.black12;
}
