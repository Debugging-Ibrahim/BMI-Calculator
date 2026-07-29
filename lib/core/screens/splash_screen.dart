import 'dart:async';
import 'package:digital_khata/features/auth/screens/login_screen.dart';
import 'package:digital_khata/core/screens/home_screen.dart';
import 'package:digital_khata/features/onboarding/screens/onboarding_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () async {
      if (!mounted) return;

      final user = FirebaseAuth.instance.currentUser;
      final localPrefs = Provider.of<SharedPreferences?>(context, listen: false);
      bool hasSeenOnboarding = false;

      if (localPrefs != null) {
        hasSeenOnboarding = localPrefs.getBool('has_seen_onboarding_key') ?? false;
      } else {
        try {
          final prefs = await SharedPreferences.getInstance();
          hasSeenOnboarding = prefs.getBool('has_seen_onboarding_key') ?? false;
        } catch (e) {
          debugPrint("Fallback loading of SharedPreferences failed in splash screen: $e");
        }
      }

      if (!mounted) return;

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else if (!hasSeenOnboarding) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    Icons.hourglass_bottom_rounded,
                    color: theme.brightness == Brightness.dark ? Colors.black : Colors.white,
                    size: 45,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "BMI Calculator",
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
