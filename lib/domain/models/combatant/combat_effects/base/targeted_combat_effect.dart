import 'combat_effect.dart';
import 'combat_effect_target.dart';

abstract class TargetedCombatEffect extends CombatEffect {
  const TargetedCombatEffect({required this.target});

  final CombatEffectTarget target;
}
