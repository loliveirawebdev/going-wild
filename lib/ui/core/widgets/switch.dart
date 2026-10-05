import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_border_width.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';

const _trackWidth = 56.0;
const _trackHeight = 32.0;
const _knobInset = 3.0;
const _toggleDuration = Duration(milliseconds: 120);
const _knobDiameter = _trackHeight - AppBorderWidth.thick * 2 - _knobInset * 2;

const _labelStyle = TextStyle(
  fontSize: 15,
  height: 21 / 15,
  color: AppColors.ink,
  fontFamily: AppFonts.sans,
  fontWeight: FontWeight.w700,
);

class Switch extends StatelessWidget {
  const Switch({required this.label, required this.isOn, required this.onChanged, super.key, this.showsLabel = true});

  final bool isOn;
  final String label;
  final bool showsLabel;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final edgeColor = isOn ? AppColors.grass600 : AppColors.surface400;

    return Semantics(
      container: true,
      toggled: isOn,
      label: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onChanged(!isOn),
        child: Row(
          spacing: AppSpacing.space3,
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              width: _trackWidth,
              height: _trackHeight,
              duration: _toggleDuration,
              decoration: BoxDecoration(
                borderRadius: AppRadius.pill,
                color: isOn ? AppColors.grass400 : AppColors.surface300,
                border: Border.all(color: edgeColor, width: AppBorderWidth.thick),
              ),
              child: AnimatedAlign(
                duration: _toggleDuration,
                alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(_knobInset),
                  child: AnimatedContainer(
                    width: _knobDiameter,
                    height: _knobDiameter,
                    duration: _toggleDuration,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surface100,
                      border: Border.all(color: edgeColor, width: AppBorderWidth.thick),
                    ),
                  ),
                ),
              ),
            ),
            if (showsLabel) Flexible(child: Text(label, style: _labelStyle)),
          ],
        ),
      ),
    );
  }
}
