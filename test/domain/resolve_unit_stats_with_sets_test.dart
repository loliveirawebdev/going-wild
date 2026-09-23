import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/data/team/base_stats.dart';
import 'package:going_wild/data/team/characters/characters.dart';
import 'package:going_wild/data/team/merge_curves/merge_curves.dart';
import 'package:going_wild/data/team/sets/sets.dart';
import 'package:going_wild/domain/models/models.dart';
import 'package:going_wild/domain/use_cases/active_set_tiers.dart';
import 'package:going_wild/domain/use_cases/resolve_unit_stats.dart';

Stats resolve(Character c, List<ActiveSet> activeSets) => resolveUnitStats(
  character: c,
  stars: 1,
  base: baseStats,
  curve: mergeCurveFor(c.role),
  activeSets: activeSets,
);

ActiveSet activeWith(List<SetEffect> effects, {List<Character> members = const []}) {
  final tier = SetTier(count: 2, effects: effects);
  return (set: TeamSet(id: 'test', members: members, tiers: [tier]), tier: tier);
}

const melee = chicken;
final rangedCharacter = allCharacters.firstWhere((c) => c.statMultipliers[Stat.range] > 1);
final meleeCharacter = allCharacters.firstWhere((c) => c.statMultipliers[Stat.range] == 1);

void main() {
  test('no active sets equals the plain resolution', () {
    for (final c in allCharacters) {
      for (final stat in Stat.values) {
        expect(resolve(c, [])[stat], resolve(c, const [])[stat], reason: '${c.id} $stat');
      }
    }
  });

  test('entireTeam reaches everyone', () {
    final set = activeWith([
      const SetEffect(target: SetTarget.entireTeam, stat: Stat.damage, changeType: StatChangeType.multiplier, value: 2),
    ]);
    for (final c in allCharacters) {
      expect(resolve(c, [set]).damage, closeTo(resolve(c, []).damage * 2, 0.001), reason: c.id);
    }
  });

  test('setMembers reaches only members', () {
    final set = activeWith(
      [
        const SetEffect(
          target: SetTarget.setMembers,
          stat: Stat.health,
          changeType: StatChangeType.multiplier,
          value: 2,
        ),
      ],
      members: [meleeCharacter],
    );
    expect(resolve(meleeCharacter, [set]).health, closeTo(resolve(meleeCharacter, []).health * 2, 0.001));
    expect(resolve(rangedCharacter, [set]).health, resolve(rangedCharacter, []).health);
  });

  test('teamMelees and teamRangeds split by range', () {
    final melees = activeWith([
      const SetEffect(
        target: SetTarget.teamMelees,
        stat: Stat.armor,
        changeType: StatChangeType.absoluteValue,
        value: 10,
      ),
    ]);
    final rangeds = activeWith([
      const SetEffect(
        target: SetTarget.teamRangeds,
        stat: Stat.armor,
        changeType: StatChangeType.absoluteValue,
        value: 10,
      ),
    ]);
    expect(resolve(meleeCharacter, [melees]).armor, resolve(meleeCharacter, []).armor + 10);
    expect(resolve(meleeCharacter, [rangeds]).armor, resolve(meleeCharacter, []).armor);
    expect(resolve(rangedCharacter, [rangeds]).armor, resolve(rangedCharacter, []).armor + 10);
    expect(resolve(rangedCharacter, [melees]).armor, resolve(rangedCharacter, []).armor);
  });

  test('specificCharacter reaches only that character', () {
    final set = activeWith([
      SetEffect(
        target: SetTarget.specificCharacter,
        character: meleeCharacter,
        stat: Stat.damage,
        changeType: StatChangeType.multiplier,
        value: 3,
      ),
    ]);
    expect(resolve(meleeCharacter, [set]).damage, closeTo(resolve(meleeCharacter, []).damage * 3, 0.001));
    expect(resolve(rangedCharacter, [set]).damage, resolve(rangedCharacter, []).damage);
  });

  test('allEnemies never touches the team', () {
    final set = activeWith([
      const SetEffect(
        target: SetTarget.allEnemies,
        stat: Stat.armor,
        changeType: StatChangeType.multiplier,
        value: 0.5,
      ),
    ]);
    for (final c in allCharacters) {
      expect(resolve(c, [set]).armor, resolve(c, []).armor, reason: c.id);
    }
  });

  test('multipliers apply before absolute values, whatever the order given', () {
    const times2 = SetEffect(
      target: SetTarget.entireTeam,
      stat: Stat.shield,
      changeType: StatChangeType.multiplier,
      value: 2,
    );
    const plus100 = SetEffect(
      target: SetTarget.entireTeam,
      stat: Stat.shield,
      changeType: StatChangeType.absoluteValue,
      value: 100,
    );
    final base = resolve(melee, []).shield;
    final expected = base * 2 + 100;
    expect(
      resolve(melee, [
        activeWith([times2, plus100]),
      ]).shield,
      closeTo(expected, 0.001),
    );
    expect(
      resolve(melee, [
        activeWith([plus100, times2]),
      ]).shield,
      closeTo(expected, 0.001),
    );
    expect(
      resolve(melee, [
        activeWith([plus100]),
        activeWith([times2]),
      ]).shield,
      closeTo(expected, 0.001),
    );
  });

  test('real roster: a full dairy board gives everyone the top shield', () {
    final dairy = allSets.firstWhere((s) => s.id == 'dairy');
    final active = activeSetTiers(activeCharacters: dairy.members, availableSets: allSets);
    final shield = dairy.tiers.last.effects.single.value;
    for (final c in dairy.members) {
      expect(resolve(c, active).shield, greaterThanOrEqualTo(shield), reason: c.id);
    }
  });
}
