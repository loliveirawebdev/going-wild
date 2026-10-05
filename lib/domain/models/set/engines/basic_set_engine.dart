import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/domain/models/character/stats/stat.dart';
import 'package:going_wild/domain/models/character/stats/stat_modification.dart';
import 'package:going_wild/domain/models/character/stats/stats.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/lasting/combat_lasting_effect.dart';
import 'package:going_wild/domain/models/set/active_set.dart';
import 'package:going_wild/domain/models/set/engines/set_engine.dart';
import 'package:going_wild/domain/models/set/set_effect_side.dart';
import 'package:going_wild/domain/models/set/set_effect_targeting.dart';
import 'package:going_wild/domain/models/set/set_presence.dart';
import 'package:going_wild/domain/models/set/team_set.dart';

class BasicSetEngine extends SetEngine {
  const BasicSetEngine({required this.sets});

  final List<TeamSet> sets;

  @override
  List<SetPresence> setPresences(List<Character> activeCharacters) {
    final setPresences = <SetPresence>[];
    final activeCharactersSet = activeCharacters.toSet();

    for (final set in sets) {
      final presentMemberCount = set.members.where(activeCharactersSet.contains).length;
      if (presentMemberCount > 0) setPresences.add(SetPresence(set: set, presentMemberCount: presentMemberCount));
    }

    return setPresences;
  }

  @override
  List<ActiveSet> activeSets(List<Character> activeCharacters) {
    final activeSets = <ActiveSet>[];

    for (final setPresence in setPresences(activeCharacters)) {
      final reachedTiers = setPresence.reachedTiers;
      if (reachedTiers.isNotEmpty) activeSets.add(ActiveSet(set: setPresence.set, tier: reachedTiers.last));
    }

    return activeSets;
  }

  @override
  Stats statsWithSetEffects(Character character, Stats stats, {required SetEffectSide side, required List<ActiveSet> activeSets}) {
    final statModifications = [
      for (final activeSet in activeSets)
        for (final effect in activeSet.tier.effects)
          ?effect.statModificationFor(_targetingOf(activeSet, side: side, stats: stats, character: character)),
    ];

    var statsWithEffects = stats;

    for (final stat in Stat.values) {
      final relatedStatModifications = statModifications.where((statModification) => statModification.stat == stat);
      if (relatedStatModifications.isEmpty) continue;

      statsWithEffects = statsWithEffects.createCopyWithStat(stat, applyStatModifications(stats[stat], relatedStatModifications));
    }

    return statsWithEffects;
  }

  @override
  List<CombatLastingEffect> startingLastingEffectsFor(
    Character character,
    Stats stats, {
    required SetEffectSide side,
    required int ownerCombatantId,
    required List<ActiveSet> activeSets,
    required int Function(double seconds) convertSecondsToTicks,
  }) => [
    for (final activeSet in activeSets)
      for (final effect in activeSet.tier.effects)
        ?effect.startingLastingEffectFor(
          _targetingOf(activeSet, side: side, stats: stats, character: character),
          ownerCombatantId: ownerCombatantId,
          convertSecondsToTicks: convertSecondsToTicks,
        ),
  ];

  @override
  int bonusCoinsPerRound(List<ActiveSet> activeSets) => [
    for (final activeSet in activeSets)
      for (final effect in activeSet.tier.effects) effect.bonusCoinsPerRound,
  ].fold(0, (sum, coins) => sum + coins);
}

SetEffectTargeting _targetingOf(ActiveSet activeSet, {required SetEffectSide side, required Stats stats, required Character character}) =>
    SetEffectTargeting(set: activeSet.set, side: side, stats: stats, character: character);
