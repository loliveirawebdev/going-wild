import 'package:going_wild/domain/models/combatant/combatant.dart';
import 'package:meta/meta.dart';

@useResult
Combatant loseHealth(Combatant combatant, {required double healthAmount}) {
  final remainingHealth = combatant.currentHealth - healthAmount;
  if (remainingHealth > 0) return combatant.createCopyWith(currentHealth: remainingHealth);
  return combatant.createCopyWith(currentHealth: 0, combatLastingEffects: const []);
}
