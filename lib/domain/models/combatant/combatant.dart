import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/domain/models/character/stats/stat.dart';
import 'package:going_wild/domain/models/character/stats/stats.dart';
import 'package:going_wild/domain/models/combatant/current_stat.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/lasting/combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/faction.dart';
import 'package:meta/meta.dart';

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
    required this.abilityCastCount,
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
  final int abilityCastCount;
  final int ticksUntilNextAttack;
  final List<CombatLastingEffect> combatLastingEffects;

  bool get isAlive => currentHealth > 0;
  bool get canAct => isAlive && !combatLastingEffects.any((combatLastingEffect) => combatLastingEffect.preventsActing);
  bool get isTargetable => isAlive && !combatLastingEffects.any((combatLastingEffect) => combatLastingEffect.preventsBeingTargeted);
  double get currentShield => combatLastingEffects.fold(0, (sum, combatLastingEffect) => sum + combatLastingEffect.absorbableDamage);

  double getCurrentStat(Stat stat) => currentStatOf(stat, stats: stats, combatLastingEffects: combatLastingEffects);

  @useResult
  Combatant createCopyWith({
    Position? position,
    double? currentMana,
    double? currentHealth,
    int? targetCombatantId,
    int? ticksUntilNextStep,
    int? abilityCastCount,
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
    abilityCastCount: abilityCastCount ?? this.abilityCastCount,
    ticksUntilNextAttack: ticksUntilNextAttack ?? this.ticksUntilNextAttack,
    combatLastingEffects: combatLastingEffects ?? this.combatLastingEffects,
  );

  @override
  String toString() => '${characterCopy.character.id.value}#$id';
}
