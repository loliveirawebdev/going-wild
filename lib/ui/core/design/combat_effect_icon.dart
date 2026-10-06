enum CombatEffectIcon {
  ambush,
  buffed,
  debuffed,
  healing,
  poisoned,
  stunned,
  taunting;

  String get assetPath => 'assets/effects/$name.svg';
}
