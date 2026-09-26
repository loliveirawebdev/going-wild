import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/domain/models/combat/combatant_actions/cast_ability_if_ready.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/stun/stun_combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/faction.dart';

import '../../helpers/combat_helpers.dart';

void main() {
  test('the bull charge stuns every enemy it hits, even the ones it pushes out of the area', () {
    final focus = combatant(at: at(3, 2), faction: Faction.enemy, stats: statsOf(health: 100000));
    final enemies = [
      focus,
      combatant(at: at(3, 1), faction: Faction.enemy, stats: statsOf(health: 100000)),
      combatant(at: at(3, 3), faction: Faction.enemy, stats: statsOf(health: 100000)),
      combatant(at: at(2, 2), faction: Faction.enemy, stats: statsOf(health: 100000)),
    ];
    final chargingBull = combatant(
      at: at(4, 2),
      character: bull,
      faction: Faction.team,
      stats: statsOf(manaStart: 50),
    ).createCopyWith(targetCombatantId: focus.id);

    final chargedCombat = castAbilityIfReady(combatWith([chargingBull, ...enemies]), chargingBull.id);

    for (final enemy in enemies) {
      final chargedEnemy = findCombatant(chargedCombat, enemy);
      final isStunned = chargedEnemy.combatLastingEffects.whereType<StunCombatLastingEffect>().isNotEmpty;

      expect(chargedEnemy.currentHealth, lessThan(100000), reason: '${enemy.position}');
      expect(isStunned, isTrue, reason: '${enemy.position}');
    }
  });
}
