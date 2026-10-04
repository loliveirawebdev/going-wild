import 'package:going_wild/domain/models/character/stats/stat.dart';
import 'package:going_wild/domain/models/combatant/ability_triggers/combat_ability_trigger.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/combat_effect_context.dart';
import 'package:going_wild/domain/models/combatant/combatant.dart';

class LowHealthTrigger extends CombatAbilityTrigger {
  const LowHealthTrigger({required this.healthPercentage});

  final double healthPercentage;

  @override
  Combatant? casterAfterConsumingIfReady({required Combatant caster, required CombatEffectContext context}) {
    if (caster.abilityCastCount > 0) return null;

    final currentHealthPercentage = caster.currentHealth / caster.stats[Stat.health] * 100;
    if (currentHealthPercentage > healthPercentage) return null;

    return caster;
  }
}
