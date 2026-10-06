import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/content/phase/backyard/backyard.dart';
import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/domain/models/character/stats/stat.dart';
import 'package:going_wild/domain/models/character/stats/stat_change_type.dart';
import 'package:going_wild/domain/models/character/stats/stat_modification.dart';
import 'package:going_wild/domain/models/combat_history/replay/combat_replay_combatant.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/stat_modifier/stat_modifier_combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/faction.dart';

void main() {
  test('the current stats apply the lasting effects on top of the stats the combatant started with', () {
    final stats = backyard.engines.characterEngine.statsAtStars(dog, stars: 1);
    final combatant = CombatReplayCombatant(
      id: 1,
      stats: stats,
      currentMana: 0,
      faction: Faction.team,
      targetCombatantId: null,
      currentHealth: stats[Stat.health],
      position: const Position(row: 5, column: 1),
      characterCopy: const CharacterCopy(stars: 1, character: dog),
      combatLastingEffects: const [
        StatModifierCombatLastingEffect(
          remainingTicks: 4,
          sourceCombatantId: 2,
          statModification: StatModification(stat: Stat.damage, value: 1.5, changeType: StatChangeType.multiplier),
        ),
      ],
    );

    expect(combatant.currentStats[Stat.damage], closeTo(stats[Stat.damage] * 1.5, 0.001));
    expect(combatant.currentStats[Stat.armor], stats[Stat.armor]);
    expect(combatant.maxHealth, stats[Stat.health]);
  });
}
