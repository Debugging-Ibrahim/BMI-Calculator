import 'package:digital_khata/core/providers/connectivity_provider.dart';
import 'package:flutter/material.dart';
import 'package:digital_khata/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ConnectivityBanner extends StatelessWidget {
  const ConnectivityBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isOffline = context.watch<ConnectivityProvider>().isOffline;
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
      top: isOffline ? statusBarHeight + 10 : -80,
      left: 15,
      right: 15,
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xff2d1715) : const Color(0xfffde8e8),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? Colors.redAccent.withValues(alpha: 0.5) : Colors.redAccent.withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(
                Icons.wifi_off_rounded,
                color: Colors.redAccent,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n?.noInternetConnection ?? "No Internet Connection",
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xff9b1c1c),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
