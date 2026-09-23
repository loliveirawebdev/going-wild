import 'stat.dart';

class Stats {
  const Stats({
    required this.health,
    required this.damage,
    required this.armor,
    required this.shield,
    required this.attackSpeed,
    required this.damageTakenPercentage,
    required this.manaStart,
    required this.manaMax,
    required this.range,
  });

  final double health;
  final double damage;
  final double armor;
  final double shield;
  final double attackSpeed;
  final double damageTakenPercentage;
  final double manaStart;
  final double manaMax;
  final double range;

  double operator [](Stat stat) => switch (stat) {
    Stat.health => health,
    Stat.damage => damage,
    Stat.armor => armor,
    Stat.shield => shield,
    Stat.attackSpeed => attackSpeed,
    Stat.damageTakenPercentage => damageTakenPercentage,
    Stat.manaStart => manaStart,
    Stat.manaMax => manaMax,
    Stat.range => range,
  };

  Stats withStat(Stat stat, double value) => switch (stat) {
    Stat.health => copyWith(health: value),
    Stat.damage => copyWith(damage: value),
    Stat.armor => copyWith(armor: value),
    Stat.shield => copyWith(shield: value),
    Stat.attackSpeed => copyWith(attackSpeed: value),
    Stat.damageTakenPercentage => copyWith(damageTakenPercentage: value),
    Stat.manaStart => copyWith(manaStart: value),
    Stat.manaMax => copyWith(manaMax: value),
    Stat.range => copyWith(range: value),
  };

  Stats copyWith({
    double? health,
    double? damage,
    double? armor,
    double? shield,
    double? attackSpeed,
    double? damageTakenPercentage,
    double? manaStart,
    double? manaMax,
    double? range,
  }) => Stats(
    health: health ?? this.health,
    damage: damage ?? this.damage,
    armor: armor ?? this.armor,
    shield: shield ?? this.shield,
    attackSpeed: attackSpeed ?? this.attackSpeed,
    damageTakenPercentage: damageTakenPercentage ?? this.damageTakenPercentage,
    manaStart: manaStart ?? this.manaStart,
    manaMax: manaMax ?? this.manaMax,
    range: range ?? this.range,
  );
}
