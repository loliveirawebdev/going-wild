enum Rarity {
  common(coins: 1),
  uncommon(coins: 2),
  rare(coins: 3),
  epic(coins: 4);

  const Rarity({required this.coins});
  final int coins;
}
