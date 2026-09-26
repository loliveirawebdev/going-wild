import 'package:meta/meta.dart';

import '../combatant/combat_effects/base/lasting/combat_lasting_effect.dart';
import '../combatant/combatant.dart';
import '../combatant/faction.dart';
import 'combat_history_step.dart';
import 'combat_history_step_kind.dart';
import 'entries/combat_history_entry.dart';

typedef _KeptCombatLastingEffect = ({CombatLastingEffect before, CombatLastingEffect after});

typedef _MatchedCombatLastingEffects = ({
  List<CombatLastingEffect> endedEffects,
  List<CombatLastingEffect> startedEffects,
  List<_KeptCombatLastingEffect> keptEffects,
});

class CombatHistory {
  CombatHistory({required List<CombatHistoryEntry> entries}) : this._(previousHistory: null, latestEntries: List.unmodifiable(entries));
  CombatHistory._({required this._latestEntries, required this._previousHistory});

  final CombatHistory? _previousHistory;
  final List<CombatHistoryEntry> _latestEntries;
  late final List<CombatHistoryEntry> entries = _collectEntries();

  @useResult
  CombatHistory createCopyWithCombatStarted({required int tick, required List<Combatant> combatants}) => _createCopyWithEntries([
    CombatStartedHistoryEntry(tick: tick),
    for (final combatant in combatants)
      for (final combatLastingEffect in combatant.combatLastingEffects)
        LastingEffectStartedHistoryEntry(
          tick: tick,
          combatantId: combatant.id,
          combatLastingEffect: combatLastingEffect,
        ),
  ]);

  @useResult
  CombatHistory createCopyWithCombatEnded({required int tick, required Faction? winningFaction}) {
    return _createCopyWithEntries([
      CombatEndedHistoryEntry(
        tick: tick,
        winningFaction: winningFaction,
      ),
    ]);
  }

  @useResult
  CombatHistory createCopyWithStepCompared({
    required int tick,
    required CombatHistoryStep step,
    required List<Combatant> combatantsAfter,
    required List<Combatant> combatantsBefore,
  }) {
    final actorEntries = <CombatHistoryEntry>[];
    final combatantEntries = <CombatHistoryEntry>[];
    final combatantsBeforeById = _hasSameOrder(combatantsBefore, combatantsAfter) ? null : _combatantsById(combatantsBefore);

    for (var index = 0; index < combatantsAfter.length; index++) {
      final combatantAfter = combatantsAfter[index];
      final combatantBefore = combatantsBeforeById == null ? combatantsBefore[index] : combatantsBeforeById[combatantAfter.id];
      if (combatantBefore == null || identical(combatantBefore, combatantAfter)) continue;

      if (combatantAfter.id == step.actorCombatantId) {
        actorEntries.addAll(_actorEntriesOf(step, tick: tick, actorAfter: combatantAfter, actorBefore: combatantBefore));
      }

      combatantEntries.addAll(_combatantEntriesOf(combatantBefore, combatantAfter, step: step, tick: tick));
    }

    final stepEntries = [...actorEntries, ...combatantEntries];
    return _createCopyWithEntries(stepEntries);
  }

  CombatHistory _createCopyWithEntries(List<CombatHistoryEntry> newEntries) {
    if (newEntries.isEmpty) return this;
    return CombatHistory._(previousHistory: this, latestEntries: List.unmodifiable(newEntries));
  }

  List<CombatHistoryEntry> _collectEntries() {
    final historiesFromNewest = <CombatHistory>[];

    for (CombatHistory? history = this; history != null; history = history._previousHistory) {
      historiesFromNewest.add(history);
    }

    return List.unmodifiable([for (final history in historiesFromNewest.reversed) ...history._latestEntries]);
  }
}

bool _hasSameOrder(List<Combatant> combatantsBefore, List<Combatant> combatantsAfter) {
  if (combatantsBefore.length != combatantsAfter.length) return false;

  for (var index = 0; index < combatantsAfter.length; index++) {
    if (combatantsBefore[index].id != combatantsAfter[index].id) return false;
  }

  return true;
}

Map<int, Combatant> _combatantsById(List<Combatant> combatants) => {for (final combatant in combatants) combatant.id: combatant};

List<CombatHistoryEntry> _actorEntriesOf(
  CombatHistoryStep step, {
  required int tick,
  required Combatant actorAfter,
  required Combatant actorBefore,
}) {
  switch (step.kind) {
    case CombatHistoryStepKind.castAbility:
      return [AbilityCastHistoryEntry(tick: tick, combatantId: actorBefore.id)];

    case CombatHistoryStepKind.attackTarget:
      final targetCombatantId = actorBefore.targetCombatantId;
      final ticksUntilNextAttackWhileWaiting = actorBefore.ticksUntilNextAttack - 1;
      final hasAttackTimerChanged = actorAfter.ticksUntilNextAttack != actorBefore.ticksUntilNextAttack;
      final hasAttackTimerRestarted = hasAttackTimerChanged && actorAfter.ticksUntilNextAttack != ticksUntilNextAttackWhileWaiting;
      if (!hasAttackTimerRestarted || targetCombatantId == null) return [];

      return [AttackLandedHistoryEntry(tick: tick, combatantId: actorBefore.id, targetCombatantId: targetCombatantId)];

    case CombatHistoryStepKind.acquireTarget:
    case CombatHistoryStepKind.moveTowardTarget:
    case CombatHistoryStepKind.applyPendingCombatEffects:
    case CombatHistoryStepKind.advanceCombatLastingEffects:
      return [];
  }
}

List<CombatHistoryEntry> _combatantEntriesOf(Combatant before, Combatant after, {required int tick, required CombatHistoryStep step}) {
  final combatantEntries = <CombatHistoryEntry>[];
  final isOwnLastingEffectsStep = step.kind == CombatHistoryStepKind.advanceCombatLastingEffects && step.actorCombatantId == before.id;
  final healSourceCombatantId = isOwnLastingEffectsStep
      ? _uniqueSourceOf(before, (effect) => effect.healsOwnerOnTick)
      : step.actorCombatantId;
  final damageSourceCombatantId = isOwnLastingEffectsStep
      ? _uniqueSourceOf(before, (effect) => effect.damagesOwnerOnTick)
      : step.actorCombatantId;

  final targetCombatantId = after.targetCombatantId;
  if (targetCombatantId != null && targetCombatantId != before.targetCombatantId) {
    combatantEntries.add(TargetAcquiredHistoryEntry(tick: tick, combatantId: after.id, targetCombatantId: targetCombatantId));
  }

  if (after.position != before.position) {
    combatantEntries.add(
      MovementHistoryEntry(
        tick: tick,
        combatantId: after.id,
        toPosition: after.position,
        fromPosition: before.position,
        sourceCombatantId: step.actorCombatantId,
      ),
    );
  }

  final matchedEffects = _matchCombatLastingEffects(before.combatLastingEffects, after.combatLastingEffects);
  final absorbedByShield = _absorbedByShield(matchedEffects, isOwnLastingEffectsStep: isOwnLastingEffectsStep);
  final healthDifference = after.currentHealth - before.currentHealth;
  final damageAmount = absorbedByShield + (healthDifference < 0 ? -healthDifference : 0);

  if (damageAmount > 0) {
    combatantEntries.add(
      DamageTakenHistoryEntry(
        tick: tick,
        amount: damageAmount,
        combatantId: after.id,
        currentHealth: after.currentHealth,
        absorbedByShield: absorbedByShield,
        sourceCombatantId: damageSourceCombatantId,
      ),
    );
  }

  if (healthDifference > 0) {
    combatantEntries.add(
      HealReceivedHistoryEntry(
        tick: tick,
        combatantId: after.id,
        amount: healthDifference,
        currentHealth: after.currentHealth,
        sourceCombatantId: healSourceCombatantId,
      ),
    );
  }

  final manaDifference = after.currentMana - before.currentMana;
  if (manaDifference > 0) {
    combatantEntries.add(
      ManaReceivedHistoryEntry(tick: tick, combatantId: after.id, amount: manaDifference, currentMana: after.currentMana),
    );
  }

  for (final endedEffect in matchedEffects.endedEffects) {
    combatantEntries.add(LastingEffectEndedHistoryEntry(tick: tick, combatantId: after.id, combatLastingEffect: endedEffect));
  }

  for (final startedEffect in matchedEffects.startedEffects) {
    combatantEntries.add(LastingEffectStartedHistoryEntry(tick: tick, combatantId: after.id, combatLastingEffect: startedEffect));
  }

  if (before.isAlive && !after.isAlive) {
    combatantEntries.add(DeathHistoryEntry(tick: tick, combatantId: after.id, killerCombatantId: damageSourceCombatantId));
  }

  return combatantEntries;
}

_MatchedCombatLastingEffects _matchCombatLastingEffects(List<CombatLastingEffect> effectsBefore, List<CombatLastingEffect> effectsAfter) {
  final keptAfterIndexes = <int>{};
  final endedEffects = <CombatLastingEffect>[];
  final keptEffects = <_KeptCombatLastingEffect>[];
  var searchStartIndex = 0;

  for (final effectBefore in effectsBefore) {
    final keptIndex = _indexOfSameEffect(effectsAfter, effectBefore, searchStartIndex);

    if (keptIndex == -1) {
      endedEffects.add(effectBefore);
      continue;
    }

    keptAfterIndexes.add(keptIndex);
    keptEffects.add((before: effectBefore, after: effectsAfter[keptIndex]));
    searchStartIndex = keptIndex + 1;
  }

  final startedEffects = [
    for (final (index, effectAfter) in effectsAfter.indexed)
      if (!keptAfterIndexes.contains(index)) effectAfter,
  ];

  return (endedEffects: endedEffects, keptEffects: keptEffects, startedEffects: startedEffects);
}

int _indexOfSameEffect(List<CombatLastingEffect> effects, CombatLastingEffect wantedEffect, int searchStartIndex) {
  for (var index = searchStartIndex; index < effects.length; index++) {
    final effect = effects[index];
    final isSameKind = effect.runtimeType == wantedEffect.runtimeType;
    final isSameSource = effect.sourceCombatantId == wantedEffect.sourceCombatantId;
    if (isSameKind && isSameSource) return index;
  }

  return -1;
}

double _absorbedByShield(_MatchedCombatLastingEffects matchedEffects, {required bool isOwnLastingEffectsStep}) {
  var absorbedByShield = 0.0;

  for (final keptEffect in matchedEffects.keptEffects) {
    final absorbedByKeptEffect = keptEffect.before.absorbableDamage - keptEffect.after.absorbableDamage;
    if (absorbedByKeptEffect > 0) absorbedByShield += absorbedByKeptEffect;
  }

  for (final endedEffect in matchedEffects.endedEffects) {
    final hasExpiredByTime = isOwnLastingEffectsStep && endedEffect.createCopyAfterOneTick() == null;
    if (!hasExpiredByTime) absorbedByShield += endedEffect.absorbableDamage;
  }

  return absorbedByShield;
}

int? _uniqueSourceOf(Combatant combatant, bool Function(CombatLastingEffect effect) isRelevant) {
  final sourceCombatantIds = combatant.combatLastingEffects.where(isRelevant).map((effect) => effect.sourceCombatantId).toSet();
  return sourceCombatantIds.length == 1 ? sourceCombatantIds.single : null;
}
