import 'package:digital_khata/features/bmi/screens/calculator_screen.dart';
import 'package:digital_khata/features/history/screens/history_screen.dart';
import 'package:digital_khata/features/profile/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:digital_khata/l10n/app_localizations.dart';
import 'package:iconsax/iconsax.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const CalculatorScreen(),
    const HistoryScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: IndexedStack(index: _currentIndex, children: _screens),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: theme.cardColor,
        currentIndex: _currentIndex,
        selectedItemColor: theme.primaryColor,
        unselectedItemColor: isDark ? Colors.grey : Colors.grey.shade600,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Iconsax.calculator),
            label: l10n?.bmiCalculator ?? 'Calculator',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.history),
            label: l10n?.history ?? 'History',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Iconsax.user),
            label: l10n?.profile ?? 'Profile',
          ),
        ],
      ),
    );
  }
}
