import 'package:digital_khata/features/bmi/providers/bmi_provider.dart';
import 'package:digital_khata/core/screens/splash_screen.dart';
import 'package:digital_khata/theme/theme.dart';
import 'package:digital_khata/theme/theme_provider.dart';
import 'package:digital_khata/core/providers/connectivity_provider.dart';
import 'package:digital_khata/core/widgets/connectivity_banner.dart';
import 'package:digital_khata/core/providers/unit_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:digital_khata/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final bmiProvider = BMIProvider();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => bmiProvider),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => ConnectivityProvider()),
        ChangeNotifierProvider(create: (context) => UnitProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          home: const SplashScreen(),
          builder: (context, child) {
            return Stack(
              children: [
                child!,
                const ConnectivityBanner(),
              ],
            );
          },
        );
      },
    );
  }
}
