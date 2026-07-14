import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class BMIProvider extends ChangeNotifier {
  late Box _bmiBox;

  List<Map<dynamic, dynamic>> _history = [];

  List<Map<dynamic, dynamic>> get history => _history;

  double? _bmiResult;
  String? _category;
  String? _height;
  String? _weight;
  int? _age;
  String? _gender;
  double? _bmr;
  double? _tdee;
  double? _targetCalories;

  double? get bmiResult => _bmiResult;
  String? get category => _category;
  String? get height => _height;
  String? get weight => _weight;
  int? get age => _age;
  String? get gender => _gender;
  double? get bmr => _bmr;
  double? get tdee => _tdee;
  double? get targetCalories => _targetCalories;

  Future<void> initHive() async {
    _bmiBox = await Hive.openBox('bmi_box');
    loadHistory();
  }

  void loadHistory() {
    _history = _bmiBox.values
        .cast<Map<dynamic, dynamic>>()
        .toList()
        .reversed
        .toList();
    notifyListeners();
  }

  void calculateAndSave(String heightStr, String weightStr, int age, String gender) {
    final double? heightVal = double.tryParse(heightStr);
    final double? weightVal = double.tryParse(weightStr);

    if (heightVal != null &&
        heightVal > 0 &&
        weightVal != null &&
        weightVal > 0) {
      _height = heightStr;
      _weight = weightStr;
      _age = age;
      _gender = gender;

      final double heightInMeters = heightVal / 100;
      final double bmi = weightVal / (heightInMeters * heightInMeters);

      _bmiResult = bmi;
      _category = _getBMICategory(bmi);

      // Mifflin-St Jeor Equation for BMR
      double bmrCalculated = 0.0;
      if (gender.toLowerCase() == 'male') {
        bmrCalculated = (10 * weightVal) + (6.25 * heightVal) - (5 * age) + 5;
      } else {
        bmrCalculated = (10 * weightVal) + (6.25 * heightVal) - (5 * age) - 161;
      }
      _bmr = bmrCalculated;

      // TDEE: Assuming lightly active multiplier = 1.375
      _tdee = bmrCalculated * 1.375;

      // Target Calories
      if (bmi < 18.5) {
        _targetCalories = _tdee! + 500; // Weight gain surplus
      } else if (bmi < 25.0) {
        _targetCalories = _tdee!; // Normal maintenance
      } else {
        // Deficit of 500 kcal, but clamped to minimum of 1200 kcal/day for safety
        final double deficit = _tdee! - 500;
        _targetCalories = deficit < 1200.0 ? 1200.0 : deficit;
      }

      final newEntry = {
        'value': _bmiResult,
        'category': _category,
        'date': DateTime.now().toIso8601String(),
        'height': _height,
        'weight': _weight,
        'age': _age,
        'gender': _gender,
        'bmr': _bmr,
        'tdee': _tdee,
        'targetCalories': _targetCalories,
      };

      _bmiBox.add(newEntry);
      loadHistory();
      notifyListeners();
    }
  }

  String _getBMICategory(double bmi) {
    if (bmi < 18.5) {
      return "Underweight";
    } else if (bmi < 24.9) {
      return "Normal Weight";
    } else if (bmi < 29.9) {
      return "Overweight";
    } else {
      return "Obesity";
    }
  }
}
