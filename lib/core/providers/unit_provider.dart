import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum UnitSystem { metric, imperial }

class UnitProvider extends ChangeNotifier {
  UnitSystem _unitSystem = UnitSystem.metric; // Default is Metric
  UnitSystem get unitSystem => _unitSystem;

  bool get isMetric => _unitSystem == UnitSystem.metric;
  bool get isImperial => _unitSystem == UnitSystem.imperial;

  UnitProvider() {
    _loadUnitFromPrefs();
  }

  Future<void> _loadUnitFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    // Default to false (metric) if not previously saved
    final isImperialPref = prefs.getBool('is_imperial_key') ?? false;
    _unitSystem = isImperialPref ? UnitSystem.imperial : UnitSystem.metric;
    notifyListeners();
  }

  Future<void> toggleUnitSystem(bool isImperial) async {
    _unitSystem = isImperial ? UnitSystem.imperial : UnitSystem.metric;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_imperial_key', isImperial);
  }
}
