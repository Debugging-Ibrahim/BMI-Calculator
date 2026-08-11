import 'package:digital_khata/features/onboarding/providers/onboarding_provider.dart';
import 'package:digital_khata/features/onboarding/widgets/onboarding_page_template.dart';
import 'package:digital_khata/features/onboarding/widgets/onboarding_animation.dart';
import 'package:digital_khata/features/onboarding/widgets/bmi_zone_explorer.dart';
import 'package:digital_khata/features/onboarding/widgets/onboarding_unit_selection.dart';
import 'package:digital_khata/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Consumer<OnboardingProvider>(
      builder: (context, provider, child) {
        final currentPage = provider.currentPage;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: SafeArea(
            child: Column(
              children: [
                // Top Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (currentPage < 3)
                        TextButton(
                          onPressed: () => provider.completeOnboarding(context),
                          child: Text(
                            l10n?.skip ?? "Skip",
                            style: TextStyle(
                              color: isDark ? Colors.white60 : Colors.black54,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      else
                        const SizedBox(height: 48), // Empty placeholder
                    ],
                  ),
                ),

                // Page Slider
                Expanded(
                  child: PageView(
                    controller: provider.pageController,
                    onPageChanged: (index) {
                      provider.setCurrentPage(index);
                    },
                    children: [
                      OnboardingPageTemplate(
                        title: l10n?.onboardingTitle1 ?? "Welcome to Kinetik",
                        description: l10n?.onboardingDesc1 ?? "Monitor your body mass index, analyze trends chronologically, and take control of your health journey.",
                        child: const OnboardingAnimation(assetPath: "assets/OB1 - Graph Lottie Animation.json"),
                      ),
                      OnboardingPageTemplate(
                        title: l10n?.onboardingTitle2 ?? "Explore BMI Classifications",
                        description: l10n?.onboardingDesc2 ?? "Learn how weight classes correspond to health metrics and understand your target ranges.",
                        child: const BmiZoneExplorer(),
                      ),
                      OnboardingPageTemplate(
                        title: l10n?.onboardingTitle3 ?? "Select Measurement Units",
                        description: l10n?.onboardingDesc3 ?? "Choose your preferred unit standard. This setting automatically configures all future inputs.",
                        child: const OnboardingUnitSelection(),
                      ),
                      OnboardingPageTemplate(
                        title: l10n?.onboardingTitle4 ?? "Safe Cloud Synchronization",
                        description: l10n?.onboardingDesc4 ?? "Access and sync logs securely across all your devices, with local offline fallback options.",
                        child: const OnboardingAnimation(assetPath: "assets/OB4 - data cloud upload backup.json"),
                      ),
                    ],
                  ),
                ),

                // Bottom Navigation Area
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Smooth indicator dots
                      Row(
                        children: List.generate(
                          4,
                          (index) => _buildDot(index, currentPage, context),
                        ),
                      ),

                      // Next / Get Started button
                      ElevatedButton(
                        onPressed: () {
                          if (currentPage < 3) {
                            provider.nextPage();
                          } else {
                            provider.completeOnboarding(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          foregroundColor: isDark ? Colors.black : Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          currentPage == 3 ? (l10n?.getStarted ?? "Get Started") : (l10n?.next ?? "Next"),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDot(int index, int currentPage, BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isActive = index == currentPage;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: isActive ? 24.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive
            ? theme.primaryColor
            : (isDark ? Colors.white24 : Colors.black12),
        borderRadius: BorderRadius.circular(4.0),
      ),
    );
  }
}
