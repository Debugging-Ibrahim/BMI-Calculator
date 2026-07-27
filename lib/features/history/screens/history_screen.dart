import 'package:digital_khata/features/auth/screens/login_screen.dart';
import 'package:digital_khata/features/bmi/providers/bmi_provider.dart';
import 'package:digital_khata/features/history/widgets/bmi_line_chart.dart';
import 'package:digital_khata/features/history/widgets/history_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  List<SectionItem> _buildSectionItems(List<Map<dynamic, dynamic>> filteredList) {
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));

    final last7Days = <Map<dynamic, dynamic>>[];
    final last30Days = <Map<dynamic, dynamic>>[];
    final older = <Map<dynamic, dynamic>>[];

    for (var entry in filteredList) {
      final rawDate = entry['date'] ?? '';
      if (rawDate.isEmpty) {
        older.add(entry);
        continue;
      }
      final date = DateTime.tryParse(rawDate);
      if (date == null) {
        older.add(entry);
        continue;
      }

      if (date.isAfter(sevenDaysAgo)) {
        last7Days.add(entry);
      } else if (date.isAfter(thirtyDaysAgo)) {
        last30Days.add(entry);
      } else {
        older.add(entry);
      }
    }

    final items = <SectionItem>[];
    if (last7Days.isNotEmpty) {
      items.add(SectionItem(title: "Last 7 Days", isHeader: true));
      for (var r in last7Days) {
        items.add(SectionItem(title: "Last 7 Days", isHeader: false, record: r));
      }
    }
    if (last30Days.isNotEmpty) {
      items.add(SectionItem(title: "Last 30 Days", isHeader: true));
      for (var r in last30Days) {
        items.add(SectionItem(title: "Last 30 Days", isHeader: false, record: r));
      }
    }
    if (older.isNotEmpty) {
      items.add(SectionItem(title: "Older Records", isHeader: true));
      for (var r in older) {
        items.add(SectionItem(title: "Older Records", isHeader: false, record: r));
      }
    }

    return items;
  }

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
          final originalHistory = provider.history;
          final filteredHistory = provider.filteredHistory;
          final sectionItems = _buildSectionItems(filteredHistory);

          if (originalHistory.isEmpty) {
            return Center(
              child: Text(
                "No past calculations found.",
                style: TextStyle(fontSize: 18, color: isDark ? Colors.white60 : Colors.black54),
              ),
            );
          }

          return Column(
            children: [
              // Search & Filter Panel
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Bar
                    TextField(
                      controller: provider.searchController,
                      style: TextStyle(color: onSurface),
                      decoration: InputDecoration(
                        hintText: "Search Category or BMI Value...",
                        hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.black38),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: isDark ? Colors.white38 : Colors.black38,
                        ),
                        suffixIcon: provider.searchController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.clear_rounded,
                                  color: isDark ? Colors.white54 : Colors.black54,
                                ),
                                onPressed: () {
                                  provider.searchController.clear();
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.03),
                        contentPadding: const EdgeInsets.symmetric(vertical: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: theme.primaryColor.withValues(alpha: 0.5),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Date range chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip(
                            context,
                            "All Time",
                            provider.selectedDateRange == "All Time",
                            () => provider.setSelectedDateRange("All Time"),
                          ),
                          const SizedBox(width: 8),
                          _buildFilterChip(
                            context,
                            "Last 7 Days",
                            provider.selectedDateRange == "7 Days",
                            () => provider.setSelectedDateRange("7 Days"),
                          ),
                          const SizedBox(width: 8),
                          _buildFilterChip(
                            context,
                            "Last 30 Days",
                            provider.selectedDateRange == "30 Days",
                            () => provider.setSelectedDateRange("30 Days"),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Category chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip(
                            context,
                            "All Categories",
                            provider.selectedCategory == "All Categories",
                            () => provider.setSelectedCategory("All Categories"),
                          ),
                          const SizedBox(width: 8),
                          _buildFilterChip(
                            context,
                            "Underweight",
                            provider.selectedCategory == "Underweight",
                            () => provider.setSelectedCategory("Underweight"),
                          ),
                          const SizedBox(width: 8),
                          _buildFilterChip(
                            context,
                            "Normal",
                            provider.selectedCategory == "Normal Weight",
                            () => provider.setSelectedCategory("Normal Weight"),
                          ),
                          const SizedBox(width: 8),
                          _buildFilterChip(
                            context,
                            "Overweight",
                            provider.selectedCategory == "Overweight",
                            () => provider.setSelectedCategory("Overweight"),
                          ),
                          const SizedBox(width: 8),
                          _buildFilterChip(
                            context,
                            "Obese",
                            provider.selectedCategory == "Obesity",
                            () => provider.setSelectedCategory("Obesity"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Results List / Trend Line
              Expanded(
                child: filteredHistory.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: 64,
                              color: isDark ? Colors.white24 : Colors.black26,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "No matching records found.",
                              style: TextStyle(
                                fontSize: 16,
                                color: isDark ? Colors.white54 : Colors.black54,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(15.0),
                        itemCount: sectionItems.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: BmiLineChart(history: filteredHistory),
                            );
                          }

                          final item = sectionItems[index - 1];

                          if (item.isHeader) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                              child: Text(
                                item.title,
                                style: TextStyle(
                                  color: theme.primaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            );
                          }

                          final entry = item.record!;
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
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    String label,
    bool isSelected,
    VoidCallback onSelected,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          onSelected();
        }
      },
      selectedColor: theme.primaryColor,
      backgroundColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.03),
      labelStyle: TextStyle(
        color: isSelected
            ? Colors.white
            : (isDark ? Colors.white70 : Colors.black54),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      elevation: 0,
      pressElevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide.none,
      ),
    );
  }
}

class SectionItem {
  final String title;
  final bool isHeader;
  final Map<dynamic, dynamic>? record;

  SectionItem({
    required this.title,
    required this.isHeader,
    this.record,
  });
}
