import 'package:going_wild/domain/models/character/stats/stat.dart';
import 'package:going_wild/domain/models/combatant/ability_triggers/combat_ability_trigger.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/combat_effect_context.dart';
import 'package:going_wild/domain/models/combatant/combatant.dart';

class ManaFullTrigger extends CombatAbilityTrigger {
  const ManaFullTrigger();

  @override
  Combatant? casterAfterConsumingIfReady({required Combatant caster, required CombatEffectContext context}) {
    final manaMax = caster.getCurrentStat(Stat.manaMax);
    if (caster.currentMana < manaMax) return null;

    return caster.createCopyWith(currentMana: 0);
  }
}
