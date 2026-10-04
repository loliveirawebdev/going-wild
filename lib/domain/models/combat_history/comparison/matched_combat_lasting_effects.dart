import 'dart:math';

import 'package:going_wild/domain/models/combatant/combat_effects/base/lasting/combat_lasting_effect.dart';

typedef KeptCombatLastingEffect = ({CombatLastingEffect before, CombatLastingEffect after});

class MatchedCombatLastingEffects {
  factory MatchedCombatLastingEffects({required List<CombatLastingEffect> after, required List<CombatLastingEffect> before}) {
    if (identical(before, after))
      return const MatchedCombatLastingEffects._(keptEffects: [], endedEffects: [], changedEffects: [], startedEffects: []);

    final keptAfterIndexes = <int>{};
    final endedEffects = <CombatLastingEffect>[];
    final keptEffects = <KeptCombatLastingEffect>[];
    var searchStartIndex = 0;

    for (final effectBefore in before) {
      final keptIndex = _indexOfSameEffect(after, effectBefore, searchStartIndex);

      if (keptIndex == -1) {
        endedEffects.add(effectBefore);
        continue;
      }

      keptAfterIndexes.add(keptIndex);
      keptEffects.add((before: effectBefore, after: after[keptIndex]));
      searchStartIndex = keptIndex + 1;
    }

    final startedEffects = <CombatLastingEffect>[];
    for (var index = 0; index < after.length; index++) {
      if (!keptAfterIndexes.contains(index)) startedEffects.add(after[index]);
    }

    final changedEffects = [
      for (final keptEffect in keptEffects)
        if (!identical(keptEffect.before, keptEffect.after)) keptEffect,
    ];

    return MatchedCombatLastingEffects._(
      keptEffects: keptEffects,
      endedEffects: endedEffects,
      changedEffects: changedEffects,
      startedEffects: startedEffects,
    );
  }

  const MatchedCombatLastingEffects._({
    required this.keptEffects,
    required this.endedEffects,
    required this.changedEffects,
    required this.startedEffects,
  });

  final List<CombatLastingEffect> endedEffects;
  final List<CombatLastingEffect> startedEffects;
  final List<KeptCombatLastingEffect> keptEffects;
  final List<KeptCombatLastingEffect> changedEffects;

  double absorbedByShield({required bool isOwnLastingEffectsStep}) {
    bool hasBrokenBeforeExpiring(CombatLastingEffect endedEffect) =>
        !isOwnLastingEffectsStep || endedEffect.createCopyAfterOneTick() != null;

    final absorbedByKeptEffects = keptEffects.fold(
      0.0,
      (sum, keptEffect) => sum + max(0.0, keptEffect.before.absorbableDamage - keptEffect.after.absorbableDamage),
    );

    final absorbedByBrokenEffects = endedEffects
        .where(hasBrokenBeforeExpiring)
        .fold(0.0, (sum, brokenEffect) => sum + brokenEffect.absorbableDamage);

    return absorbedByKeptEffects + absorbedByBrokenEffects;
  }
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
