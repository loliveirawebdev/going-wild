import 'package:going_wild/domain/models/combat_history/combat_history_entry_detectors.dart';
import 'package:going_wild/domain/models/combat_history/combat_history_step.dart';
import 'package:going_wild/domain/models/combat_history/comparison/combatant_step_comparison.dart';
import 'package:going_wild/domain/models/combat_history/entries/combat_history_entry.dart';
import 'package:going_wild/domain/models/combatant/combatant.dart';

class CombatStepComparison {
  CombatStepComparison({
    required this.tick,
    required this.step,
    required List<Combatant> combatantsAfter,
    required List<Combatant> combatantsBefore,
  }) : combatantComparisons = _comparisonsOfChangedCombatants(
         tick: tick,
         step: step,
         combatantsAfter: combatantsAfter,
         combatantsBefore: combatantsBefore,
       );

  final int tick;
  final CombatHistoryStep step;
  final List<CombatantStepComparison> combatantComparisons;

  late final CombatantStepComparison? actorComparison = combatantComparisons.where((comparison) => comparison.isActor).firstOrNull;

  late final List<int> affectedCombatantIds = [
    for (final comparison in combatantComparisons)
      if (comparison.isAffectedByTheStep) comparison.after.id,
  ];

  late final List<CombatHistoryEntry> entries = [
    for (final detect in actorEntryDetectors) ...detect(this),
    for (final comparison in combatantComparisons) ...comparison.entries,
  ];
}

List<CombatantStepComparison> _comparisonsOfChangedCombatants({
  required int tick,
  required CombatHistoryStep step,
  required List<Combatant> combatantsAfter,
  required List<Combatant> combatantsBefore,
}) {
  final combatantsBeforeById = _hasSameOrder(combatantsBefore, combatantsAfter) ? null : _combatantsById(combatantsBefore);
  final combatantComparisons = <CombatantStepComparison>[];

  for (var index = 0; index < combatantsAfter.length; index++) {
    final combatantAfter = combatantsAfter[index];
    final combatantBefore = combatantsBeforeById == null ? combatantsBefore[index] : combatantsBeforeById[combatantAfter.id];
    if (combatantBefore == null || identical(combatantBefore, combatantAfter)) continue;

    combatantComparisons.add(CombatantStepComparison(tick: tick, step: step, after: combatantAfter, before: combatantBefore));
  }

  return combatantComparisons;
}

bool _hasSameOrder(List<Combatant> combatantsBefore, List<Combatant> combatantsAfter) {
  if (combatantsBefore.length != combatantsAfter.length) return false;

  for (var index = 0; index < combatantsAfter.length; index++) {
    if (combatantsBefore[index].id != combatantsAfter[index].id) {
      return false;
    }
  }

  return true;
}

Map<int, Combatant> _combatantsById(List<Combatant> combatants) => {for (final combatant in combatants) combatant.id: combatant};
