import 'package:meta/meta.dart';

import '../../character/abilities/ability_trigger.dart';
import '../../character/stats/stat.dart';
import '../../combatant/combat_effects/base/combat_effect.dart';
import '../../combatant/combatant.dart';
import '../combat.dart';
import 'apply_combat_effects.dart';

@useResult
Combat castAbilityIfReady(Combat combat, int casterCombatantId) {
  final casterCombatant = combat.battlefield.combatantWithId(casterCombatantId);
  final ability = casterCombatant.characterCopy.character.ability;

  final casterWithTriggerConsumed = _consumeTriggerIfReady(combat, casterCombatant, ability.trigger);
  if (casterWithTriggerConsumed == null) return combat;

  final castingCombat = combat.createCopyWithCombatant(casterWithTriggerConsumed);

  return applyCombatEffects(
    castingCombat,
    effects: ability.effects.whereType<CombatEffect>().toList(),
    sourceCombatantId: casterCombatantId,
  );
}

Combatant? _consumeTriggerIfReady(Combat combat, Combatant casterCombatant, AbilityTrigger trigger) {
  switch (trigger) {
    case AbilityTrigger.manaFull:
      final manaMax = casterCombatant.getCurrentStat(Stat.manaMax);
      if (casterCombatant.currentMana < manaMax) return null;

      return casterCombatant.createCopyWith(currentMana: 0);

    case AbilityTrigger.lowHealth:
      if (casterCombatant.lowHealthAbilityUsed) return null;

      final healthPercentage = casterCombatant.currentHealth / casterCombatant.stats[Stat.health] * 100;
      if (healthPercentage > combat.rules.lowHealthTriggerPercentage) return null;

      return casterCombatant.createCopyWith(lowHealthAbilityUsed: true);
  }
}
