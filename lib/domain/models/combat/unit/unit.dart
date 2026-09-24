import '../../models.dart';
import '../board/faction.dart';
import '../board/position.dart';
import 'status_effect/stat_modification.dart';
import 'status_effect/status_effect.dart';

class Unit {
  Unit({
    required this.id,
    required this.stars,
    required this.stats,
    required this.faction,
    required this.position,
    required this.character,
  }) {
    currentHealth = stats.health;
    currentMana = stats.manaStart;
  }

  final int id;
  final int stars;
  final Stats stats;
  final Faction faction;
  final Character character;

  Unit? target;
  Position position;
  double secondsUntilNextStep = 0;
  double secondsUntilNextAttack = 0;
  bool lowHealthAbilityUsed = false;
  final List<StatusEffect> statusEffects = [];

  late double currentMana;
  late double currentHealth;
  double get currentShield => statusEffects.whereType<ShieldStatusEffect>().fold(0, (sum, shield) => sum + shield.remainingShield);

  bool get isAlive => currentHealth > 0;
  bool get isStunned => statusEffects.any((s) => s is StunStatusEffect);
  bool get isVanished => statusEffects.any((s) => s is VanishedStatusEffect);
  bool get canAct => isAlive && !isStunned && !isVanished;
  bool get isTargetable => isAlive && !isVanished;

  double getCurrentStat(Stat stat) {
    final relatedModifications = statusEffects.whereType<StatModification>().where((mod) => mod.stat == stat);
    final relatedMultipliers = relatedModifications.where((mod) => mod.changeType == StatChangeType.multiplier);
    final relatedAdditions = relatedModifications.where((mod) => mod.changeType == StatChangeType.absoluteValue);

    var currentStatValue = stats[stat];
    for (final relatedMultiplier in relatedMultipliers) currentStatValue *= relatedMultiplier.value;
    for (final relatedAddition in relatedAdditions) currentStatValue += relatedAddition.value;

    return currentStatValue;
  }

  @override
  String toString() => '${character.id}#$id';
}
