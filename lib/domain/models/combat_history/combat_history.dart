import 'package:going_wild/domain/models/combat_history/causes/combat_history_cause.dart';
import 'package:going_wild/domain/models/combat_history/combat_history_step.dart';
import 'package:going_wild/domain/models/combat_history/comparison/combat_step_comparison.dart';
import 'package:going_wild/domain/models/combat_history/entries/combat_history_entry.dart';
import 'package:going_wild/domain/models/combatant/combatant.dart';
import 'package:going_wild/domain/models/combatant/faction.dart';
import 'package:meta/meta.dart';

class CombatHistory {
  CombatHistory({required List<CombatHistoryEntry> entries}) : this._(previousHistory: null, latestEntries: List.unmodifiable(entries));
  CombatHistory._({required this._latestEntries, required this._previousHistory});

  final CombatHistory? _previousHistory;
  final List<CombatHistoryEntry> _latestEntries;
  late final List<CombatHistoryEntry> entries = _collectEntries();

  @useResult
  CombatHistory createCopyWithCombatStarted({required int tick, required List<Combatant> combatants}) => _createCopyWithEntries([
    CombatStartedHistoryEntry(tick: tick, combatants: List.unmodifiable(combatants)),
    for (final combatant in combatants)
      for (final combatLastingEffect in combatant.combatLastingEffects)
        LastingEffectStartedHistoryEntry(
          tick: tick,
          combatantId: combatant.id,
          cause: const CombatStartHistoryCause(),
          combatLastingEffect: combatLastingEffect,
        ),
  ]);

  @useResult
  CombatHistory createCopyWithCombatEnded({required int tick, required Faction? winningFaction}) {
    return _createCopyWithEntries([
      CombatEndedHistoryEntry(
        tick: tick,
        winningFaction: winningFaction,
      ),
    ]);
  }

  @useResult
  CombatHistory createCopyWithStepCompared({
    required int tick,
    required CombatHistoryStep step,
    required List<Combatant> combatantsAfter,
    required List<Combatant> combatantsBefore,
  }) {
    final stepComparison = CombatStepComparison(
      tick: tick,
      step: step,
      combatantsAfter: combatantsAfter,
      combatantsBefore: combatantsBefore,
    );

    return _createCopyWithEntries(stepComparison.entries);
  }

  CombatHistory _createCopyWithEntries(List<CombatHistoryEntry> newEntries) {
    if (newEntries.isEmpty) return this;
    return CombatHistory._(previousHistory: this, latestEntries: List.unmodifiable(newEntries));
  }

  List<CombatHistoryEntry> _collectEntries() {
    final historiesFromNewest = <CombatHistory>[];

    for (CombatHistory? history = this; history != null; history = history._previousHistory) {
      historiesFromNewest.add(history);
    }

    return List.unmodifiable([for (final history in historiesFromNewest.reversed) ...history._latestEntries]);
  }
}
