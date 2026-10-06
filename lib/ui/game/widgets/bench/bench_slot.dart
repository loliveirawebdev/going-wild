import 'package:flutter/widgets.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/design/app_border_width.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';
import 'package:going_wild/ui/core/localization/character_name.dart';
import 'package:going_wild/ui/game/widgets/bench/bench_unit.dart';
import 'package:going_wild/ui/game/widgets/summon/summon_appear.dart';

const _innerRadius = BorderRadius.all(Radius.circular(8 - AppBorderWidth.thin));
const _dropTargetDuration = Duration(milliseconds: 120);
final _dropTargetFill = Color.lerp(AppColors.surface300, AppColors.grass400, 0.35)!;

class BenchSlot extends StatelessWidget {
  const BenchSlot({
    required this.slotNumber,
    required this.nameOpacity,
    required this.characterCopy,
    super.key,
    this.onPressed,
    this.summonId,
    this.isDropTarget = false,
  });

  final int? summonId;
  final int slotNumber;
  final bool isDropTarget;
  final double nameOpacity;
  final VoidCallback? onPressed;
  final CharacterCopy? characterCopy;

  @override
  Widget build(BuildContext context) {
    final characterCopy = this.characterCopy;

    return Semantics(
      container: true,
      button: onPressed != null,
      label: _semanticLabelOf(context),
      child: GestureDetector(
        onTap: onPressed,
        child: ExcludeSemantics(
          child: AnimatedContainer(
            duration: _dropTargetDuration,
            decoration: BoxDecoration(
              borderRadius: AppRadius.small,
              color: isDropTarget ? _dropTargetFill : AppColors.surface300,
              border: Border.all(color: isDropTarget ? AppColors.grass600 : AppColors.surface400, width: AppBorderWidth.thin),
            ),
            child: characterCopy == null
                ? null
                : SummonAppear(
                    summonId: summonId,
                    child: ClipRRect(
                      borderRadius: _innerRadius,
                      child: BenchUnit(nameOpacity: nameOpacity, characterCopy: characterCopy),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  String _semanticLabelOf(BuildContext context) {
    final translations = context.t.game.bench;
    final characterCopy = this.characterCopy;
    if (characterCopy == null) return translations.emptySlot(slot: slotNumber);

    return translations.occupiedSlot(
      slot: slotNumber,
      name: characterNameOf(context.t, characterCopy.character),
      stars: translations.stars(count: characterCopy.stars),
    );
  }
}
