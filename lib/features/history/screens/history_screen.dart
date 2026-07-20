import 'package:digital_khata/features/auth/screens/login_screen.dart';
import 'package:digital_khata/features/bmi/providers/bmi_provider.dart';
import 'package:digital_khata/features/history/widgets/bmi_line_chart.dart';
import 'package:digital_khata/features/history/widgets/history_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final onSurface = theme.colorScheme.onSurface;

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
            icon: Icon(Icons.logout, color: onSurface, size: 20),
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
          "History",
          style: TextStyle(color: onSurface, fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<BMIProvider>(
        builder: (context, provider, child) {
          final historyList = provider.history;

          if (historyList.isEmpty) {
            return Center(
              child: Text(
                "No past calculations found.",
                style: TextStyle(fontSize: 18, color: isDark ? Colors.white60 : Colors.black54),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(15.0),
            itemCount: historyList.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BmiLineChart(history: historyList),
                      const SizedBox(height: 20),
                      Text(
                        "Past Records",
                        style: TextStyle(
                          color: onSurface,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }

              final entry = historyList[index - 1];
              final double bmi = entry['value'] ?? 0.0;
              final String category = entry['category'] ?? 'N/A';
              final String height = entry['height'] ?? '0';
              final String weight = entry['weight'] ?? '0';

              // Formatting the date saved in ISO string
              final String rawDate = entry['date'] ?? '';
              String formattedDate = 'Unknown Date';
              if (rawDate.isNotEmpty) {
                final date = DateTime.parse(rawDate);
                formattedDate =
                    "${date.day}/${date.month}/${date.year} at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
              }

              return HistoryCard(
                bmi: bmi,
                category: category,
                height: height,
                weight: weight,
                formattedDate: formattedDate,
              );
            },
          );
        },
      ),
    );
  }
}
