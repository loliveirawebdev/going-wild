import 'package:going_wild/domain/models/combat/combat.dart';
import 'package:going_wild/domain/models/combat/combat_context.dart';
import 'package:going_wild/domain/models/combat/combatant_actions/apply_combat_effects.dart';
import 'package:going_wild/domain/models/combatant/ability_triggers/combat_ability_trigger.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/combat_effect.dart';
import 'package:meta/meta.dart';

@useResult
Combat castAbilityIfReady(Combat combat, int casterCombatantId) {
  final casterCombatant = combat.battlefield.combatantWithId(casterCombatantId);
  final ability = casterCombatant.characterCopy.character.ability;
  final trigger = ability.trigger;
  if (trigger is! CombatAbilityTrigger) return combat;

  final casterAfterConsuming = trigger.casterAfterConsumingIfReady(
    caster: casterCombatant,
    context: CombatContext(combat: combat),
  );
  if (casterAfterConsuming == null) return combat;

  final castingCaster = casterAfterConsuming.createCopyWith(abilityCastCount: casterAfterConsuming.abilityCastCount + 1);
  final castingCombat = combat.createCopyWithCombatant(castingCaster);

  return applyCombatEffects(
    castingCombat,
    effects: ability.effects.whereType<CombatEffect>().toList(),
    sourceCombatantId: casterCombatantId,
  );
}
