import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/data/character/team/team.dart';
import 'package:going_wild/domain/models/models.dart';

Iterable<AbilityEffect> flatten(Iterable<AbilityEffect> effects) sync* {
  for (final e in effects) {
    yield e;
    if (e is ShieldEffect) yield* flatten(e.onExpire);
  }
}

List<StarValues> starValuesOf(AbilityEffect e) => switch (e) {
  DamageEffect() => [e.value],
  DamageOverTimeEffect() => [e.damagePerSecond, e.seconds],
  HealEffect() => [e.healPerSecond, e.seconds],
  ShieldEffect() => [e.value, e.seconds],
  StunEffect() => [e.seconds],
  TauntEffect() => [e.seconds],
  KnockbackEffect() => [],
  StatBuffEffect() => [e.value, e.seconds],
  NextHitsStatBuffEffect() => [e.value],
  StatDebuffEffect() => [e.value, e.seconds],
  ManaRefundOnKillEffect() => [],
  LifestealEffect() => [e.value],
  PullEffect() => [],
  AmbushEffect() => [e.seconds],
};

void main() {
  final snake = RegExp(r'^[a-z]+(_[a-z]+)*$');

  test('ability ids are unique and snake_case', () {
    final ids = allTeamCharacters.map((c) => c.ability.id).toSet();
    expect(ids.length, allTeamCharacters.length);
    for (final id in ids) expect(id, matches(snake), reason: id);
  });

  test('every ability has at least one effect', () {
    for (final c in allTeamCharacters) {
      expect(
        c.ability.effects,
        isNotEmpty,
        reason: c.id,
      );
    }
  });

  test('mana starts below max', () {
    for (final c in allTeamCharacters) {
      expect(c.statMultipliers[Stat.manaStart], lessThan(c.statMultipliers[Stat.manaMax]), reason: c.id);
      expect(c.statMultipliers[Stat.manaStart], greaterThanOrEqualTo(0), reason: c.id);
    }
  });

  test('star values are positive and never shrink with stars', () {
    for (final c in allTeamCharacters) {
      for (final e in flatten(c.ability.effects)) {
        for (final s in starValuesOf(e)) {
          expect(s.star1, greaterThan(0), reason: '${c.id} ${e.runtimeType}');
          expect(s.star2, greaterThanOrEqualTo(s.star1), reason: '${c.id} ${e.runtimeType}');
          expect(s.star3, greaterThanOrEqualTo(s.star2), reason: '${c.id} ${e.runtimeType}');
        }
      }
    }
  });

  test('debuffs weaken and buffs strengthen', () {
    for (final c in allTeamCharacters) {
      for (final e in flatten(c.ability.effects)) {
        if (e is StatDebuffEffect && e.changeType == StatChangeType.multiplier) {
          expect(
            e.value.star1,
            lessThan(1),
            reason: c.id,
          );
        }

        if (e is StatBuffEffect && e.changeType == StatChangeType.multiplier) {
          expect(
            e.value.star1,
            greaterThan(1),
            reason: c.id,
          );
        }
      }
    }
  });

  test('knockbacks move at least one cell and refunds are a valid percentage', () {
    for (final c in allTeamCharacters) {
      for (final e in flatten(c.ability.effects)) {
        if (e is KnockbackEffect) expect(e.cells, greaterThanOrEqualTo(1), reason: c.id);
        if (e is ManaRefundOnKillEffect) expect(e.percentage, inInclusiveRange(1, 100), reason: c.id);
      }
    }
  });

  test('every character defines every stat explicitly', () {
    for (final c in allTeamCharacters) {
      for (final stat in Stat.values) {
        expect(
          c.statMultipliers.defines(stat),
          isTrue,
          reason: '${c.id} $stat',
        );
      }
    }
  });

  test('multipliers are positive and range is 1, 2 or 4 cells', () {
    for (final c in allTeamCharacters) {
      for (final stat in Stat.values.where((s) => s != Stat.manaStart)) {
        expect(
          c.statMultipliers[stat],
          greaterThan(0),
          reason: '${c.id} $stat',
        );
      }

      expect([1, 2, 4], contains(c.statMultipliers[Stat.range]), reason: c.id);
    }
  });
}
