import 'package:going_wild/domain/models/combatant/combat_effects/base/applying/combat_effect_targeting.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/combat_effect_target.dart';
import 'package:going_wild/domain/models/combatant/combatant.dart';

class FocusTarget extends CombatEffectTarget {
  const FocusTarget();

  @override
  bool get reachesEnemies => true;

  @override
  List<Combatant> resolve(CombatEffectTargeting targeting) {
    final focusCombatant = targeting.focusCombatant;
    return focusCombatant == null ? [] : [focusCombatant];
  }
}
