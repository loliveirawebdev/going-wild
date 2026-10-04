import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/domain/models/character/stats/stats.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/lasting/combat_lasting_effect.dart';
import 'package:going_wild/domain/models/set/active_set.dart';
import 'package:going_wild/domain/models/set/set_effect_side.dart';

abstract class SetEngine {
  const SetEngine();

  List<ActiveSet> activeSets(List<Character> activeCharacters);
  Stats statsWithSetEffects(Character character, Stats stats, {required SetEffectSide side, required List<ActiveSet> activeSets});

  List<CombatLastingEffect> startingLastingEffectsFor(
    Character character,
    Stats stats, {
    required SetEffectSide side,
    required int ownerCombatantId,
    required List<ActiveSet> activeSets,
    required int Function(double seconds) convertSecondsToTicks,
  });

  int bonusCoinsPerRound(List<ActiveSet> activeSets);
}
