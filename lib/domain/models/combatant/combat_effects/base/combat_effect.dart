import 'package:going_wild/domain/models/character/abilities/ability_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/applying/combat_effect_application.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/combat_effect_context.dart';
import 'package:meta/meta.dart';

abstract class CombatEffect implements AbilityEffect {
  const CombatEffect();

  @useResult
  CombatEffectContext apply(CombatEffectApplication application);
}
