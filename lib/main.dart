import 'package:digital_khata/bmi_provider.dart';
import 'package:digital_khata/home_screen.dart';
import 'package:digital_khata/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  final bmiProvider = BMIProvider();
  await bmiProvider.initHive();

  runApp(
    ChangeNotifierProvider(
      create: (context) => bmiProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
