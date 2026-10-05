enum GameIcon {
  gold('gold'),
  star('star'),
  lock('lock'),
  shop('shop'),
  mana('mana'),
  timer('timer'),
  heart('heart'),
  sword('sword'),
  melee('melee'),
  ranged('ranged'),
  reroll('reroll'),
  experience('xp'),
  shield('shield'),
  trophy('trophy'),
  barrier('barrier'),
  settings('settings'),
  attackSpeed('attack-speed');

  const GameIcon(this.fileName);

  final String fileName;
  String get assetPath => 'assets/icons/$fileName.svg';
}
