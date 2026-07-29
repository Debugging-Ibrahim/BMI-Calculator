import 'package:digital_khata/features/auth/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingProvider extends ChangeNotifier {
  final PageController pageController = PageController();
  int _currentPage = 0;
  int get currentPage => _currentPage;

  double _sliderValue = 22.0;
  double get sliderValue => _sliderValue;
  final SharedPreferences? _prefs;

  OnboardingProvider(this._prefs);

  void setCurrentPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  void setSliderValue(double value) {
    _sliderValue = value;
    notifyListeners();
  }

  void nextPage() {
    if (_currentPage < 3) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> completeOnboarding(BuildContext context) async {
    if (_prefs != null) {
      try {
        await _prefs.setBool('has_seen_onboarding_key', true);
      } catch (e) {
        debugPrint("Error saving onboarding key to SharedPreferences: $e");
      }
    }
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
