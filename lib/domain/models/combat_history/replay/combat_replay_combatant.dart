import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/domain/models/character/stats/melee_range.dart';
import 'package:going_wild/domain/models/character/stats/stat.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/lasting/combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combatant.dart';
import 'package:going_wild/domain/models/combatant/faction.dart';
import 'package:meta/meta.dart';

class CombatReplayCombatant {
  const CombatReplayCombatant({
    required this.id,
    required this.faction,
    required this.maxMana,
    required this.position,
    required this.maxHealth,
    required this.attackRange,
    required this.currentMana,
    required this.characterCopy,
    required this.currentHealth,
    required this.targetCombatantId,
    required this.combatLastingEffects,
  });

  CombatReplayCombatant.fromCombatant(Combatant combatant)
    : this(
        id: combatant.id,
        faction: combatant.faction,
        position: combatant.position,
        currentMana: combatant.currentMana,
        maxMana: combatant.stats[Stat.manaMax],
        characterCopy: combatant.characterCopy,
        currentHealth: combatant.currentHealth,
        maxHealth: combatant.stats[Stat.health],
        attackRange: combatant.stats[Stat.range],
        targetCombatantId: combatant.targetCombatantId,
        combatLastingEffects: combatant.combatLastingEffects,
      );

  final int id;
  final Faction faction;
  final double maxMana;
  final Position position;
  final double maxHealth;
  final double attackRange;
  final double currentMana;
  final CharacterCopy characterCopy;
  final double currentHealth;
  final int? targetCombatantId;
  final List<CombatLastingEffect> combatLastingEffects;

  bool get isAlive => currentHealth > 0;
  bool get isRanged => !isMeleeRange(attackRange);
  double get currentShield => combatLastingEffects.fold(0, (sum, combatLastingEffect) => sum + combatLastingEffect.absorbableDamage);

  @useResult
  CombatReplayCombatant createCopyWith({
    Position? position,
    double? currentMana,
    double? currentHealth,
    int? targetCombatantId,
    List<CombatLastingEffect>? combatLastingEffects,
  }) => CombatReplayCombatant(
    id: id,
    faction: faction,
    maxMana: maxMana,
    maxHealth: maxHealth,
    attackRange: attackRange,
    characterCopy: characterCopy,
    position: position ?? this.position,
    currentMana: currentMana ?? this.currentMana,
    currentHealth: currentHealth ?? this.currentHealth,
    targetCombatantId: targetCombatantId ?? this.targetCombatantId,
    combatLastingEffects: combatLastingEffects ?? this.combatLastingEffects,
  );

  @useResult
  CombatReplayCombatant createCopyWithLastingEffectStarted(CombatLastingEffect startedEffect) {
    final isAlreadyActive = combatLastingEffects.any((effect) => identical(effect, startedEffect));
    if (isAlreadyActive) return this;

    return createCopyWith(combatLastingEffects: List.unmodifiable([...combatLastingEffects, startedEffect]));
  }

  @useResult
  CombatReplayCombatant createCopyWithLastingEffectReplaced(
    CombatLastingEffect replacedEffect, {
    required CombatLastingEffect replacement,
  }) {
    final replacedIndex = _indexOfLastingEffect(replacedEffect);
    if (replacedIndex == -1) return this;

    final replacedEffects = [...combatLastingEffects]..[replacedIndex] = replacement;
    return createCopyWith(combatLastingEffects: List.unmodifiable(replacedEffects));
  }

  @useResult
  CombatReplayCombatant createCopyWithoutLastingEffect(CombatLastingEffect endedEffect) {
    final endedIndex = _indexOfLastingEffect(endedEffect);
    if (endedIndex == -1) return this;

    final remainingEffects = [...combatLastingEffects]..removeAt(endedIndex);
    return createCopyWith(combatLastingEffects: List.unmodifiable(remainingEffects));
  }

  int _indexOfLastingEffect(CombatLastingEffect wantedEffect) {
    final identicalIndex = combatLastingEffects.indexWhere((effect) => identical(effect, wantedEffect));
    if (identicalIndex != -1) return identicalIndex;

    return combatLastingEffects.indexWhere((effect) {
      final isSameKind = effect.runtimeType == wantedEffect.runtimeType;
      final isSameSource = effect.sourceCombatantId == wantedEffect.sourceCombatantId;

      return isSameKind && isSameSource;
    });
  }

  @override
  String toString() => '${characterCopy.character.id.value}#$id';
}
