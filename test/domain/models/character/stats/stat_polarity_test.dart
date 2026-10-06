import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/domain/models/character/stats/stat.dart';
import 'package:going_wild/domain/models/character/stats/stat_change_type.dart';
import 'package:going_wild/domain/models/character/stats/stat_modification.dart';

StatModification multiplierOf(Stat stat, double value) => StatModification(stat: stat, value: value, changeType: StatChangeType.multiplier);
StatModification additionOf(Stat stat, double value) =>
    StatModification(stat: stat, value: value, changeType: StatChangeType.absoluteValue);

void main() {
  test('raising a stat where more is better helps, lowering it hurts', () {
    expect(multiplierOf(Stat.damage, 1.3).isBeneficial, isTrue);
    expect(additionOf(Stat.armor, 10).isBeneficial, isTrue);
    expect(additionOf(Stat.armor, -10).isBeneficial, isFalse);
    expect(multiplierOf(Stat.attackSpeed, 0.8).isBeneficial, isFalse);
  });

  test('taking more damage and needing more mana to cast hurt, the opposite helps', () {
    expect(multiplierOf(Stat.damageTakenPercentage, 1.2).isBeneficial, isFalse);
    expect(multiplierOf(Stat.damageTakenPercentage, 0.8).isBeneficial, isTrue);
    expect(additionOf(Stat.manaMax, 20).isBeneficial, isFalse);
    expect(additionOf(Stat.manaMax, -20).isBeneficial, isTrue);
  });
}
