import 'package:digital_khata/features/bmi/providers/bmi_provider.dart';
import 'package:digital_khata/core/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:digital_khata/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
