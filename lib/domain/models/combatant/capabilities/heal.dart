import 'package:meta/meta.dart';

import '../../character/stats/stat.dart';
import '../combatant.dart';

@useResult
Combatant heal(Combatant targetCombatant, {required double healAmount}) {
  if (!targetCombatant.isAlive || healAmount <= 0) return targetCombatant;
  return targetCombatant.createCopyWith(
    currentHealth: (targetCombatant.currentHealth + healAmount).clamp(0, targetCombatant.stats[Stat.health]),
  );
}
