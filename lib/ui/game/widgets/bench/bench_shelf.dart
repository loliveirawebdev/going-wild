import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/domain/models/inventory/inventory.dart';
import 'package:going_wild/ui/game/view_models/preparation/preparation_bloc.dart';
import 'package:going_wild/ui/game/view_models/preparation/states/preparation_state.dart';
import 'package:going_wild/ui/game/widgets/bench/animated_bench.dart';
import 'package:going_wild/ui/game/widgets/bench/bench_handle.dart';
import 'package:going_wild/ui/game/widgets/match_shelves/match_shelf.dart';

class BenchShelf extends StatelessWidget {
  final bool isExpanded;
  final ValueChanged<bool> onExpandedChanged;
  final List<CharacterCopy?>? previewBenchCopies;
  const BenchShelf({required this.isExpanded, required this.onExpandedChanged, super.key, this.previewBenchCopies});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PreparationBloc, PreparationState>(
      builder: (context, state) {
        if (state is! ReadyPreparationState) return const SizedBox.shrink();
        final benchCopies = _benchCopiesOf(state.matchProgress.playerRoster.inventory);

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
                child: AnimatedBench(isExpanded: isExpanded, benchCopies: benchCopies),
              ),
            ),
          ],
        );
      },
    );
  }

  List<CharacterCopy?> _benchCopiesOf(Inventory<CharacterCopy> inventory) {
    final previewBenchCopies = this.previewBenchCopies;
    final benchCopies = [for (var slotIndex = 0; slotIndex < inventory.capacity; slotIndex++) inventory.entryAt(slotIndex)];
    final isBenchEmpty = benchCopies.every((characterCopy) => characterCopy == null);

    if (!isBenchEmpty || previewBenchCopies == null) return benchCopies;
    return [for (var slotIndex = 0; slotIndex < inventory.capacity; slotIndex++) previewBenchCopies.elementAtOrNull(slotIndex)];
  }
}
