import 'package:digital_khata/features/bmi/widgets/selection_container.dart';
import 'package:flutter/material.dart';

class HeightSelectionCard extends StatelessWidget {
  final String selectedUnit;
  final double currentValue;
  final double minHeight;
  final double maxHeight;
  final int divisions;
  final Function(String) onUnitChanged;
  final Function(double) onHeightChanged;

  const HeightSelectionCard({
    super.key,
    required this.selectedUnit,
    required this.currentValue,
    required this.minHeight,
    required this.maxHeight,
    required this.divisions,
    required this.onUnitChanged,
    required this.onHeightChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 200,
      width: 375,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: theme.cardColor,
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
                Text(
                  "Height",
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    RoundedUnitSelectionContainer(
                      selected: selectedUnit == 'In',
                      text: 'In',
                      onTap: () => onUnitChanged('In'),
                    ),
                    const SizedBox(width: 8),
                    RoundedUnitSelectionContainer(
                      selected: selectedUnit == 'Ft',
                      text: 'Ft',
                      onTap: () => onUnitChanged('Ft'),
                    ),
                    const SizedBox(width: 8),
                    RoundedUnitSelectionContainer(
                      selected: selectedUnit == 'Cm',
                      text: 'Cm',
                      onTap: () => onUnitChanged('Cm'),
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
                selectedUnit == 'Ft'
                    ? currentValue.toStringAsFixed(1)
                    : currentValue.round().toString(),
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
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
                  value: currentValue,
                  min: minHeight,
                  max: maxHeight,
                  divisions: divisions,
                  activeColor: isDark ? Colors.white70 : Colors.black54,
                  inactiveColor: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                  thumbColor: theme.primaryColor,
                  onChanged: onHeightChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
