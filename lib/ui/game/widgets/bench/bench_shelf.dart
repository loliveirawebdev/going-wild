import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/domain/models/inventory/inventory.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/domain/models/roster/roster_slot.dart';
import 'package:going_wild/domain/use_cases/lineup/move_copy_between_roster_slots.dart';
import 'package:going_wild/ui/game/view_models/preparation/events/copy_moved_between_roster_slots.dart';
import 'package:going_wild/ui/game/view_models/preparation/preparation_bloc.dart';
import 'package:going_wild/ui/game/view_models/preparation/states/preparation_state.dart';
import 'package:going_wild/ui/game/widgets/bench/animated_bench.dart';
import 'package:going_wild/ui/game/widgets/bench/bench_handle.dart';
import 'package:going_wild/ui/game/widgets/match_shelves/match_shelf.dart';
import 'package:going_wild/ui/game/widgets/unit_sheet/roster_unit_sheet.dart';

class BenchShelf extends StatelessWidget {
  const BenchShelf({required this.isExpanded, required this.onExpandedChanged, super.key});

  final bool isExpanded;
  final ValueChanged<bool> onExpandedChanged;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PreparationBloc, PreparationState>(
      builder: (context, state) {
        if (state is! ReadyPreparationState) return const SizedBox.shrink();
        final matchProgress = state.matchProgress;
        final benchCopies = _benchCopiesOf(matchProgress.playerRoster.inventory);

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: BenchHandle(
                isExpanded: isExpanded,
                onExpandedChanged: onExpandedChanged,
              ),
            ),

            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: isExpanded ? null : () => onExpandedChanged(true),
              child: MatchShelf(
                child: AnimatedBench(
                  isExpanded: isExpanded,
                  benchCopies: benchCopies,
                  canDragCopies: matchProgress.checkPreparingActions() == null,
                  onCopyMoved: (fromIndex, toIndex) => _moveCopy(context, matchProgress, fromIndex, toIndex),
                  onBoardCopyDropped: (fromPosition, toIndex) => _moveBoardCopyToBench(context, matchProgress, fromPosition, toIndex),

                  onSlotPressed: (slotIndex, characterCopy) => presentRosterUnitSheet(
                    context,
                    matchProgress: matchProgress,
                    characterCopy: characterCopy,
                    rosterSlot: InventorySlot(index: slotIndex),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _moveBoardCopyToBench(BuildContext context, MatchProgress matchProgress, Position fromPosition, int toIndex) {
    final from = BoardSlot(position: fromPosition);
    final to = InventorySlot(index: toIndex);
    if (checkMovingCopyBetweenRosterSlots(matchProgress, to: to, from: from) != null) return;

    context.read<PreparationBloc>().add(CopyMovedBetweenRosterSlots(to: to, from: from));
  }

  bool _moveCopy(BuildContext context, MatchProgress matchProgress, int fromIndex, int toIndex) {
    final from = InventorySlot(index: fromIndex);
    final to = InventorySlot(index: toIndex);
    if (checkMovingCopyBetweenRosterSlots(matchProgress, to: to, from: from) != null) return false;

    context.read<PreparationBloc>().add(CopyMovedBetweenRosterSlots(to: to, from: from));
    return true;
  }

  List<CharacterCopy?> _benchCopiesOf(Inventory<CharacterCopy> inventory) => [
    for (var slotIndex = 0; slotIndex < inventory.capacity; slotIndex++) inventory.entryAt(slotIndex),
  ];
}
