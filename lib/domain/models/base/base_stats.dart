class BaseStats {
  const BaseStats({
    required this.health,
    required this.damage,
    required this.armor,
    required this.shield,
    required this.attackSpeed,
    required this.damageTakenPercentage,
    required this.manaPerHit,
  });

  final double health;
  final double damage;
  final double armor;
  final double shield;
  final double attackSpeed;
  final double damageTakenPercentage;
  final int manaPerHit;
}
