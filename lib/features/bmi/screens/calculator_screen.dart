import 'package:digital_khata/features/auth/screens/login_screen.dart';
import 'package:digital_khata/features/bmi/providers/bmi_provider.dart';
import 'package:digital_khata/features/bmi/screens/result_screen.dart';
import 'package:digital_khata/core/widgets/reusable_button.dart';
import 'package:digital_khata/features/bmi/widgets/gender_selection_card.dart';
import 'package:digital_khata/features/bmi/widgets/height_selection_card.dart';
import 'package:digital_khata/features/bmi/widgets/weight_age_container.dart';
import 'package:digital_khata/core/providers/unit_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _selectedGender = 'Male';
  double _currentvalue = 170;
  String _selectedUnit = 'Cm';
  int _weight = 65;
  int _age = 27;
  UnitSystem? _lastUnitSystem;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final unitProvider = Provider.of<UnitProvider>(context);
    final currentSystem = unitProvider.unitSystem;

    if (_lastUnitSystem == null) {
      _lastUnitSystem = currentSystem;
      if (currentSystem == UnitSystem.imperial) {
        _selectedUnit = 'Ft';
        _currentvalue = 5.6; // ~170cm
        _weight = 143; // ~65kg
      } else {
        _selectedUnit = 'Cm';
        _currentvalue = 170.0;
        _weight = 65;
      }
    } else if (_lastUnitSystem != currentSystem) {
      _lastUnitSystem = currentSystem;
      if (currentSystem == UnitSystem.imperial) {
        // Metric -> Imperial
        _selectedUnit = 'Ft';
        _currentvalue = (_currentvalue / 30.48).clamp(3.0, 7.5);
        _weight = (_weight * 2.20462).round().clamp(22, 600);
      } else {
        // Imperial -> Metric
        if (_selectedUnit == 'Ft') {
          _currentvalue = (_currentvalue * 30.48).clamp(100.0, 220.0);
        } else if (_selectedUnit == 'In') {
          _currentvalue = (_currentvalue * 2.54).clamp(100.0, 220.0);
        }
        _selectedUnit = 'Cm';
        _weight = (_weight / 2.20462).round().clamp(10, 300);
      }
    }
  }

  double get _minHeight {
    if (_selectedUnit == 'Cm') return 100;
    if (_selectedUnit == 'Ft') return 3;
    return 36;
  }

  double get _maxHeight {
    if (_selectedUnit == 'Cm') return 220;
    if (_selectedUnit == 'Ft') return 7.5;
    return 90;
  }

  int get _divisions {
    if (_selectedUnit == 'Cm') return 120;
    if (_selectedUnit == 'Ft') return 45;
    return 54;
  }

  void _calculateAndNavigate() {
    double heightInCm = _currentvalue;
    if (_selectedUnit == 'In') {
      heightInCm = _currentvalue * 2.54;
    } else if (_selectedUnit == 'Ft') {
      heightInCm = _currentvalue * 30.48;
    }

    double weightInKg = _weight.toDouble();
    if (context.read<UnitProvider>().isImperial) {
      weightInKg = _weight / 2.20462;
    }

    context.read<BMIProvider>().calculateAndSave(
      heightInCm.toStringAsFixed(1),
      weightInKg.toStringAsFixed(1),
      _age,
      _selectedGender,
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ResultScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: Icon(
          Icons.hourglass_bottom_rounded,
          color: theme.primaryColor,
        ),
        actionsPadding: const EdgeInsets.only(right: 15),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: theme.colorScheme.onSurface, size: 20),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
          ),
        ],
        title: Text(
          "BMI Calculator",
          style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Column(
            children: [
              // Unit System Toggle Segmented Control
              Consumer<UnitProvider>(
                builder: (context, unitProvider, child) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => unitProvider.toggleUnitSystem(false),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: unitProvider.isMetric ? theme.primaryColor : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  "Metric (cm/kg)",
                                  style: TextStyle(
                                    color: unitProvider.isMetric
                                        ? (theme.brightness == Brightness.dark ? Colors.black : Colors.white)
                                        : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => unitProvider.toggleUnitSystem(true),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: unitProvider.isImperial ? theme.primaryColor : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  "Imperial (ft/lbs)",
                                  style: TextStyle(
                                    color: unitProvider.isImperial
                                        ? (theme.brightness == Brightness.dark ? Colors.black : Colors.white)
                                        : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // Gender Selection Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GenderSelectionCard(
                    gender: 'Male',
                    isSelected: _selectedGender == 'Male',
                    icon: Iconsax.man,
                    onTap: () => setState(() => _selectedGender = 'Male'),
                  ),
                  GenderSelectionCard(
                    gender: 'Female',
                    isSelected: _selectedGender == 'Female',
                    icon: Iconsax.woman,
                    onTap: () => setState(() => _selectedGender = 'Female'),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              // Height Slider Selection Card
              HeightSelectionCard(
                selectedUnit: _selectedUnit,
                currentValue: _currentvalue,
                minHeight: _minHeight,
                maxHeight: _maxHeight,
                divisions: _divisions,
                onUnitChanged: (unit) {
                  setState(() {
                    if (_selectedUnit == 'Cm' && unit == 'In') {
                      _currentvalue = (_currentvalue / 2.54).clamp(36.0, 90.0);
                    } else if (_selectedUnit == 'Cm' && unit == 'Ft') {
                      _currentvalue = (_currentvalue / 30.48).clamp(3.0, 7.5);
                    } else if (_selectedUnit == 'In' && unit == 'Cm') {
                      _currentvalue = (_currentvalue * 2.54).clamp(100.0, 220.0);
                    } else if (_selectedUnit == 'In' && unit == 'Ft') {
                      _currentvalue = (_currentvalue / 12.0).clamp(3.0, 7.5);
                    } else if (_selectedUnit == 'Ft' && unit == 'Cm') {
                      _currentvalue = (_currentvalue * 30.48).clamp(100.0, 220.0);
                    } else if (_selectedUnit == 'Ft' && unit == 'In') {
                      _currentvalue = (_currentvalue * 12.0).clamp(36.0, 90.0);
                    }
                    _selectedUnit = unit;
                  });
                },
                onHeightChanged: (newVal) {
                  setState(() {
                    _currentvalue = newVal;
                  });
                },
              ),
              const SizedBox(height: 15),

              // Weight and Age Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WeightAgeContainer(
                    textUp: 'Weight',
                    textBtm: context.watch<UnitProvider>().isImperial ? 'lbs' : 'kg',
                    value: _weight,
                    onIncrement: () {
                      setState(() {
                        _weight++;
                      });
                    },
                    onDecrement: () {
                      setState(() {
                        if (_weight > 10) _weight--;
                      });
                    },
                  ),
                  WeightAgeContainer(
                    textUp: 'Age',
                    textBtm: 'Year',
                    value: _age,
                    onIncrement: () {
                      setState(() {
                        _age++;
                      });
                    },
                    onDecrement: () {
                      setState(() {
                        if (_age > 1) _age--;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 25),

              ReUsableButton(
                text: 'Calculate',
                icon: Iconsax.repeat_circle,
                onTap: _calculateAndNavigate,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
