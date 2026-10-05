import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/domain/models/inventory/inventory.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/domain/models/roster/roster_slot.dart';
import 'package:going_wild/domain/use_cases/lineup/move_copy_between_roster_slots.dart';
import 'package:going_wild/domain/use_cases/lineup/sell_copy_from_roster_slot.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/localization/rejection_message.dart';
import 'package:going_wild/ui/game/view_models/preparation/events/copy_moved_between_roster_slots.dart';
import 'package:going_wild/ui/game/view_models/preparation/events/copy_sold_from_roster_slot.dart';
import 'package:going_wild/ui/game/view_models/preparation/preparation_bloc.dart';
import 'package:going_wild/ui/game/view_models/preparation/states/preparation_state.dart';
import 'package:going_wild/ui/game/widgets/bench/animated_bench.dart';
import 'package:going_wild/ui/game/widgets/bench/bench_handle.dart';
import 'package:going_wild/ui/game/widgets/match_shelves/match_shelf.dart';
import 'package:going_wild/ui/game/widgets/unit_sheet/unit_sale.dart';
import 'package:going_wild/ui/game/widgets/unit_sheet/unit_sheet.dart';
import 'package:going_wild/ui/game/widgets/unit_sheet/unit_side.dart';

class BenchShelf extends StatelessWidget {
  final bool isExpanded;
  final ValueChanged<bool> onExpandedChanged;
  const BenchShelf({required this.isExpanded, required this.onExpandedChanged, super.key});

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
              child: BenchHandle(isExpanded: isExpanded, onExpandedChanged: onExpandedChanged),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: isExpanded ? null : () => onExpandedChanged(true),
              child: MatchShelf(
                child: AnimatedBench(
                  isExpanded: isExpanded,
                  benchCopies: benchCopies,
                  onCopyMoved: (fromIndex, toIndex) => _moveCopy(context, matchProgress, fromIndex, toIndex),
                  onSlotPressed: (slotIndex, characterCopy) => _openUnitSheet(context, matchProgress, slotIndex, characterCopy),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  bool _moveCopy(BuildContext context, MatchProgress matchProgress, int fromIndex, int toIndex) {
    final from = InventorySlot(index: fromIndex);
    final to = InventorySlot(index: toIndex);
    if (checkMovingCopyBetweenRosterSlots(matchProgress, to: to, from: from) != null) return false;

    context.read<PreparationBloc>().add(CopyMovedBetweenRosterSlots(to: to, from: from));
    return true;
  }

  void _openUnitSheet(BuildContext context, MatchProgress matchProgress, int slotIndex, CharacterCopy characterCopy) {
    final inventorySlot = InventorySlot(index: slotIndex);
    final preparationBloc = context.read<PreparationBloc>();
    final engines = matchProgress.phase.engines;
    final rejection = checkSellingCopyFromRosterSlot(matchProgress, from: inventorySlot);

    presentUnitSheet(
      context,
      engines: engines,
      side: UnitSide.team,
      characterCopy: characterCopy,
      sale: UnitSale(
        valueInCoins: engines.economyEngine.sellPriceOf(characterCopy, matchProgress: matchProgress),
        disabledReason: rejection == null ? null : rejectionMessageOf(context.t, rejection),
        onSell: rejection == null ? () => preparationBloc.add(CopySoldFromRosterSlot(from: inventorySlot)) : null,
      ),
    );
  }

  List<CharacterCopy?> _benchCopiesOf(Inventory<CharacterCopy> inventory) => [
    for (var slotIndex = 0; slotIndex < inventory.capacity; slotIndex++) inventory.entryAt(slotIndex),
  ];
}
