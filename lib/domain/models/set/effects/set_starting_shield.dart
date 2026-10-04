import 'package:going_wild/domain/models/combatant/combat_effects/base/lasting/combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/shield/shield_combat_lasting_effect.dart';
import 'package:going_wild/domain/models/set/set_effect.dart';
import 'package:going_wild/domain/models/set/set_effect_targeting.dart';
import 'package:going_wild/domain/models/set/set_target.dart';

class SetStartingShield extends SetEffect {
  const SetStartingShield({required this.value, required this.target, required this.seconds});

  final double value;
  @override
  final SetTarget target;

  final double seconds;

  @override
  CombatLastingEffect? startingLastingEffectFor(
    SetEffectTargeting targeting, {
    required int ownerCombatantId,
    required int Function(double seconds) convertSecondsToTicks,
  }) {
    if (!target.reaches(targeting)) return null;

    return ShieldCombatLastingEffect(
      onExpire: const [],
      remainingShield: value,
      sourceCombatantId: ownerCombatantId,
      remainingTicks: convertSecondsToTicks(seconds),
    );
  }
}
