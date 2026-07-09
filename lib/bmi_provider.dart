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

  double? get bmiResult => _bmiResult;
  String? get category => _category;
  String? get height => _height;
  String? get weight => _weight;

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

  void calculateAndSave(String heightStr, String weightStr) {
    final double? heightVal = double.tryParse(heightStr);
    final double? weightVal = double.tryParse(weightStr);

    if (heightVal != null &&
        heightVal > 0 &&
        weightVal != null &&
        weightVal > 0) {
      _height = heightStr;
      _weight = weightStr;

      final double heightInMeters = heightVal / 100;
      final double bmi = weightVal / (heightInMeters * heightInMeters);

      _bmiResult = bmi;
      _category = _getBMICategory(bmi);

      final newEntry = {
        'value': _bmiResult,
        'category': _category,
        'date': DateTime.now().toIso8601String(),
        'height': _height,
        'weight': _weight,
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
