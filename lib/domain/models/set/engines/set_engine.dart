import '../../character/character.dart';
import '../../character/stats/stats.dart';
import '../../combatant/combat_effects/base/lasting/combat_lasting_effect.dart';
import '../active_set.dart';
import '../set_effect_side.dart';

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
}
