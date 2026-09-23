import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/data/team/characters/characters.dart';
import 'package:going_wild/domain/models/models.dart';

Iterable<AbilityEffect> flatten(Iterable<AbilityEffect> effects) sync* {
  for (final e in effects) {
    yield e;
    if (e is ShieldEffect) yield* flatten(e.onExpire);
  }
}

List<StarValues> starValuesOf(AbilityEffect e) => switch (e) {
  DamageEffect() => [e.value],
  DamageOverTimeEffect() => [e.valuePerSecond, e.seconds],
  HealEffect() => [e.valuePerSecond, e.seconds],
  ShieldEffect() => [e.value, e.seconds],
  StunEffect() => [e.seconds],
  TauntEffect() => [e.seconds],
  KnockbackEffect() => [],
  StatBuffEffect() => [e.value, e.seconds],
  NextHitsStatBuffEffect() => [e.value],
  StatDebuffEffect() => [e.value, e.seconds],
  ManaRefundOnKillEffect() => [],
};

void main() {
  final kebab = RegExp(r'^[a-z]+(-[a-z]+)*$');

  test('ability ids are unique and kebab-case', () {
    final ids = allCharacters.map((c) => c.ability.id).toSet();
    expect(ids.length, allCharacters.length);
    for (final id in ids) expect(id, matches(kebab), reason: id);
  });

  test('every ability has at least one effect', () {
    for (final c in allCharacters) {
      expect(
        c.ability.effects,
        isNotEmpty,
        reason: c.id,
      );
    }
  });

  test('mana starts below max', () {
    for (final c in allCharacters) {
      expect(c.mana.start, lessThan(c.mana.max), reason: c.id);
      expect(c.mana.start, greaterThanOrEqualTo(0), reason: c.id);
    }
  });

  test('star values are positive and never shrink with stars', () {
    for (final c in allCharacters) {
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
    for (final c in allCharacters) {
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
    for (final c in allCharacters) {
      for (final e in flatten(c.ability.effects)) {
        if (e is KnockbackEffect) expect(e.cells, greaterThanOrEqualTo(1), reason: c.id);
        if (e is ManaRefundOnKillEffect) expect(e.percentage, inInclusiveRange(1, 100), reason: c.id);
      }
    }
  });

  test('base stat multipliers are positive', () {
    for (final c in allCharacters) {
      final m = c.baseStatMultipliers;
      for (final v in [m.health, m.damage, m.armor, m.shield, m.attackSpeed, m.damageTakenPercentage]) {
        expect(
          v,
          greaterThan(0),
          reason: c.id,
        );
      }
    }
  });
}
