import 'package:flutter/widgets.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/design/app_border_width.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';
import 'package:going_wild/ui/core/localization/character_name.dart';
import 'package:going_wild/ui/game/widgets/bench/bench_unit.dart';

const _innerRadius = BorderRadius.all(Radius.circular(8 - AppBorderWidth.thin));

class BenchSlot extends StatelessWidget {
  final int slotNumber;
  final double nameOpacity;
  final VoidCallback? onPressed;
  final CharacterCopy? characterCopy;
  const BenchSlot({required this.slotNumber, required this.nameOpacity, required this.characterCopy, super.key, this.onPressed});

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
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface300,
              borderRadius: AppRadius.small,
              border: Border.all(color: AppColors.surface400, width: AppBorderWidth.thin),
            ),
            child: characterCopy == null
                ? null
                : ClipRRect(
                    borderRadius: _innerRadius,
                    child: BenchUnit(nameOpacity: nameOpacity, characterCopy: characterCopy),
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
