import 'package:going_wild/domain/models/character/stats/stat.dart';
import 'package:going_wild/domain/models/combatant/capabilities/lose_health.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/lasting/combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combatant.dart';
import 'package:meta/meta.dart';

@useResult
({Combatant damagedCombatant, List<CombatLastingEffect> brokenCombatLastingEffects}) takeDamage(
  Combatant combatant, {
  required double damageAmount,
}) {
  if (!combatant.isAlive) return (damagedCombatant: combatant, brokenCombatLastingEffects: const []);
  final damageAfterArmor = reduceDamageByArmor(damageAmount, combatant.getCurrentStat(Stat.armor));
  var remainingDamage = damageAfterArmor * combatant.getCurrentStat(Stat.damageTakenPercentage);

  final combatLastingEffectsAfterDamage = <CombatLastingEffect>[];
  final brokenCombatLastingEffects = <CombatLastingEffect>[];

  for (final combatLastingEffect in combatant.combatLastingEffects) {
    if (remainingDamage <= 0) {
      combatLastingEffectsAfterDamage.add(combatLastingEffect);
      continue;
    }

    final damageAbsorption = combatLastingEffect.absorbDamage(remainingDamage);
    remainingDamage -= damageAbsorption.absorbedDamage;

    final remainingCombatLastingEffect = damageAbsorption.remainingCombatLastingEffect;

    if (remainingCombatLastingEffect == null)
      brokenCombatLastingEffects.add(combatLastingEffect);
    else
      combatLastingEffectsAfterDamage.add(remainingCombatLastingEffect);
  }

  return (
    brokenCombatLastingEffects: brokenCombatLastingEffects,
    damagedCombatant: loseHealth(
      combatant.createCopyWith(combatLastingEffects: combatLastingEffectsAfterDamage),
      healthAmount: remainingDamage,
    ),
  );
}

// Armor reduces damage by the fraction armor / (100 + armor):
// 50 armor removes a third, 100 armor removes half, 300 armor removes three quarters.
// The result is never zero, so no combatant becomes immune.
double reduceDamageByArmor(double damage, double armor) => damage * 100 / (100 + armor);
