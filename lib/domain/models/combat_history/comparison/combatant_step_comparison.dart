import 'dart:math';

import 'package:going_wild/domain/models/combat_history/causes/combat_history_cause.dart';
import 'package:going_wild/domain/models/combat_history/combat_history_entry_detectors.dart';
import 'package:going_wild/domain/models/combat_history/combat_history_step.dart';
import 'package:going_wild/domain/models/combat_history/combat_history_step_kind.dart';
import 'package:going_wild/domain/models/combat_history/comparison/matched_combat_lasting_effects.dart';
import 'package:going_wild/domain/models/combat_history/entries/combat_history_entry.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/lasting/combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combatant.dart';

class CombatantStepComparison {
  CombatantStepComparison({required this.tick, required this.step, required this.after, required this.before});

  final int tick;
  final Combatant after;
  final Combatant before;
  final CombatHistoryStep step;

  late final CombatHistoryCause cause = step.cause;
  late final bool isActor = after.id == step.actorCombatantId;
  late final bool isOwnLastingEffectsStep = isActor && step.kind == CombatHistoryStepKind.advanceCombatLastingEffects;

  late final double manaDifference = after.currentMana - before.currentMana;
  late final double healthDifference = after.currentHealth - before.currentHealth;
  late final matchedEffects = MatchedCombatLastingEffects(after: after.combatLastingEffects, before: before.combatLastingEffects);
  late final double absorbedByShield = matchedEffects.absorbedByShield(isOwnLastingEffectsStep: isOwnLastingEffectsStep);
  late final double damageAmount = absorbedByShield + max(0.0, -healthDifference);

  late final int? healSourceCombatantId = isOwnLastingEffectsStep
      ? _uniqueSourceOfOwnEffects((effect) => effect.healsOwnerOnTick)
      : step.actorCombatantId;

  late final int? damageSourceCombatantId = isOwnLastingEffectsStep
      ? _uniqueSourceOfOwnEffects((effect) => effect.damagesOwnerOnTick)
      : step.actorCombatantId;

  bool get hasMoved => after.position != before.position;
  bool get hasDied => before.isAlive && !after.isAlive;
  int? get acquiredTargetCombatantId => after.targetCombatantId == before.targetCombatantId ? null : after.targetCombatantId;

  late final List<CombatConsequenceHistoryEntry> entries = [for (final detect in combatantEntryDetectors) ...detect(this)];

  bool get isAffectedByTheStep => entries.any((entry) => !(isActor && entry is ManaSpentHistoryEntry));

  int? _uniqueSourceOfOwnEffects(bool Function(CombatLastingEffect effect) isRelevant) {
    final sourceCombatantIds = before.combatLastingEffects.where(isRelevant).map((effect) => effect.sourceCombatantId).toSet();
    return sourceCombatantIds.length == 1 ? sourceCombatantIds.single : null;
  }
}
