import 'dart:math';

import 'package:going_wild/domain/models/board/board.dart';
import 'package:going_wild/domain/models/board/placement.dart';
import 'package:going_wild/domain/models/character/engines/character_engine.dart';
import 'package:going_wild/domain/models/character/stats/stat.dart';
import 'package:going_wild/domain/models/combat/battlefield.dart';
import 'package:going_wild/domain/models/combat/combat.dart';
import 'package:going_wild/domain/models/combat/combat_in_progress.dart';
import 'package:going_wild/domain/models/combat/combat_result.dart';
import 'package:going_wild/domain/models/combat/combat_rules.dart';
import 'package:going_wild/domain/models/combat/combatant_actions/acquire_target.dart';
import 'package:going_wild/domain/models/combat/combatant_actions/advance_combat_lasting_effects_by_one_tick.dart';
import 'package:going_wild/domain/models/combat/combatant_actions/attack_target.dart';
import 'package:going_wild/domain/models/combat/combatant_actions/cast_ability_if_ready.dart';
import 'package:going_wild/domain/models/combat/combatant_actions/move_toward_target.dart';
import 'package:going_wild/domain/models/combat/engines/combat_engine.dart';
import 'package:going_wild/domain/models/combat_history/combat_history_step.dart';
import 'package:going_wild/domain/models/combat_history/combat_history_step_kind.dart';
import 'package:going_wild/domain/models/combatant/combatant.dart';
import 'package:going_wild/domain/models/combatant/faction.dart';
import 'package:going_wild/domain/models/set/engines/set_engine.dart';
import 'package:going_wild/domain/models/set/set_effect_side.dart';
import 'package:meta/meta.dart';

class BasicCombatEngine extends CombatEngine {
  const BasicCombatEngine({
    required this.board,
    required this.rules,
    required this.setEngine,
    required this.characterEngine,
  });

  @override
  final Board board;

  @override
  final CombatRules rules;

  final SetEngine setEngine;
  final CharacterEngine characterEngine;

  @override
  CombatResult simulate({
    required List<Placement> team,
    required bool recordsHistory,
    required Random randomGenerator,
    required List<Placement> enemies,
  }) {
    final combatants = _buildCombatants(team: team, enemies: enemies);
    final combatantIds = combatants.map((combatant) => combatant.id).toList();

    final startingCombat = Combat(
      rules: rules,
      elapsedTicks: 0,
      randomGenerator: randomGenerator,
      pendingCombatEffectApplications: const [],
      battlefield: Battlefield(board: board, combatants: combatants),
    );

    var combatInProgress = CombatInProgress.started(startingCombat, recordsHistory: recordsHistory);

    while (_isCombatOngoing(combatInProgress.combat)) {
      combatInProgress = _afterTick(
        combatInProgress,
        combatantIds,
      );
    }

    return combatInProgress.createCombatResult(winningFaction: _winningFactionOf(combatInProgress.combat));
  }

  List<Combatant> _buildCombatants({required List<Placement> team, required List<Placement> enemies}) {
    var nextCombatantId = 1;
    final teamActiveSets = setEngine.activeSets(team.map((placement) => placement.characterCopy.character).toList());

    Combatant buildCombatant(Placement placement, Faction faction, SetEffectSide side) {
      final combatantId = nextCombatantId++;
      final characterCopy = placement.characterCopy;
      final statsAtStars = characterEngine.statsAtStars(characterCopy.character, stars: characterCopy.stars);
      final stats = setEngine.statsWithSetEffects(characterCopy.character, statsAtStars, side: side, activeSets: teamActiveSets);

      final startingLastingEffects = setEngine.startingLastingEffectsFor(
        characterCopy.character,
        stats,
        side: side,
        activeSets: teamActiveSets,
        ownerCombatantId: combatantId,
        convertSecondsToTicks: rules.convertSecondsToTicks,
      );

      return Combatant(
        stats: stats,
        id: combatantId,
        faction: faction,
        ticksUntilNextStep: 0,
        targetCombatantId: null,
        ticksUntilNextAttack: 0,
        abilityCastCount: 0,
        position: placement.position,
        characterCopy: characterCopy,
        currentHealth: stats[Stat.health],
        currentMana: stats[Stat.manaStart],
        combatLastingEffects: startingLastingEffects,
      );
    }

    return [
      ...team.map((placement) => buildCombatant(placement, Faction.team, SetEffectSide.ownTeam)),
      ...enemies.map((placement) => buildCombatant(placement, Faction.enemy, SetEffectSide.opposingTeam)),
    ];
  }
}

bool _hasAliveCombatantsFrom(Combat combat, Faction faction) => combat.battlefield.aliveCombatantsFromFaction(faction).isNotEmpty;

bool _isCombatOngoing(Combat combat) {
  final isCombatTimeout = combat.elapsedSeconds >= combat.rules.maxSeconds;
  final hasBothSidesAlive = _hasAliveCombatantsFrom(combat, Faction.team) && _hasAliveCombatantsFrom(combat, Faction.enemy);

  return hasBothSidesAlive && !isCombatTimeout;
}

Faction? _winningFactionOf(Combat combat) {
  final hasTeamAlive = _hasAliveCombatantsFrom(combat, Faction.team);
  final hasEnemyAlive = _hasAliveCombatantsFrom(combat, Faction.enemy);
  if (hasTeamAlive == hasEnemyAlive) return null;

  return hasTeamAlive ? Faction.team : Faction.enemy;
}

@useResult
CombatInProgress _afterTick(CombatInProgress combatInProgress, List<int> combatantIds) {
  final afterLastingEffects = combatantIds.fold(combatInProgress, _afterLastingEffectsOf).createCopyAfterPendingEffects();
  final afterTurns = combatantIds.fold(afterLastingEffects, _afterTurnOf);

  return afterTurns.createCopyWithNextTick();
}

@useResult
CombatInProgress _afterLastingEffectsOf(CombatInProgress combatInProgress, int combatantId) {
  if (!combatInProgress.combatantWithId(combatantId).isAlive) return combatInProgress;

  return combatInProgress.createCopyAfterStep(
    action: (combat) => advanceCombatLastingEffectsByOneTick(combat, combatantId),
    step: CombatHistoryStep(actorCombatantId: combatantId, kind: CombatHistoryStepKind.advanceCombatLastingEffects),
  );
}

@useResult
CombatInProgress _afterTurnOf(CombatInProgress combatInProgress, int combatantId) {
  if (!combatInProgress.combatantWithId(combatantId).canAct) return combatInProgress;

  CombatHistoryStep stepOf(CombatHistoryStepKind kind) => CombatHistoryStep(kind: kind, actorCombatantId: combatantId);

  final afterCast = combatInProgress
      .createCopyAfterStep(
        step: stepOf(CombatHistoryStepKind.acquireTarget),
        action: (combat) => acquireTarget(combat, combatantId),
      )
      .createCopyAfterStep(
        step: stepOf(CombatHistoryStepKind.castAbility),
        action: (combat) => castAbilityIfReady(combat, combatantId),
      )
      .createCopyAfterPendingEffects();

  if (!afterCast.combatantWithId(combatantId).canAct) return afterCast;

  return afterCast
      .createCopyAfterStep(
        step: stepOf(CombatHistoryStepKind.attackTarget),
        action: (combat) => attackTarget(combat, combatantId),
      )
      .createCopyAfterStep(
        step: stepOf(CombatHistoryStepKind.moveTowardTarget),
        action: (combat) => moveTowardTarget(combat, combatantId),
      );
}
