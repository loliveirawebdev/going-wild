class BaseStatMultipliers {
  const BaseStatMultipliers({
    required this.health,
    required this.damage,
    required this.armor,
    required this.shield,
    required this.attackSpeed,
    required this.damageTakenPercentage,
  });

  final double health;
  final double damage;
  final double armor;
  final double shield;
  final double attackSpeed;
  final double damageTakenPercentage;
}
