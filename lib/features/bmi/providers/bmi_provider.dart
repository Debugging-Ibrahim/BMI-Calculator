import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BMIProvider extends ChangeNotifier {
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

  StreamSubscription<QuerySnapshot>? _historySubscription;

  BMIProvider() {
    // Listen to Firebase Auth state changes to automatically bind/unbind user BMI logs
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        _listenToHistory(user.uid);
      } else {
        _history = [];
        _historySubscription?.cancel();
        _historySubscription = null;
        notifyListeners();
      }
    });
  }

  void _listenToHistory(String uid) {
    _historySubscription?.cancel();
    _historySubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('history')
        .orderBy('date', descending: true)
        .snapshots()
        .listen((snapshot) {
      _history = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'value': (data['value'] as num?)?.toDouble(),
          'category': data['category'],
          'date': data['date'],
          'height': data['height'],
          'weight': data['weight'],
          'age': data['age'],
          'gender': data['gender'],
          'bmr': (data['bmr'] as num?)?.toDouble(),
          'tdee': (data['tdee'] as num?)?.toDouble(),
          'targetCalories': (data['targetCalories'] as num?)?.toDouble(),
        };
      }).toList();
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _historySubscription?.cancel();
    super.dispose();
  }

  void calculateAndSave(String heightStr, String weightStr, int age, String gender) async {
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

      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
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

        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('history')
              .add(newEntry);
        } catch (e) {
          debugPrint('Failed to save BMI entry to Firestore: $e');
        }
      }
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
