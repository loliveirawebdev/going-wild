import '../base/star_values.dart';

class MergeCurve {
  const MergeCurve({
    required this.health,
    required this.damage,
    required this.armor,
    required this.shield,
    required this.attackSpeed,
    required this.damageTakenPercentage,
    required this.mana,
    required this.range,
  });

  final StarValues health;
  final StarValues damage;
  final StarValues armor;
  final StarValues shield;
  final StarValues attackSpeed;
  final StarValues damageTakenPercentage;
  final StarValues mana;
  final StarValues range;
}
