import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum UnitSystem { metric, imperial }

class UnitProvider extends ChangeNotifier {
  UnitSystem _unitSystem = UnitSystem.metric; // Default is Metric
  UnitSystem get unitSystem => _unitSystem;

  bool get isMetric => _unitSystem == UnitSystem.metric;
  bool get isImperial => _unitSystem == UnitSystem.imperial;
  final SharedPreferences? _prefs;

  UnitProvider(this._prefs) {
    _loadUnitFromPrefs();
  }

  Future<void> _loadUnitFromPrefs() async {
    try {
      final prefs = _prefs ?? await SharedPreferences.getInstance();
      final isImperialPref = prefs.getBool('is_imperial_key') ?? false;
      _unitSystem = isImperialPref ? UnitSystem.imperial : UnitSystem.metric;
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading unit from SharedPreferences: $e");
    }
  }

  Future<void> toggleUnitSystem(bool isImperial) async {
    _unitSystem = isImperial ? UnitSystem.imperial : UnitSystem.metric;
    notifyListeners();
    try {
      final prefs = _prefs ?? await SharedPreferences.getInstance();
      await prefs.setBool('is_imperial_key', isImperial);
    } catch (e) {
      debugPrint("Error saving unit to SharedPreferences: $e");
    }
  }
}
