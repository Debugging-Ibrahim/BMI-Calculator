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

  // Filter States
  final TextEditingController searchController = TextEditingController();
  String _searchQuery = "";
  String get searchQuery => _searchQuery;

  String _selectedDateRange = "All Time";
  String get selectedDateRange => _selectedDateRange;

  String _selectedCategory = "All Categories";
  String get selectedCategory => _selectedCategory;

  void setSelectedDateRange(String dateRange) {
    if (_selectedDateRange != dateRange) {
      _selectedDateRange = dateRange;
      notifyListeners();
    }
  }

  void setSelectedCategory(String category) {
    if (_selectedCategory != category) {
      _selectedCategory = category;
      notifyListeners();
    }
  }

  void clearFilters() {
    searchController.clear();
    _searchQuery = "";
    _selectedDateRange = "All Time";
    _selectedCategory = "All Categories";
    notifyListeners();
  }

  List<Map<dynamic, dynamic>> get filteredHistory {
    return _history.where((entry) {
      // 1. Filter by Date Range
      if (_selectedDateRange != "All Time") {
        final rawDate = entry['date'] ?? '';
        if (rawDate.isEmpty) return false;
        final date = DateTime.tryParse(rawDate);
        if (date == null) return false;

        final cutoffDays = _selectedDateRange == "7 Days" ? 7 : 30;
        final cutoffDate = DateTime.now().subtract(Duration(days: cutoffDays));
        if (date.isBefore(cutoffDate)) {
          return false;
        }
      }

      // 2. Filter by Category Chip
      if (_selectedCategory != "All Categories") {
        final String category = (entry['category'] ?? '').toString().toLowerCase();
        if (category != _selectedCategory.toLowerCase()) {
          return false;
        }
      }

      // 3. Filter by Search Query (BMI Category & Value)
      if (_searchQuery.isNotEmpty) {
        final String category = (entry['category'] ?? '').toLowerCase();
        final double value = entry['value'] ?? 0.0;
        final String valueStr = value.toString();
        final String valueFixedStr = value.toStringAsFixed(1);

        final matchesCategory = category.contains(_searchQuery);
        final matchesValue = valueStr.contains(_searchQuery) || valueFixedStr.contains(_searchQuery);

        if (!matchesCategory && !matchesValue) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  BMIProvider() {
    searchController.addListener(() {
      final query = searchController.text.trim().toLowerCase();
      if (_searchQuery != query) {
        _searchQuery = query;
        notifyListeners();
      }
    });

    // Listen to Firebase Auth state changes to automatically bind/unbind user BMI logs
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        _listenToHistory(user.uid);
      } else {
        _history = [];
        _historySubscription?.cancel();
        _historySubscription = null;
        clearFilters();
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
    searchController.dispose();
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

  Future<void> deleteHistoryEntry(String entryId) async {
    final index = _history.indexWhere((entry) => entry['id'] == entryId);
    if (index != -1) {
      _history.removeAt(index);
      notifyListeners();
    }

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('history')
            .doc(entryId)
            .delete();
      } catch (e) {
        debugPrint('Failed to delete BMI entry from Firestore: $e');
      }
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
