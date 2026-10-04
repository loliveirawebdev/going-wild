import 'dart:math';

import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/combat/battlefield.dart';
import 'package:going_wild/domain/models/combat/combat_rules.dart';
import 'package:going_wild/domain/models/combat/pending_combat_effect_application.dart';
import 'package:going_wild/domain/models/combatant/combatant.dart';
import 'package:meta/meta.dart';

class Combat {
  const Combat({
    required this.rules,
    required this.battlefield,
    required this.elapsedTicks,
    required this.randomGenerator,
    required this.pendingCombatEffectApplications,
  });

  final int elapsedTicks;
  final CombatRules rules;
  final Random randomGenerator;
  final Battlefield battlefield;
  final List<PendingCombatEffectApplication> pendingCombatEffectApplications;

  double get elapsedSeconds => elapsedTicks / rules.ticksPerSecond;

  @useResult
  Combat createCopyWith({
    Battlefield? battlefield,
    int? elapsedTicks,
    List<PendingCombatEffectApplication>? pendingCombatEffectApplications,
  }) => Combat(
    rules: rules,
    randomGenerator: randomGenerator,
    battlefield: battlefield ?? this.battlefield,
    elapsedTicks: elapsedTicks ?? this.elapsedTicks,
    pendingCombatEffectApplications: pendingCombatEffectApplications ?? this.pendingCombatEffectApplications,
  );

  @useResult
  Combat createCopyWithCombatant(Combatant updatedCombatant) {
    return createCopyWith(battlefield: battlefield.createCopyWithCombatant(updatedCombatant));
  }

  @useResult
  Combat createCopyWithCombatantMovedTo(int combatantId, Position position) {
    return createCopyWith(battlefield: battlefield.createCopyWithCombatantMovedTo(combatantId, position));
  }
}
