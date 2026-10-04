import 'package:going_wild/domain/models/character/stats/stat.dart';
import 'package:going_wild/domain/models/combatant/combatant.dart';
import 'package:meta/meta.dart';

@useResult
Combatant heal(Combatant targetCombatant, {required double healAmount}) {
  if (!targetCombatant.isAlive || healAmount <= 0) return targetCombatant;
  return targetCombatant.createCopyWith(
    currentHealth: (targetCombatant.currentHealth + healAmount).clamp(0, targetCombatant.stats[Stat.health]),
  );
}
