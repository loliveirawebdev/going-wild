import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:going_wild/domain/models/board/placement.dart';
import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/domain/models/roster/roster_slot.dart';
import 'package:going_wild/domain/use_cases/lineup/move_copy_between_roster_slots.dart';
import 'package:going_wild/domain/use_cases/lineup/sell_copy_from_roster_slot.dart';
import 'package:going_wild/domain/use_cases/round/start_fight.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/game/view_models/match_flow/events/fighting_started.dart';
import 'package:going_wild/ui/game/view_models/match_flow/match_flow_bloc.dart';
import 'package:going_wild/ui/game/view_models/preparation/events/copy_moved_between_roster_slots.dart';
import 'package:going_wild/ui/game/view_models/preparation/events/copy_sold_from_roster_slot.dart';
import 'package:going_wild/ui/game/view_models/preparation/preparation_bloc.dart';
import 'package:going_wild/ui/game/widgets/attack_range_label.dart';
import 'package:going_wild/ui/game/widgets/bench_section.dart';
import 'package:going_wild/ui/game/widgets/board_grid.dart';
import 'package:going_wild/ui/game/widgets/character_copy_cell.dart';
import 'package:going_wild/ui/game/widgets/rejection_tooltip.dart';
import 'package:going_wild/ui/game/widgets/shop_section.dart';

class PreparingView extends StatefulWidget {
  const PreparingView({required this.matchProgress, super.key});

  final MatchProgress matchProgress;

  @override
  State<PreparingView> createState() => _PreparingViewState();
}

class _PreparingViewState extends State<PreparingView> {
  RosterSlot? _selectedSlot;

  VoidCallback? _onTapOf(RosterSlot slot, {required bool isOccupied}) {
    final selectedSlot = _selectedSlot;
    final matchProgress = widget.matchProgress;

    if (selectedSlot == null) {
      final canSelect = isOccupied && matchProgress.checkPreparingActions() == null;
      return canSelect ? () => setState(() => _selectedSlot = slot) : null;
    }

    if (_isSameSlot(selectedSlot, slot)) return () => setState(() => _selectedSlot = null);
    if (checkMovingCopyBetweenRosterSlots(matchProgress, to: slot, from: selectedSlot) != null) return null;

    return () {
      context.read<PreparationBloc>().add(CopyMovedBetweenRosterSlots(from: selectedSlot, to: slot));
      setState(() => _selectedSlot = null);
    };
  }

  void _sellSelectedCopy(RosterSlot selectedSlot) {
    context.read<PreparationBloc>().add(CopySoldFromRosterSlot(from: selectedSlot));
    setState(() => _selectedSlot = null);
  }

  Placement? _placementAt(List<Placement> placements, Position position) {
    for (final placement in placements) {
      if (placement.position == position) return placement;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final translations = context.t.game;
    final matchProgress = widget.matchProgress;
    final selectedSlot = _selectedSlot;
    final fightRejection = checkStartingFight(matchProgress);
    final board = matchProgress.phase.engines.combatEngine.board;
    final sellRejection = selectedSlot == null ? null : checkSellingCopyFromRosterSlot(matchProgress, from: selectedSlot);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12,
      children: [
        ShopSection(matchProgress: matchProgress),
        Text(translations.board, style: Theme.of(context).textTheme.titleMedium),
        BoardGrid(
          board: board,
          cellBuilder: (context, position) {
            final teamPlacement = _placementAt(matchProgress.playerRoster.placements, position);
            final enemyPlacement = _placementAt(matchProgress.currentWave.enemies, position);
            final characterCopy = teamPlacement?.characterCopy ?? enemyPlacement?.characterCopy;
            final isTeamSide = board.isPositionOnTeamSide(position);

            return CharacterCopyCell(
              characterCopy: characterCopy,
              isEnemy: enemyPlacement != null,
              isSelected: selectedSlot is BoardSlot && selectedSlot.position == position,
              attackRange: characterCopy == null ? null : attackRangeOf(matchProgress, characterCopy.character),
              onTap: isTeamSide ? _onTapOf(BoardSlot(position: position), isOccupied: teamPlacement != null) : null,
            );
          },
        ),
        BenchSection(
          matchProgress: matchProgress,
          selectedInventoryIndex: selectedSlot is InventorySlot ? selectedSlot.index : null,
          onTapOfSlot: (inventoryIndex) => _onTapOf(
            InventorySlot(index: inventoryIndex),
            isOccupied: matchProgress.playerRoster.inventory.entryAt(inventoryIndex) != null,
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            RejectionTooltip(
              rejection: sellRejection,
              child: OutlinedButton(
                onPressed: selectedSlot == null || sellRejection != null ? null : () => _sellSelectedCopy(selectedSlot),
                child: Text(translations.sellButton),
              ),
            ),
            RejectionTooltip(
              rejection: fightRejection,
              child: FilledButton(
                onPressed: fightRejection == null ? () => context.read<MatchFlowBloc>().add(const FightingStarted()) : null,
                child: Text(translations.fightButton),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

bool _isSameSlot(RosterSlot firstSlot, RosterSlot secondSlot) => switch ((firstSlot, secondSlot)) {
  (final InventorySlot first, final InventorySlot second) => first.index == second.index,
  (final BoardSlot first, final BoardSlot second) => first.position == second.position,
  _ => false,
};
