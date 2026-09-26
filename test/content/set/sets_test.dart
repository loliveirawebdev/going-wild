import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/set/sets.dart';
import 'package:going_wild/domain/models/character/stats/stat.dart';
import 'package:going_wild/domain/models/character/stats/stat_change_type.dart';
import 'package:going_wild/domain/models/set/set_effect.dart';
import 'package:going_wild/domain/models/set/set_target.dart';
import 'package:going_wild/domain/models/set/set_tier.dart';

Iterable<(SetTier, SetTier)> consecutiveTiersOf(List<SetTier> tiers) sync* {
  for (var index = 1; index < tiers.length; index++) {
    yield (tiers[index - 1], tiers[index]);
  }
}

bool weakens(SetStatModification setStatModification) {
  final statModification = setStatModification.statModification;
  final isOnEnemies = setStatModification.target == SetTarget.allEnemies;
  final isDamageTaken = statModification.stat == Stat.damageTakenPercentage;

  return isOnEnemies != isDamageTaken;
}

void main() {
  test('every set has at least two members and one tier', () {
    for (final set in allSets) {
      expect(set.members.length, greaterThanOrEqualTo(2), reason: set.id.value);
      expect(set.tiers, isNotEmpty, reason: set.id.value);
    }
  });

  test('tier counts grow, start at 2 and never exceed the member count', () {
    for (final set in allSets) {
      var previousCount = 1;

      for (final tier in set.tiers) {
        expect(tier.count, greaterThan(previousCount), reason: set.id.value);
        expect(tier.count, lessThanOrEqualTo(set.members.length), reason: set.id.value);
        expect(tier.effects, isNotEmpty, reason: '${set.id.value} tier ${tier.count}');
        previousCount = tier.count;
      }
    }
  });

  test('stat modifications on enemies weaken them and on the team strengthen it', () {
    for (final set in allSets) {
      for (final effect in set.tiers.expand((tier) => tier.effects).whereType<SetStatModification>()) {
        final statModification = effect.statModification;
        if (statModification.changeType != StatChangeType.multiplier) continue;

        final expectedValue = weakens(effect) ? lessThan(1) : greaterThan(1);
        expect(statModification.value, expectedValue, reason: '${set.id.value} ${effect.target} ${statModification.stat}');
      }
    }
  });

  test('starting shields protect for a positive amount and time', () {
    for (final set in allSets) {
      for (final startingShield in set.tiers.expand((tier) => tier.effects).whereType<SetStartingShield>()) {
        expect(startingShield.value, greaterThan(0), reason: set.id.value);
        expect(startingShield.seconds, greaterThan(0), reason: set.id.value);
      }
    }
  });

  test('higher tiers are never weaker than lower ones for the same stat and target', () {
    for (final set in allSets) {
      for (final (lowerTier, higherTier) in consecutiveTiersOf(set.tiers)) {
        for (final lowerEffect in lowerTier.effects.whereType<SetStatModification>()) {
          final lowerValue = lowerEffect.statModification.value;
          final isWeakening = lowerEffect.statModification.changeType == StatChangeType.multiplier && lowerValue < 1;
          final expectedValue = isWeakening ? lessThanOrEqualTo(lowerValue) : greaterThanOrEqualTo(lowerValue);

          final matchingHigherEffects = higherTier.effects.whereType<SetStatModification>().where(
            (higherEffect) =>
                higherEffect.target == lowerEffect.target && higherEffect.statModification.stat == lowerEffect.statModification.stat,
          );

          for (final higherEffect in matchingHigherEffects) {
            expect(higherEffect.statModification.value, expectedValue, reason: '${set.id.value} ${lowerEffect.statModification.stat}');
          }
        }

        for (final lowerShield in lowerTier.effects.whereType<SetStartingShield>()) {
          final matchingHigherShields = higherTier.effects.whereType<SetStartingShield>().where(
            (higherShield) => higherShield.target == lowerShield.target,
          );

          for (final higherShield in matchingHigherShields) {
            expect(higherShield.value, greaterThanOrEqualTo(lowerShield.value), reason: '${set.id.value} starting shield');
          }
        }
      }
    }
  });
}
