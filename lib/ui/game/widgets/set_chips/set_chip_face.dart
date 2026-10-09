import 'package:flutter/widgets.dart';
import 'package:going_wild/domain/models/set/set_id.dart';
import 'package:going_wild/ui/core/design/app_border_width.dart';
import 'package:going_wild/ui/core/design/app_color_filters.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';
import 'package:going_wild/ui/core/widgets/set_icon_image.dart';
import 'package:going_wild/ui/game/widgets/set_chips/celebration/set_chip_shine.dart';
import 'package:going_wild/ui/game/widgets/set_chips/set_chip_tone.dart';

const _faceBaseHeight = 4.0;
final _faceInnerRadius = AppRadius.insideBorderOf(AppRadius.medium, borderWidth: AppBorderWidth.thick);

class SetChipFace extends StatelessWidget {
  final SetId setId;
  final bool isComplete;
  final SetChipTone tone;
  final Animation<double>? shineCycle;
  const SetChipFace({required this.tone, required this.setId, required this.isComplete, required this.shineCycle, super.key});

  @override
  Widget build(BuildContext context) {
    final shineCycle = this.shineCycle;
    final isInactive = tone == SetChipTone.inactive;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: tone.faceColor,
        borderRadius: AppRadius.medium,
        border: Border.all(color: isComplete ? AppColors.ink : tone.edgeColor, width: AppBorderWidth.thick),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppBorderWidth.thick),
        child: ClipRRect(
          borderRadius: _faceInnerRadius,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (!isInactive)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: _faceBaseHeight,
                  child: ColoredBox(color: tone.edgeColor),
                ),
              Center(
                child: isInactive
                    ? ColorFiltered(colorFilter: AppColorFilters.inactiveIcon, child: SetIconImage(setId))
                    : SetIconImage(setId),
              ),
              if (shineCycle != null) SetChipShine(shineCycle: shineCycle),
            ],
          ),
        ),
      ),
    );
  }
}
