import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_border_width.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';

const _dotSize = 12.0;
const _selectedDotWidth = 30.0;
const _dotDuration = Duration(milliseconds: 200);

class PhasePageDots extends StatelessWidget {
  const PhasePageDots({
    required this.count,
    required this.onDotTapped,
    required this.selectedIndex,
    super.key,
    this.lockedIndices = const {},
  });

  final int count;
  final Set<int> lockedIndices;
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
            child: _PageDot(isSelected: index == selectedIndex, isLocked: lockedIndices.contains(index)),
          ),
      ],
    );
  }
}

class _PageDot extends StatelessWidget {
  const _PageDot({required this.isSelected, required this.isLocked});

  final bool isLocked;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: _dotSize,
      duration: _dotDuration,
      width: isSelected ? _selectedDotWidth : _dotSize,
      decoration: BoxDecoration(
        borderRadius: AppRadius.pill,
        color: switch ((isSelected, isLocked)) {
          (true, _) => AppColors.grass400,
          (false, true) => AppColors.surface400,
          (false, false) => AppColors.surface100,
        },
        border: Border.all(color: isSelected ? AppColors.grass600 : AppColors.surface400, width: AppBorderWidth.thin),
      ),
    );
  }
}
