import 'package:going_wild/domain/models/character/stats/stat_modification.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/lasting/combat_lasting_effect.dart';
import 'package:going_wild/domain/models/set/set_effect_targeting.dart';
import 'package:going_wild/domain/models/set/set_target.dart';

abstract class SetEffect {
  const SetEffect();

  SetTarget? get target => null;
  int get bonusCoinsPerRound => 0;

  StatModification? statModificationFor(SetEffectTargeting targeting) => null;

  CombatLastingEffect? startingLastingEffectFor(
    SetEffectTargeting targeting, {
    required int ownerCombatantId,
    required int Function(double seconds) convertSecondsToTicks,
  }) => null;
}
