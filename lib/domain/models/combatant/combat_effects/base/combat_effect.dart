import 'package:meta/meta.dart';

import '../../../character/abilities/ability_effect.dart';
import 'applying/combat_effect_application.dart';
import 'combat_effect_context.dart';

abstract class CombatEffect implements AbilityEffect {
  const CombatEffect();

  @useResult
  CombatEffectContext apply(CombatEffectApplication application);
}
