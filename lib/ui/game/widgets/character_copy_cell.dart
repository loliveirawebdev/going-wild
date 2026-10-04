import 'package:flutter/material.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/localization/character_name.dart';
import 'package:going_wild/ui/game/widgets/attack_range_label.dart';

class CharacterCopyCell extends StatelessWidget {
  const CharacterCopyCell({
    required this.isEnemy,
    required this.isSelected,
    required this.characterCopy,
    super.key,
    this.onTap,
    this.manaRatio,
    this.attackRange,
    this.healthRatio,
    this.isDead = false,
  });

  final bool isDead;
  final bool isEnemy;
  final bool isSelected;
  final double? manaRatio;
  final double? attackRange;
  final double? healthRatio;
  final VoidCallback? onTap;
  final CharacterCopy? characterCopy;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final characterCopy = this.characterCopy;
    final factionColor = isEnemy ? colorScheme.errorContainer : colorScheme.primaryContainer;
    final backgroundColor = characterCopy == null ? colorScheme.surfaceContainerHighest : factionColor;

    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: isDead ? 0.3 : 1,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(width: 2, color: isSelected ? colorScheme.primary : Colors.transparent),
          ),
          child: characterCopy == null
              ? null
              : _CharacterCopyDetails(
                  manaRatio: manaRatio,
                  attackRange: attackRange,
                  healthRatio: healthRatio,
                  characterCopy: characterCopy,
                ),
        ),
      ),
    );
  }
}

class _CharacterCopyDetails extends StatelessWidget {
  const _CharacterCopyDetails({
    required this.manaRatio,
    required this.attackRange,
    required this.healthRatio,
    required this.characterCopy,
  });

  final double? manaRatio;
  final double? attackRange;
  final double? healthRatio;
  final CharacterCopy characterCopy;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final manaRatio = this.manaRatio;
    final attackRange = this.attackRange;
    final healthRatio = this.healthRatio;
    final characterName = characterNameOf(context.t, characterCopy.character);

    return Padding(
      padding: const EdgeInsets.all(2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(characterName, maxLines: 1, style: textTheme.labelSmall, overflow: TextOverflow.ellipsis),
          Text('★' * characterCopy.stars, style: textTheme.labelSmall),
          if (attackRange != null) Text(attackRangeLabelOf(context.t, attackRange), maxLines: 1, style: textTheme.labelSmall),
          if (healthRatio != null) LinearProgressIndicator(minHeight: 3, value: healthRatio, color: Colors.green),
          if (manaRatio != null) LinearProgressIndicator(minHeight: 2, value: manaRatio, color: Colors.blue),
        ],
      ),
    );
  }
}
