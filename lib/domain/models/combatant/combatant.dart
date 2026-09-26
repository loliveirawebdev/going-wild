import 'package:meta/meta.dart';

import '../board/position.dart';
import '../character/character_copy.dart';
import '../character/stats/stat.dart';
import '../character/stats/stat_modification.dart';
import '../character/stats/stats.dart';
import 'combat_effects/base/lasting/combat_lasting_effect.dart';
import 'faction.dart';

class Combatant {
  const Combatant({
    required this.id,
    required this.stats,
    required this.faction,
    required this.position,
    required this.characterCopy,
    required this.currentMana,
    required this.currentHealth,
    required this.targetCombatantId,
    required this.ticksUntilNextStep,
    required this.lowHealthAbilityUsed,
    required this.ticksUntilNextAttack,
    required this.combatLastingEffects,
  });

  final int id;
  final Stats stats;
  final Faction faction;
  final Position position;
  final CharacterCopy characterCopy;
  final double currentMana;
  final double currentHealth;
  final int? targetCombatantId;
  final int ticksUntilNextStep;
  final bool lowHealthAbilityUsed;
  final int ticksUntilNextAttack;
  final List<CombatLastingEffect> combatLastingEffects;

  bool get isAlive => currentHealth > 0;
  bool get canAct => isAlive && !combatLastingEffects.any((combatLastingEffect) => combatLastingEffect.preventsActing);
  bool get isTargetable => isAlive && !combatLastingEffects.any((combatLastingEffect) => combatLastingEffect.preventsBeingTargeted);
  double get currentShield => combatLastingEffects.fold(0, (sum, combatLastingEffect) => sum + combatLastingEffect.absorbableDamage);

  double getCurrentStat(Stat stat) {
    final relatedStatModifications = combatLastingEffects
        .map((combatLastingEffect) => combatLastingEffect.statModification)
        .nonNulls
        .where((statModification) => statModification.stat == stat);

    return applyStatModifications(stats[stat], relatedStatModifications);
  }

  @useResult
  Combatant createCopyWith({
    Position? position,
    double? currentMana,
    double? currentHealth,
    int? targetCombatantId,
    int? ticksUntilNextStep,
    bool? lowHealthAbilityUsed,
    int? ticksUntilNextAttack,
    List<CombatLastingEffect>? combatLastingEffects,
  }) => Combatant(
    id: id,
    stats: stats,
    faction: faction,
    characterCopy: characterCopy,
    position: position ?? this.position,
    currentMana: currentMana ?? this.currentMana,
    currentHealth: currentHealth ?? this.currentHealth,
    targetCombatantId: targetCombatantId ?? this.targetCombatantId,
    ticksUntilNextStep: ticksUntilNextStep ?? this.ticksUntilNextStep,
    lowHealthAbilityUsed: lowHealthAbilityUsed ?? this.lowHealthAbilityUsed,
    ticksUntilNextAttack: ticksUntilNextAttack ?? this.ticksUntilNextAttack,
    combatLastingEffects: combatLastingEffects ?? this.combatLastingEffects,
  );

  @override
  String toString() => '${characterCopy.character.id.value}#$id';
}
