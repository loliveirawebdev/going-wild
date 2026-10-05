import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_border_width.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';

const _dotSize = 12.0;
const _selectedDotWidth = 30.0;
const _dotDuration = Duration(milliseconds: 200);

class PhasePageDots extends StatelessWidget {
  const PhasePageDots({required this.count, required this.onDotTapped, required this.selectedIndex, super.key});

  final int count;
  final int selectedIndex;
  final ValueChanged<int> onDotTapped;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppSpacing.space2,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var index = 0; index < count; index++)
          GestureDetector(
            onTap: () => onDotTapped(index),
            child: _PageDot(isSelected: index == selectedIndex),
          ),
      ],
    );
  }
}

class _PageDot extends StatelessWidget {
  const _PageDot({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: _dotSize,
      duration: _dotDuration,
      width: isSelected ? _selectedDotWidth : _dotSize,
      decoration: BoxDecoration(
        borderRadius: AppRadius.pill,
        color: isSelected ? AppColors.grass400 : AppColors.surface100,
        border: Border.all(color: isSelected ? AppColors.grass600 : AppColors.surface400, width: AppBorderWidth.thin),
      ),
    );
  }
}
