import 'package:going_wild/domain/models/character/abilities/ability_trigger.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/combat_effect_context.dart';
import 'package:going_wild/domain/models/combatant/combatant.dart';
import 'package:meta/meta.dart';

abstract class CombatAbilityTrigger implements AbilityTrigger {
  const CombatAbilityTrigger();

  @useResult
  Combatant? casterAfterConsumingIfReady({required Combatant caster, required CombatEffectContext context});
}
