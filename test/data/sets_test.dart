import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/data/team/sets/sets.dart';
import 'package:going_wild/domain/models/models.dart';

extension<T> on List<T> {
  Iterable<(T, T)> zipWithNext() sync* {
    for (var i = 1; i < length; i++) yield (this[i - 1], this[i]);
  }
}

void main() {
  test('every set has at least two members and one tier', () {
    for (final s in allSets) {
      expect(s.members.length, greaterThanOrEqualTo(2), reason: s.id);
      expect(s.tiers, isNotEmpty, reason: s.id);
    }
  });

  test('tier counts grow, start at 2 and never exceed the member count', () {
    for (final s in allSets) {
      var previous = 1;

      for (final tier in s.tiers) {
        expect(tier.count, greaterThan(previous), reason: s.id);
        expect(tier.count, lessThanOrEqualTo(s.members.length), reason: s.id);
        expect(tier.effects, isNotEmpty, reason: '${s.id} tier ${tier.count}');
        previous = tier.count;
      }
    }
  });

  test('effects on enemies weaken them and effects on the team strengthen it', () {
    for (final s in allSets) {
      for (final effect in s.tiers.expand((t) => t.effects)) {
        if (effect.changeType != StatChangeType.multiplier) continue;

        final weakens = effect.target == SetTarget.allEnemies || effect.stat == Stat.damageTakenPercentage;
        final expected = weakens ? lessThan(1) : greaterThan(1);
        expect(effect.value, expected, reason: '${s.id} ${effect.target} ${effect.stat}');
      }
    }
  });

  test('higher tiers are never weaker than lower ones for the same stat and target', () {
    for (final s in allSets) {
      for (final (lower, higher) in s.tiers.zipWithNext()) {
        for (final low in lower.effects) {
          final high = higher.effects.where((e) => e.stat == low.stat && e.target == low.target);
          final weakens = low.changeType == StatChangeType.multiplier && low.value < 1;
          final expected = weakens ? lessThanOrEqualTo(low.value) : greaterThanOrEqualTo(low.value);

          for (final h in high) {
            expect(
              h.value,
              expected,
              reason: '${s.id} ${low.stat}',
            );
          }
        }
      }
    }
  });
}
