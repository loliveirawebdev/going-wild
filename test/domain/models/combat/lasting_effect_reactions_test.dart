import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/domain/models/combat/combatant_actions/deal_damage.dart';
import 'package:going_wild/domain/models/combatant/capabilities/heal.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/combat_effect_context.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/lasting/combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/faction.dart';

import '../../../helpers/combat_helpers.dart';

class ThornsCombatLastingEffect extends CombatLastingEffect {
  const ThornsCombatLastingEffect({required super.sourceCombatantId});

  @override
  CombatEffectContext reactToOwnerDamaged(
    CombatEffectContext context, {
    required double healthLost,
    required int ownerCombatantId,
    required int? sourceCombatantId,
  }) {
    if (sourceCombatantId == null) return context;

    return context.createCopyWithDamageDealt(damageAmount: healthLost, sourceCombatantId: null, targetCombatantId: sourceCombatantId);
  }
}

class LastWordsCombatLastingEffect extends CombatLastingEffect {
  const LastWordsCombatLastingEffect({required super.sourceCombatantId});

  @override
  CombatEffectContext reactToOwnerDeath(CombatEffectContext context, {required int ownerCombatantId, required int? killerCombatantId}) {
    if (killerCombatantId == null) return context;

    return context.createCopyWithDamageDealt(damageAmount: 50, sourceCombatantId: null, targetCombatantId: killerCombatantId);
  }
}

class HungerCombatLastingEffect extends CombatLastingEffect {
  const HungerCombatLastingEffect({required super.sourceCombatantId});

  @override
  CombatEffectContext reactToOwnerKill(CombatEffectContext context, {required int ownerCombatantId, required int killedCombatantId}) {
    final owner = context.combatantWithId(ownerCombatantId);
    return context.createCopyWithCombatant(heal(owner, healAmount: 100));
  }
}

void main() {
  test('a combatant reacts to the damage it survives, knowing who hit it', () {
    final attacker = combatant(at: at(7, 2), faction: Faction.team, stats: statsOf(armor: 0));
    final target = withCombatLastingEffects(combatant(at: at(6, 2), faction: Faction.enemy, stats: statsOf(armor: 0)), [
      const ThornsCombatLastingEffect(sourceCombatantId: 99),
    ]);
    final combat = combatWith([attacker, target]);

    final hitCombat = dealDamageToCombatant(combat, damageAmount: 100, targetCombatantId: target.id, sourceCombatantId: attacker.id);
    final anonymousHitCombat = dealDamageToCombatant(combat, damageAmount: 100, targetCombatantId: target.id, sourceCombatantId: null);

    expect(findCombatant(hitCombat, target).currentHealth, 900);
    expect(findCombatant(hitCombat, attacker).currentHealth, 900);
    expect(findCombatant(anonymousHitCombat, attacker).currentHealth, 1000);
  });

  test('a dying combatant reacts to its death and the killer reacts to the kill', () {
    final killer = withCombatLastingEffects(combatant(at: at(7, 2), faction: Faction.team, stats: statsOf(armor: 0)), [
      const HungerCombatLastingEffect(sourceCombatantId: 99),
    ]).createCopyWith(currentHealth: 500);
    final victim = withCombatLastingEffects(combatant(at: at(6, 2), faction: Faction.enemy, stats: statsOf(armor: 0)), [
      const LastWordsCombatLastingEffect(sourceCombatantId: 99),
      const ThornsCombatLastingEffect(sourceCombatantId: 99),
    ]).createCopyWith(currentHealth: 10);

    final killCombat = dealDamageToCombatant(
      combatWith([killer, victim]),
      damageAmount: 100,
      sourceCombatantId: killer.id,
      targetCombatantId: victim.id,
    );

    expect(findCombatant(killCombat, victim).isAlive, isFalse);
    expect(findCombatant(killCombat, killer).currentHealth, 500 - 50 + 100);
  });
}
