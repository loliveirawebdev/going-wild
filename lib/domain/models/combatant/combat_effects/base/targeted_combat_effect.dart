import 'package:going_wild/domain/models/combatant/combat_effects/base/combat_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/combat_effect_target.dart';

abstract class TargetedCombatEffect extends CombatEffect {
  const TargetedCombatEffect({required this.target});

  final CombatEffectTarget target;
}
