import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/content/engines/character/basic_character_engine.dart';
import 'package:going_wild/content/engines/set/basic_set_engine.dart';
import 'package:going_wild/content/set/sets.dart';
import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/domain/models/character/stats/stat.dart';
import 'package:going_wild/domain/models/character/stats/stat_change_type.dart';
import 'package:going_wild/domain/models/character/stats/stat_modification.dart';
import 'package:going_wild/domain/models/character/stats/stats.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/lasting/combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/shield/shield_combat_lasting_effect.dart';
import 'package:going_wild/domain/models/set/active_set.dart';
import 'package:going_wild/domain/models/set/set_effect.dart';
import 'package:going_wild/domain/models/set/set_effect_side.dart';
import 'package:going_wild/domain/models/set/set_id.dart';
import 'package:going_wild/domain/models/set/set_target.dart';
import 'package:going_wild/domain/models/set/set_tier.dart';
import 'package:going_wild/domain/models/set/team_set.dart';

Stats statsOf(Character character) => basicCharacterEngine.statsAtStars(character, stars: 1);

Stats resolve(Character character, List<ActiveSet> activeSets, {SetEffectSide side = SetEffectSide.ownTeam}) =>
    basicSetEngine.statsWithSetEffects(character, statsOf(character), side: side, activeSets: activeSets);

ActiveSet activeWith(List<SetEffect> effects, {List<Character> members = const []}) {
  final tier = SetTier(count: 2, effects: effects);
  return ActiveSet(
    tier: tier,
    set: TeamSet(tiers: [tier], id: const SetId('flyers'), members: members),
  );
}

SetStatModification statModificationFor(
  SetTarget target,
  Stat stat,
  double value, {
  Character? character,
  StatChangeType changeType = StatChangeType.multiplier,
}) => SetStatModification(
  target: target,
  character: character,
  statModification: StatModification(stat: stat, value: value, changeType: changeType),
);

const ownerCombatantId = 7;

List<CombatLastingEffect> startingLastingEffectsOf(Character character, List<ActiveSet> activeSets) =>
    basicSetEngine.startingLastingEffectsFor(
      character,
      statsOf(character),
      activeSets: activeSets,
      side: SetEffectSide.ownTeam,
      ownerCombatantId: ownerCombatantId,
      convertSecondsToTicks: (seconds) => (seconds * 10).round(),
    );

final rangedCharacter = allTeamCharacters.firstWhere((character) => character.statMultipliers[Stat.range] > 1);
final meleeCharacter = allTeamCharacters.firstWhere((character) => character.statMultipliers[Stat.range] == 1);

void main() {
  test('no active sets keeps the stats at stars', () {
    for (final character in allTeamCharacters) {
      for (final stat in Stat.values) {
        expect(resolve(character, const [])[stat], statsOf(character)[stat], reason: '${character.id.value} $stat');
      }
    }
  });

  test('entireTeam reaches everyone of the own team', () {
    final activeSet = activeWith([statModificationFor(SetTarget.entireTeam, Stat.damage, 2)]);

    for (final character in allTeamCharacters) {
      expect(
        resolve(character, [activeSet])[Stat.damage],
        closeTo(statsOf(character)[Stat.damage] * 2, 0.001),
        reason: character.id.value,
      );
    }
  });

  test('setMembers reaches only members', () {
    final activeSet = activeWith([statModificationFor(SetTarget.setMembers, Stat.health, 2)], members: [meleeCharacter]);

    expect(resolve(meleeCharacter, [activeSet])[Stat.health], closeTo(statsOf(meleeCharacter)[Stat.health] * 2, 0.001));
    expect(resolve(rangedCharacter, [activeSet])[Stat.health], statsOf(rangedCharacter)[Stat.health]);
  });

  test('teamMelees and teamRangeds split by range', () {
    final meleesSet = activeWith([statModificationFor(SetTarget.teamMelees, Stat.armor, 10, changeType: StatChangeType.absoluteValue)]);
    final rangedsSet = activeWith([statModificationFor(SetTarget.teamRangeds, Stat.armor, 10, changeType: StatChangeType.absoluteValue)]);

    expect(resolve(meleeCharacter, [meleesSet])[Stat.armor], statsOf(meleeCharacter)[Stat.armor] + 10);
    expect(resolve(meleeCharacter, [rangedsSet])[Stat.armor], statsOf(meleeCharacter)[Stat.armor]);
    expect(resolve(rangedCharacter, [rangedsSet])[Stat.armor], statsOf(rangedCharacter)[Stat.armor] + 10);
    expect(resolve(rangedCharacter, [meleesSet])[Stat.armor], statsOf(rangedCharacter)[Stat.armor]);
  });

  test('specificCharacter reaches only that character', () {
    final activeSet = activeWith([statModificationFor(SetTarget.specificCharacter, Stat.damage, 3, character: meleeCharacter)]);

    expect(resolve(meleeCharacter, [activeSet])[Stat.damage], closeTo(statsOf(meleeCharacter)[Stat.damage] * 3, 0.001));
    expect(resolve(rangedCharacter, [activeSet])[Stat.damage], statsOf(rangedCharacter)[Stat.damage]);
  });

  test('allEnemies never touches the own team and reaches the opposing team', () {
    final activeSet = activeWith([statModificationFor(SetTarget.allEnemies, Stat.armor, 0.5)]);

    for (final character in allTeamCharacters) {
      final ownTeamArmor = resolve(character, [activeSet])[Stat.armor];
      final opposingTeamArmor = resolve(character, [activeSet], side: SetEffectSide.opposingTeam)[Stat.armor];

      expect(ownTeamArmor, statsOf(character)[Stat.armor], reason: character.id.value);
      expect(opposingTeamArmor, closeTo(statsOf(character)[Stat.armor] * 0.5, 0.001), reason: character.id.value);
    }
  });

  test('effects aimed at the own team never reach the opposing team', () {
    final activeSet = activeWith([statModificationFor(SetTarget.entireTeam, Stat.damage, 2)]);

    for (final character in allTeamCharacters) {
      final opposingTeamDamage = resolve(character, [activeSet], side: SetEffectSide.opposingTeam)[Stat.damage];
      expect(opposingTeamDamage, statsOf(character)[Stat.damage], reason: character.id.value);
    }
  });

  test('multipliers apply before absolute values, whatever the order given', () {
    final timesTwo = statModificationFor(SetTarget.entireTeam, Stat.health, 2);
    final plusHundred = statModificationFor(SetTarget.entireTeam, Stat.health, 100, changeType: StatChangeType.absoluteValue);
    final expectedHealth = statsOf(chicken)[Stat.health] * 2 + 100;

    final givenInOrder = resolve(chicken, [
      activeWith([timesTwo, plusHundred]),
    ]);
    final givenReversed = resolve(chicken, [
      activeWith([plusHundred, timesTwo]),
    ]);
    final givenInSeparateSets = resolve(chicken, [
      activeWith([plusHundred]),
      activeWith([timesTwo]),
    ]);

    expect(givenInOrder[Stat.health], closeTo(expectedHealth, 0.001));
    expect(givenReversed[Stat.health], closeTo(expectedHealth, 0.001));
    expect(givenInSeparateSets[Stat.health], closeTo(expectedHealth, 0.001));
  });

  test('starting shields become shields owned by the combatant and follow the same targeting', () {
    const startingShield = SetStartingShield(value: 150, seconds: 8, target: SetTarget.setMembers);
    final activeSet = activeWith([startingShield], members: [meleeCharacter]);

    final meleeShields = startingLastingEffectsOf(meleeCharacter, [activeSet]);
    final shield = meleeShields.single as ShieldCombatLastingEffect;

    expect(shield.remainingShield, 150);
    expect(shield.remainingTicks, 80);
    expect(shield.sourceCombatantId, ownerCombatantId);
    expect(startingLastingEffectsOf(rangedCharacter, [activeSet]), isEmpty);

    for (final stat in Stat.values) {
      expect(resolve(meleeCharacter, [activeSet])[stat], statsOf(meleeCharacter)[stat], reason: '$stat');
    }
  });

  test('stat modifications start no lasting effect', () {
    final activeSet = activeWith([statModificationFor(SetTarget.entireTeam, Stat.damage, 2)]);
    expect(startingLastingEffectsOf(meleeCharacter, [activeSet]), isEmpty);
  });

  test('real roster: a full producers board gives everyone the top starting shield', () {
    final producersSet = allSets.firstWhere((set) => set.id == const SetId('producers'));
    final activeSets = basicSetEngine.activeSets(producersSet.members);
    final topStartingShield = producersSet.tiers.last.effects.whereType<SetStartingShield>().single;

    for (final character in producersSet.members) {
      final shields = startingLastingEffectsOf(character, activeSets).whereType<ShieldCombatLastingEffect>();
      expect(shields.map((shield) => shield.remainingShield), [topStartingShield.value], reason: character.id.value);
    }
  });
}
