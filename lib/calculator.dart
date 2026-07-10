import 'package:digital_khata/bmi_provider.dart';
import 'package:digital_khata/result_screen.dart';
import 'package:digital_khata/widgets/reusable_button.dart';
import 'package:digital_khata/widgets/selection_container.dart';
import 'package:digital_khata/widgets/weight_age_container.dart';
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
  double _currentvalue = 191;
  String _selectedUnit = 'Cm';
  int _weight = 65;
  int _age = 27;

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

    context.read<BMIProvider>().calculateAndSave(
      heightInCm.toStringAsFixed(1),
      _weight.toString(),
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ResultScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff151615),
      appBar: AppBar(
        backgroundColor: const Color(0xff151615),
        elevation: 0,
        leading: const Icon(
          Icons.hourglass_bottom_rounded,
          color: Color(0xffdafd87),
        ),
        actionsPadding: const EdgeInsets.only(right: 15),
        actions: const [Icon(Iconsax.setting_2, color: Colors.white, size: 20)],
        title: const Text(
          "BMI Calculator",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        _selectedGender = 'Male';
                      });
                    },
                    child: Container(
                      height: 200,
                      width: 175,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: _selectedGender == 'Male'
                            ? const Color(0xff262826)
                            : Colors.grey.shade900,
                        border: _selectedGender == 'Male'
                            ? Border.all(
                                color: const Color(0xffdafd87),
                                width: 1.5,
                              )
                            : Border.all(color: Colors.transparent),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Iconsax.man,
                            color: _selectedGender == 'Male'
                                ? const Color(0xffdafd87)
                                : Colors.white60,
                            size: 35,
                          ),
                          const SizedBox(height: 30),
                          Text(
                            "MALE",
                            style: TextStyle(
                              color: _selectedGender == 'Male'
                                  ? Colors.white
                                  : Colors.white60,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _selectedGender = 'Female';
                      });
                    },
                    child: Container(
                      height: 200,
                      width: 175,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: _selectedGender == 'Female'
                            ? const Color(0xff262826)
                            : Colors.grey.shade900,
                        border: _selectedGender == 'Female'
                            ? Border.all(
                                color: const Color(0xffdafd87),
                                width: 1.5,
                              )
                            : Border.all(color: Colors.transparent),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Iconsax.woman,
                            color: _selectedGender == 'Female'
                                ? const Color(0xffdafd87)
                                : Colors.white60,
                            size: 35,
                          ),
                          const SizedBox(height: 30),
                          Text(
                            "FEMALE",
                            style: TextStyle(
                              color: _selectedGender == 'Female'
                                  ? Colors.white
                                  : Colors.white60,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              Container(
                height: 200,
                width: 375,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade900,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Height",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Row(
                            children: [
                              RoundedUnitSelectionContainer(
                                selected: _selectedUnit == 'In',
                                text: 'In',
                                onTap: () {
                                  setState(() {
                                    _selectedUnit = 'In';
                                    _currentvalue = 75;
                                  });
                                },
                              ),
                              const SizedBox(width: 8),
                              RoundedUnitSelectionContainer(
                                selected: _selectedUnit == 'Ft',
                                text: 'Ft',
                                onTap: () {
                                  setState(() {
                                    _selectedUnit = 'Ft';
                                    _currentvalue = 6.2;
                                  });
                                },
                              ),
                              const SizedBox(width: 8),
                              RoundedUnitSelectionContainer(
                                selected: _selectedUnit == 'Cm',
                                text: 'Cm',
                                onTap: () {
                                  setState(() {
                                    _selectedUnit = 'Cm';
                                    _currentvalue = 191;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _selectedUnit == 'Ft'
                              ? _currentvalue.toStringAsFixed(1)
                              : _currentvalue.round().toString(),
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 2,
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 8,
                            ),
                            overlayShape: const RoundSliderOverlayShape(
                              overlayRadius: 16,
                            ),
                          ),
                          child: Slider(
                            value: _currentvalue,
                            min: _minHeight,
                            max: _maxHeight,
                            divisions: _divisions,
                            activeColor: Colors.white70,
                            inactiveColor: Colors.grey.shade800,
                            thumbColor: const Color(0xffdafd87),
                            onChanged: (double newVal) {
                              setState(() {
                                _currentvalue = newVal;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WeightAgeContainer(
                    textUp: 'Weight',
                    textBtm: 'kg',
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
