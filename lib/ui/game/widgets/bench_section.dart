import 'package:flutter/material.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/game/widgets/attack_range_label.dart';
import 'package:going_wild/ui/game/widgets/character_copy_cell.dart';

class BenchSection extends StatelessWidget {
  const BenchSection({required this.matchProgress, this.onTapOfSlot, this.selectedInventoryIndex, super.key});

  final MatchProgress matchProgress;
  final int? selectedInventoryIndex;
  final VoidCallback? Function(int inventoryIndex)? onTapOfSlot;

  @override
  Widget build(BuildContext context) {
    final inventory = matchProgress.playerRoster.inventory;
    final onTapOfSlot = this.onTapOfSlot;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        Text(context.t.game.inventory, style: Theme.of(context).textTheme.titleMedium),
        SizedBox(
          height: 64,
          child: Row(
            children: [
              for (var inventoryIndex = 0; inventoryIndex < inventory.capacity; inventoryIndex++)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(1),
                    child: CharacterCopyCell(
                      isEnemy: false,
                      characterCopy: inventory.entryAt(inventoryIndex),
                      isSelected: selectedInventoryIndex == inventoryIndex,
                      attackRange: _attackRangeAt(inventoryIndex),
                      onTap: onTapOfSlot?.call(inventoryIndex),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  double? _attackRangeAt(int inventoryIndex) {
    final characterCopy = matchProgress.playerRoster.inventory.entryAt(inventoryIndex);
    return characterCopy == null ? null : attackRangeOf(matchProgress, characterCopy.character);
  }
}
