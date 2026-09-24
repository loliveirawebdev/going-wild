import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/data/character/enemies/enemies.dart';
import 'package:going_wild/data/character/team/team.dart';
import 'package:going_wild/domain/models/models.dart';

void main() {
  final snake = RegExp(r'^[a-z]+(_[a-z]+)*$');

  test('enemy ids are unique, snake_case and do not collide with the team', () {
    final ids = allEnemies.map((c) => c.id).toSet();
    expect(ids.length, allEnemies.length);

    for (final id in ids) {
      expect(
        id,
        matches(snake),
        reason: id,
      );
    }

    expect(ids.intersection(allTeamCharacters.map((c) => c.id).toSet()), isEmpty);
  });

  test('every enemy defines every stat explicitly', () {
    for (final c in allEnemies) {
      for (final stat in Stat.values) {
        expect(
          c.statMultipliers.defines(stat),
          isTrue,
          reason: '${c.id} $stat',
        );
      }
    }
  });

  test('multipliers are positive, mana starts below max and range is 1, 2 or 4', () {
    for (final c in allEnemies) {
      for (final stat in Stat.values.where((s) => s != Stat.manaStart)) {
        expect(
          c.statMultipliers[stat],
          greaterThan(0),
          reason: '${c.id} $stat',
        );
      }

      expect(c.statMultipliers[Stat.manaStart], lessThan(c.statMultipliers[Stat.manaMax]), reason: c.id);
      expect([1, 2, 4], contains(c.statMultipliers[Stat.range]), reason: c.id);
    }
  });

  test('every enemy has an ability with at least one effect', () {
    for (final c in allEnemies) {
      expect(
        c.ability.effects,
        isNotEmpty,
        reason: c.id,
      );
    }
  });
}
