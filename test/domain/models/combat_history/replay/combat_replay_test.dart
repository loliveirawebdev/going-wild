import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/content/engines/combat/basic_combat_engine.dart';
import 'package:going_wild/content/phase/backyard/backyard.dart';
import 'package:going_wild/domain/models/board/placement.dart';
import 'package:going_wild/domain/models/character/stats/stat.dart';
import 'package:going_wild/domain/models/combat/combat_result.dart';
import 'package:going_wild/domain/models/combat_history/causes/combat_history_cause.dart';
import 'package:going_wild/domain/models/combat_history/entries/combat_history_entry.dart';
import 'package:going_wild/domain/models/combat_history/replay/combat_replay.dart';

import '../../../../helpers/use_case_helpers.dart';

final team = [
  placed(bull, 4, 2, stars: 2),
  placed(cow, 4, 1, stars: 2),
  placed(sheep, 5, 3, stars: 2),
  placed(cat, 6, 0, stars: 2),
  placed(queenBee, 6, 3, stars: 2),
  placed(chicken, 6, 2, stars: 2),
];

List<Placement> enemiesOfWave(int waveNumber) => backyard.waves[waveNumber - 1].enemies;

CombatResult simulate({required int seed, required int waveNumber}) =>
    basicCombatEngine.simulate(team: team, recordsHistory: true, randomGenerator: Random(seed), enemies: enemiesOfWave(waveNumber));

void main() {
  const seeds = [1, 2, 3, 4, 5];
  const waveNumbers = [1, 5, 10];

  test('the first frame shows every combatant at its placement with full health', () {
    final result = simulate(seed: 1, waveNumber: 10);
    final replay = CombatReplay.fromHistory(result.history);
    final firstFrame = replay.frameAt(0);
    final placements = [...team, ...enemiesOfWave(10)];

    expect(firstFrame.combatants.length, placements.length);

    for (final (index, combatant) in firstFrame.combatants.indexed) {
      expect(combatant.position, placements[index].position, reason: '$combatant');
      expect(combatant.currentHealth, combatant.maxHealth, reason: '$combatant');
      expect(combatant.characterCopy, placements[index].characterCopy, reason: '$combatant');
    }
  });

  test('the last frame matches the combatants of the combat result', () {
    for (final seed in seeds) {
      for (final waveNumber in waveNumbers) {
        final result = simulate(seed: seed, waveNumber: waveNumber);
        final lastFrame = CombatReplay.fromHistory(result.history).finalFrame;
        final reason = 'seed $seed, wave $waveNumber';

        expect(lastFrame.combatants.length, result.combatants.length, reason: reason);

        for (final resultCombatant in result.combatants) {
          final frameCombatant = lastFrame.combatants.firstWhere((combatant) => combatant.id == resultCombatant.id);
          final combatantReason = '$reason, $resultCombatant';

          expect(frameCombatant.isAlive, resultCombatant.isAlive, reason: combatantReason);
          expect(frameCombatant.position, resultCombatant.position, reason: combatantReason);
          expect(frameCombatant.maxHealth, resultCombatant.stats[Stat.health], reason: combatantReason);
          expect(frameCombatant.currentMana, closeTo(resultCombatant.currentMana, 0.001), reason: combatantReason);
          expect(frameCombatant.currentHealth, closeTo(resultCombatant.currentHealth, 0.001), reason: combatantReason);
          expect(frameCombatant.currentShield, closeTo(resultCombatant.currentShield, 0.001), reason: combatantReason);
          expect(frameCombatant.combatLastingEffects, unorderedEquals(resultCombatant.combatLastingEffects), reason: combatantReason);
        }
      }
    }
  });

  test('the entries of every tick together are the whole history in order', () {
    final result = simulate(seed: 3, waveNumber: 5);
    final replay = CombatReplay.fromHistory(result.history);

    final entriesPerTick = [for (var tick = 0; tick <= replay.lastTick; tick++) ...replay.entriesAt(tick)];

    expect(replay.lastTick, result.history.entries.last.tick);
    expect(entriesPerTick.length, result.history.entries.length);

    for (final (index, entry) in entriesPerTick.indexed) {
      expect(entry, same(result.history.entries[index]));
      expect(entry.tick, lessThanOrEqualTo(replay.lastTick));
    }
  });

  test('every ability cast lists exactly the combatants its consequences reached', () {
    for (final seed in seeds) {
      final result = simulate(seed: seed, waveNumber: 10);
      final replay = CombatReplay.fromHistory(result.history);

      for (var tick = 0; tick <= replay.lastTick; tick++) {
        final entriesOfTick = replay.entriesAt(tick);

        for (final abilityCast in entriesOfTick.whereType<AbilityCastHistoryEntry>()) {
          final reachedCombatantIds = {
            for (final consequence in entriesOfTick.whereType<CombatConsequenceHistoryEntry>())
              if (consequence.cause case AbilityHistoryCause(:final casterCombatantId) when casterCombatantId == abilityCast.combatantId)
                if (!(consequence is ManaSpentHistoryEntry && consequence.combatantId == abilityCast.combatantId)) consequence.combatantId,
          };

          expect(abilityCast.affectedCombatantIds.toSet(), reachedCombatantIds, reason: 'seed $seed, tick $tick');
        }
      }
    }
  });

  test('ticks outside the combat show the closest frame and no entries', () {
    final result = simulate(seed: 2, waveNumber: 1);
    final replay = CombatReplay.fromHistory(result.history);

    expect(replay.frameAt(-5), same(replay.frameAt(0)));
    expect(replay.frameAt(replay.finalTick + 50), same(replay.finalFrame));
    expect(replay.entriesAt(-1), isEmpty);
    expect(replay.entriesAt(replay.lastTick + 1), isEmpty);
  });
}
