import '../../character/character.dart';
import '../../character/stats/stat.dart';
import '../../character/stats/stat_modification.dart';
import '../../character/stats/stats.dart';
import '../../combatant/combat_effects/base/lasting/combat_lasting_effect.dart';
import '../active_set.dart';
import '../set_effect.dart';
import '../set_effect_side.dart';
import '../set_target.dart';
import '../team_set.dart';
import 'set_engine.dart';

class BasicSetEngine extends SetEngine {
  const BasicSetEngine({required this.sets});

  final List<TeamSet> sets;

  @override
  List<ActiveSet> activeSets(List<Character> activeCharacters) {
    final activeSets = <ActiveSet>[];
    final activeCharactersSet = activeCharacters.toSet();

    for (final set in sets) {
      final presentMemberCount = set.members.where(activeCharactersSet.contains).length;
      final reachedTiers = set.tiers.where((tier) => tier.count <= presentMemberCount);
      if (reachedTiers.isNotEmpty) activeSets.add(ActiveSet(set: set, tier: reachedTiers.last));
    }

    return activeSets;
  }

  @override
  Stats statsWithSetEffects(Character character, Stats stats, {required SetEffectSide side, required List<ActiveSet> activeSets}) {
    final statModifications = [
      for (final effect in _reachingEffects(character, stats, activeSets, side)) ?effect.statModification,
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
    for (final effect in _reachingEffects(character, stats, activeSets, side))
      ?effect.startingLastingEffect(ownerCombatantId: ownerCombatantId, convertSecondsToTicks: convertSecondsToTicks),
  ];

  List<SetEffect> _reachingEffects(Character character, Stats stats, List<ActiveSet> activeSets, SetEffectSide side) => [
    for (final activeSet in activeSets)
      for (final effect in activeSet.tier.effects)
        if (_reaches(effect, activeSet.set, character, stats, side)) effect,
  ];
}

bool _reaches(SetEffect effect, TeamSet set, Character character, Stats stats, SetEffectSide side) {
  final isOwnTeam = side == SetEffectSide.ownTeam;

  return switch (effect.target) {
    SetTarget.entireTeam => isOwnTeam,
    SetTarget.setMembers => isOwnTeam && set.members.contains(character),
    SetTarget.teamMelees => isOwnTeam && stats[Stat.range] == 1,
    SetTarget.teamRangeds => isOwnTeam && stats[Stat.range] > 1,
    SetTarget.specificCharacter => isOwnTeam && effect.character == character,
    SetTarget.allEnemies => side == SetEffectSide.opposingTeam,
  };
}
