enum Stat {
  health(isHigherBetter: true),
  damage(isHigherBetter: true),
  armor(isHigherBetter: true),
  attackSpeed(isHigherBetter: true),
  moveSpeed(isHigherBetter: true),
  damageTakenPercentage(isHigherBetter: false),
  manaStart(isHigherBetter: true),
  manaMax(isHigherBetter: false),
  range(isHigherBetter: true);

  final bool isHigherBetter;
  const Stat({required this.isHigherBetter});
}
