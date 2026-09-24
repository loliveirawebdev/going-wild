import '../../models.dart';
import '../battle.dart';
import '../../events/combat/battle_event.dart';
import '../unit/unit.dart';
import 'apply_ability_effects.dart';

void castAbilityIfReady(Battle battle, Unit casterUnit) {
  final ability = casterUnit.character.ability;
  if (!_consumeTriggerIfReady(battle, casterUnit, ability.trigger)) return;

  battle.recordEvent(CharacterAbilityCast(time: battle.elapsedSeconds, unitId: casterUnit.id, abilityId: ability.id));
  applyAbilityEffects(battle, casterUnit: casterUnit, effects: ability.effects);
}

bool _consumeTriggerIfReady(Battle battle, Unit casterUnit, AbilityTrigger trigger) {
  switch (trigger) {
    case AbilityTrigger.manaFull:
      if (casterUnit.currentMana < casterUnit.getCurrentStat(Stat.manaMax)) return false;
      casterUnit.currentMana = 0;
      return true;

    case AbilityTrigger.lowHealth:
      if (casterUnit.lowHealthAbilityUsed) return false;

      final healthPercentage = casterUnit.currentHealth / casterUnit.stats.health * 100;
      if (healthPercentage > battle.rules.lowHealthTriggerPercentage) return false;

      casterUnit.lowHealthAbilityUsed = true;
      return true;
  }
}
