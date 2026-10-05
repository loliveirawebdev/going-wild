import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_border_width.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';

const _optionMinimumWidth = 40.0;
const _selectionDuration = Duration(milliseconds: 120);

const _optionStyle = TextStyle(
  fontSize: 16,
  height: 18 / 16,
  color: AppColors.ink,
  fontFamily: AppFonts.display,
  fontWeight: FontWeight.w400,
);

class SpeedSelector extends StatelessWidget {
  const SpeedSelector({required this.multiplier, required this.onChanged, super.key, this.multipliers = const [1, 2, 4]});

  final int multiplier;
  final List<int> multipliers;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.surface300,
        borderRadius: AppRadius.pill,
        border: Border.all(color: AppColors.surface400, width: AppBorderWidth.thick),
      ),
      child: Row(
        spacing: 2,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final option in multipliers)
            _SpeedOption(
              multiplier: option,
              isSelected: option == multiplier,
              onSelected: () => onChanged(option),
            ),
        ],
      ),
    );
  }
}

class _SpeedOption extends StatelessWidget {
  const _SpeedOption({required this.multiplier, required this.isSelected, required this.onSelected});

  final int multiplier;
  final bool isSelected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final optionColor = isSelected ? AppColors.sky300 : AppColors.surface300.withValues(alpha: 0);

    return Semantics(
      button: true,
      selected: isSelected,
      child: GestureDetector(
        onTap: onSelected,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: _selectionDuration,
          alignment: Alignment.center,
          constraints: const BoxConstraints(minWidth: _optionMinimumWidth),
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            color: optionColor,
            borderRadius: AppRadius.pill,
            border: Border.all(color: isSelected ? AppColors.surface400 : optionColor, width: AppBorderWidth.thin),
          ),
          child: Text('$multiplier×', style: _optionStyle),
        ),
      ),
    );
  }
}
