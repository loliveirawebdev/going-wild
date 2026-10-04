import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/domain/models/character/stats/stat.dart';
import 'package:going_wild/domain/models/combat/combatant_actions/apply_combat_effects.dart';
import 'package:going_wild/domain/models/combatant/capabilities/heal.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/applying/combat_effect_application.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/combat_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/combat_effect_context.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/damage/damage_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/targets/focus_target.dart';
import 'package:going_wild/domain/models/combatant/faction.dart';

import '../../../../../../helpers/combat_helpers.dart';

class HealSourceByMissingHealthEffect extends CombatEffect {
  const HealSourceByMissingHealthEffect();

  @override
  CombatEffectContext apply(CombatEffectApplication application) {
    final sourceCombatant = application.sourceCombatant;
    final missingHealth = sourceCombatant.stats[Stat.health] - sourceCombatant.currentHealth;

    return application.context.createCopyWithCombatant(heal(sourceCombatant, healAmount: missingHealth));
  }
}

void main() {
  test('an effect nobody registered is applied just by being used', () {
    final caster = combatant(at: at(6, 2), faction: Faction.team).createCopyWith(currentHealth: 400);
    final combat = combatWith([caster]);

    final appliedCombat = applyCombatEffects(combat, sourceCombatantId: caster.id, effects: const [HealSourceByMissingHealthEffect()]);

    expect(findCombatant(appliedCombat, caster).currentHealth, 1000);
  });

  test('effects apply in order, each one seeing what the previous ones did', () {
    final enemy = combatant(at: at(1, 2), faction: Faction.enemy);
    final caster = combatant(at: at(6, 2), faction: Faction.team).createCopyWith(targetCombatantId: enemy.id);
    final combat = combatWith([caster, enemy]);

    final appliedCombat = applyCombatEffects(
      combat,
      sourceCombatantId: caster.id,
      effects: [
        DamageEffect(value: atEveryStar(100), target: const FocusTarget()),
        DamageEffect(value: atEveryStar(100), target: const FocusTarget()),
      ],
    );

    expect(findCombatant(appliedCombat, enemy).currentHealth, 800);
  });
}
