import '../character/character.dart';
import '../character/stats/stat_modification.dart';
import '../combatant/combat_effects/base/lasting/combat_lasting_effect.dart';
import '../combatant/combat_effects/catalog/shield/shield_combat_lasting_effect.dart';
import 'set_target.dart';

sealed class SetEffect {
  const SetEffect({required this.target, this.character})
    : assert(
        (target == SetTarget.specificCharacter) == (character != null),
        'character is required when target is specificCharacter and must be null otherwise',
      );

  final SetTarget target;
  final Character? character;

  StatModification? get statModification => null;

  CombatLastingEffect? startingLastingEffect({
    required int ownerCombatantId,
    required int Function(double seconds) convertSecondsToTicks,
  }) => null;
}

class SetStatModification extends SetEffect {
  const SetStatModification({required super.target, required this.statModification, super.character});

  @override
  final StatModification statModification;
}

class SetStartingShield extends SetEffect {
  const SetStartingShield({required this.value, required this.seconds, required super.target, super.character});

  final double value;
  final double seconds;

  @override
  CombatLastingEffect startingLastingEffect({
    required int ownerCombatantId,
    required int Function(double seconds) convertSecondsToTicks,
  }) => ShieldCombatLastingEffect(
    onExpire: const [],
    remainingShield: value,
    sourceCombatantId: ownerCombatantId,
    remainingTicks: convertSecondsToTicks(seconds),
  );
}
