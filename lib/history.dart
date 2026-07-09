import 'package:digital_khata/bmi_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text("BMI History", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Consumer<BMIProvider>(
        builder: (context, provider, child) {
          final historyList = provider.history;

          if (historyList.isEmpty) {
            return const Center(
              child: Text(
                "No past calculations found.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(15.0),
            itemCount: historyList.length,
            itemBuilder: (context, index) {
              final entry = historyList[index];
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

              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.amber.shade200,
                    child: Text(
                      bmi.toStringAsFixed(1),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  title: Text(
                    category,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Height: ${height}cm | Weight: ${weight}kg\nCalculated on: $formattedDate",
                    style: const TextStyle(fontSize: 12),
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
