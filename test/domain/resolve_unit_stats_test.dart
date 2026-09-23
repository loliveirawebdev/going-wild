import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/data/team/base_stats.dart';
import 'package:going_wild/data/team/characters/characters.dart';
import 'package:going_wild/data/team/merge_curves/merge_curves.dart';
import 'package:going_wild/domain/models/models.dart';
import 'package:going_wild/domain/use_cases/resolve_unit_stats.dart';

Stats resolve(Character c, int stars) => resolveUnitStats(
  character: c,
  stars: stars,
  base: baseStats,
  curve: mergeCurveFor(c.role),
);

double power(Character c, int stars) {
  final s = resolve(c, stars);
  return s.health * s.damage * s.attackSpeed;
}

Iterable<Character> ofRarity(Rarity r) => allCharacters.where((c) => c.rarity == r);

void main() {
  test('1 star is the base times the character multipliers', () {
    for (final c in allCharacters) {
      final s = resolve(c, 1);

      for (final stat in Stat.values) {
        expect(
          s[stat],
          closeTo(baseStats[stat] * c.statMultipliers[stat], 0.001),
          reason: '${c.id} $stat',
        );
      }
    }
  });

  test('every star is base times multipliers times the merge curve', () {
    for (final c in allCharacters) {
      final curve = mergeCurveFor(c.role);
      for (final stars in [1, 2, 3]) {
        final s = resolve(c, stars);
        for (final stat in Stat.values) {
          final expected = baseStats[stat] * c.statMultipliers[stat] * curve[stat].at(stars);
          expect(s[stat], closeTo(expected, 0.001), reason: '${c.id} $stat $stars');
        }
      }
    }
  });

  test('a character with no multipliers is the base', () {
    const plain = Character(
      id: 'plain',
      role: Role.support,
      rarity: Rarity.common,
      statMultipliers: StatMultipliers({}),
      ability: Ability(id: 'none', effects: []),
    );

    final s = resolve(plain, 1);

    for (final stat in Stat.values) {
      expect(
        s[stat],
        baseStats[stat],
        reason: '$stat',
      );
    }
  });

  test('stars scale health and damage and keep attack speed, mana and range', () {
    for (final c in allCharacters) {
      final one = resolve(c, 1);
      final three = resolve(c, 3);
      expect(three.health, greaterThan(one.health), reason: c.id);
      expect(three.damage, greaterThan(one.damage), reason: c.id);
      expect(three.attackSpeed, one.attackSpeed, reason: c.id);
      expect(three.manaMax, one.manaMax, reason: c.id);
      expect(three.range, one.range, reason: c.id);
    }
  });

  test('rarity says strength: average 1-star power grows with rarity', () {
    double average(Rarity r) => ofRarity(r).map((c) => power(c, 1)).reduce((a, b) => a + b) / ofRarity(r).length;

    for (var i = 1; i < Rarity.values.length; i++) {
      expect(
        average(Rarity.values[i]),
        greaterThan(average(Rarity.values[i - 1])),
        reason: '${Rarity.values[i]}',
      );
    }
  });

  test('merge is the ladder: any common at 3 stars beats any epic at 1 star', () {
    for (final common in ofRarity(Rarity.common)) {
      for (final epic in ofRarity(Rarity.epic)) {
        expect(
          power(common, 3),
          greaterThan(power(epic, 1)),
          reason: '${common.id} vs ${epic.id}',
        );
      }
    }
  });

  test('an epic at 3 stars beats any non-epic at 3 stars', () {
    for (final epic in ofRarity(Rarity.epic)) {
      for (final other in allCharacters.where((c) => c.rarity != Rarity.epic)) {
        expect(
          power(epic, 3),
          greaterThan(power(other, 3)),
          reason: '${epic.id} vs ${other.id}',
        );
      }
    }
  });
}
