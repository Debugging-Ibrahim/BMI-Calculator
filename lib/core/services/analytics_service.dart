import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  
  static FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  /// Log User Signup event
  static Future<void> logSignUp(String signUpMethod) async {
    try {
      await _analytics.logSignUp(signUpMethod: signUpMethod);
      debugPrint("Analytics: Logged SignUp event via $signUpMethod.");
    } catch (e) {
      debugPrint("Analytics error logging signUp: $e");
    }
  }

  /// Log User Login event
  static Future<void> logLogin(String loginMethod) async {
    try {
      await _analytics.logLogin(loginMethod: loginMethod);
      debugPrint("Analytics: Logged Login event via $loginMethod.");
    } catch (e) {
      debugPrint("Analytics error logging login: $e");
    }
  }

  /// Log custom BMI Calculated event
  static Future<void> logBmiCalculated({
    required double bmi,
    required String category,
    required double height,
    required double weight,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'bmi_calculated',
        parameters: {
          'bmi_value': bmi,
          'category': category,
          'height': height,
          'weight': weight,
        },
      );
      debugPrint("Analytics: Logged bmi_calculated event (BMI: $bmi, Category: $category).");
    } catch (e) {
      debugPrint("Analytics error logging bmi_calculated: $e");
    }
  }
}
