import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:digital_khata/core/constants/app_constants.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark; // Default is Dark mode
  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;
  StreamSubscription<User?>? _authSubscription;
  final SharedPreferences? _prefs;

  ThemeProvider(this._prefs) {
    _loadThemeFromPrefs();
    _listenToAuthChanges();
  }

  void _listenToAuthChanges() {
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        try {
          final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
          if (doc.exists && doc.data() != null) {
            final data = doc.data()!;
            if (data.containsKey('isDarkMode')) {
              final bool isDark = data['isDarkMode'] as bool;
              if (_themeMode != (isDark ? ThemeMode.dark : ThemeMode.light)) {
                _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
                notifyListeners();
              }
            }
          }
        } catch (e) {
          debugPrint("Error fetching theme preference from Firestore: $e");
        }
      } else {
        // Fallback to local theme when user logs out
        _loadThemeFromPrefs();
      }
    });
  }

  Future<void> _loadThemeFromPrefs() async {
    try {
      final prefs = _prefs ?? await SharedPreferences.getInstance();
      final isDark = prefs.getBool(AppConstants.themeModeKey) ?? true;
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading theme from SharedPreferences: $e");
    }
  }

  Future<void> toggleTheme(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    try {
      final prefs = _prefs ?? await SharedPreferences.getInstance();
      await prefs.setBool(AppConstants.themeModeKey, isDark);
    } catch (e) {
      debugPrint("Error saving theme to SharedPreferences: $e");
    }

    // Save to Firestore if user is logged in
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'isDarkMode': isDark,
        });
      } catch (e) {
        debugPrint("Error updating theme preference in Firestore: $e");
      }
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
