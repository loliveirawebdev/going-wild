import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/content/phase/backyard/backyard.dart';
import 'package:going_wild/domain/models/board/placement.dart';
import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/domain/models/character/stats/stat.dart';
import 'package:going_wild/domain/models/combat_history/entries/combat_history_entry.dart';
import 'package:going_wild/domain/use_cases/round/start_fight.dart';
import 'package:going_wild/domain/use_cases/round/start_match.dart';
import 'package:going_wild/domain/use_cases/round/starting_combatants_of.dart';

const bullPosition = Position(row: 5, column: 1);
const horsePosition = Position(row: 5, column: 2);

void main() {
  test('the starting combatants are exactly the ones the fight starts with, set bonuses included', () {
    final startedMatch = startMatch(backyard, randomGenerator: Random(1));
    final matchProgress = startedMatch.createCopyWith(
      playerRoster: startedMatch.playerRoster.createCopyWith(
        placements: const [
          Placement(
            position: bullPosition,
            characterCopy: CharacterCopy(stars: 1, character: bull),
          ),
          Placement(
            position: horsePosition,
            characterCopy: CharacterCopy(stars: 1, character: horse),
          ),
        ],
      ),
    );

    final previewByPosition = {for (final combatant in startingCombatantsOf(matchProgress)) combatant.position: combatant};
    final fightHistory = startFight(matchProgress, recordsHistory: true).combatResult.history;
    final foughtCombatants = fightHistory.entries.whereType<CombatStartedHistoryEntry>().single.combatants;

    expect(previewByPosition, hasLength(foughtCombatants.length));
    for (final foughtCombatant in foughtCombatants) {
      final preview = previewByPosition[foughtCombatant.position]!;
      for (final stat in Stat.values) {
        expect(preview.stats[stat], foughtCombatant.stats[stat], reason: '${foughtCombatant.position} ${stat.name}');
      }
      expect(preview.currentMana, foughtCombatant.currentMana);
      expect(preview.currentShield, foughtCombatant.currentShield);
    }

    final bullBaseHealth = backyard.engines.characterEngine.statsAtStars(bull, stars: 1)[Stat.health];
    expect(previewByPosition[bullPosition]!.stats[Stat.health], closeTo(bullBaseHealth * 1.15, 0.001));
  });
}
