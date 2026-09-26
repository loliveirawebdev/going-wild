import 'dart:math';

import 'package:meta/meta.dart';

import '../../board/board.dart';
import '../../board/placement.dart';
import '../../character/engines/character_engine.dart';
import '../../character/stats/stat.dart';
import '../../combat_history/combat_history.dart';
import '../../combat_history/combat_history_step.dart';
import '../../combat_history/combat_history_step_kind.dart';
import '../../combatant/combatant.dart';
import '../../combatant/faction.dart';
import '../../set/engines/set_engine.dart';
import '../../set/set_effect_side.dart';
import '../battlefield.dart';
import '../combat.dart';
import '../combat_result.dart';
import '../combat_rules.dart';
import '../combatant_actions/acquire_target.dart';
import '../combatant_actions/advance_combat_lasting_effects_by_one_tick.dart';
import '../combatant_actions/apply_combat_effects.dart';
import '../combatant_actions/attack_target.dart';
import '../combatant_actions/cast_ability_if_ready.dart';
import '../combatant_actions/move_toward_target.dart';
import 'combat_engine.dart';

class BasicCombatEngine extends CombatEngine {
  const BasicCombatEngine({
    required this.board,
    required this.rules,
    required this.setEngine,
    required this.characterEngine,
  });

  @override
  final Board board;

  final CombatRules rules;
  final SetEngine setEngine;
  final CharacterEngine characterEngine;

  @override
  CombatResult simulate({required List<Placement> team, required Random randomGenerator, required List<Placement> enemies}) {
    final combatants = _buildCombatants(team: team, enemies: enemies);
    final combatantIds = combatants.map((combatant) => combatant.id).toList();

    var combat = Combat(
      rules: rules,
      elapsedTicks: 0,
      randomGenerator: randomGenerator,
      pendingCombatEffectApplications: const [],
      battlefield: Battlefield(board: board, combatants: combatants),
    );

    var history = CombatHistory(entries: const []).createCopyWithCombatStarted(combatants: combatants, tick: combat.elapsedTicks);

    while (_isCombatOngoing(combat)) {
      final advancedTick = _advanceOneTick((combat: combat, history: history), combatantIds);
      combat = advancedTick.combat;
      history = advancedTick.history;
    }

    final winningFaction = _winningFactionOf(combat);

    return CombatResult(
      winningFaction: winningFaction,
      elapsedSeconds: combat.elapsedSeconds,
      combatants: combat.battlefield.combatants,
      history: history.createCopyWithCombatEnded(tick: combat.elapsedTicks, winningFaction: winningFaction),
    );
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
        lowHealthAbilityUsed: false,
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

typedef _CombatWithHistory = ({Combat combat, CombatHistory history});

@useResult
_CombatWithHistory _runStep(_CombatWithHistory current, CombatHistoryStep step, Combat Function(Combat combat) action) {
  final combatAfterStep = action(current.combat);

  final historyAfterStep = current.history.createCopyWithStepCompared(
    step: step,
    tick: current.combat.elapsedTicks,
    combatantsAfter: combatAfterStep.battlefield.combatants,
    combatantsBefore: current.combat.battlefield.combatants,
  );

  return (combat: combatAfterStep, history: historyAfterStep);
}

@useResult
_CombatWithHistory _advanceOneTick(_CombatWithHistory current, List<int> combatantIds) {
  var ticked = current;

  for (final combatantId in combatantIds) {
    final isCombatantAlive = ticked.combat.battlefield.combatantWithId(combatantId).isAlive;
    if (!isCombatantAlive) continue;

    final step = CombatHistoryStep(actorCombatantId: combatantId, kind: CombatHistoryStepKind.advanceCombatLastingEffects);
    ticked = _runStep(ticked, step, (combat) => advanceCombatLastingEffectsByOneTick(combat, combatantId));
  }

  ticked = _applyPendingCombatEffectApplications(ticked);

  for (final combatantId in combatantIds) {
    ticked = _playCombatantTurn(ticked, combatantId);
  }

  final tickedCombat = ticked.combat;
  return (combat: tickedCombat.createCopyWith(elapsedTicks: tickedCombat.elapsedTicks + 1), history: ticked.history);
}

@useResult
_CombatWithHistory _playCombatantTurn(_CombatWithHistory current, int combatantId) {
  if (!current.combat.battlefield.combatantWithId(combatantId).canAct) return current;

  CombatHistoryStep stepOf(CombatHistoryStepKind kind) => CombatHistoryStep(kind: kind, actorCombatantId: combatantId);

  var turn = _runStep(current, stepOf(CombatHistoryStepKind.acquireTarget), (combat) => acquireTarget(combat, combatantId));
  turn = _runStep(turn, stepOf(CombatHistoryStepKind.castAbility), (combat) => castAbilityIfReady(combat, combatantId));
  turn = _applyPendingCombatEffectApplications(turn);
  if (!turn.combat.battlefield.combatantWithId(combatantId).canAct) return turn;

  turn = _runStep(turn, stepOf(CombatHistoryStepKind.attackTarget), (combat) => attackTarget(combat, combatantId));
  return _runStep(turn, stepOf(CombatHistoryStepKind.moveTowardTarget), (combat) => moveTowardTarget(combat, combatantId));
}

@useResult
_CombatWithHistory _applyPendingCombatEffectApplications(_CombatWithHistory current) {
  var applied = current;

  while (applied.combat.pendingCombatEffectApplications.isNotEmpty) {
    final pendingApplications = applied.combat.pendingCombatEffectApplications;
    final nextPendingApplication = pendingApplications.first;
    final combatWithoutNextPending = applied.combat.createCopyWith(pendingCombatEffectApplications: pendingApplications.skip(1).toList());
    applied = (combat: combatWithoutNextPending, history: applied.history);
    if (nextPendingApplication.effects.isEmpty) continue;

    final sourceCombatantId = nextPendingApplication.sourceCombatantId;
    final step = CombatHistoryStep(actorCombatantId: sourceCombatantId, kind: CombatHistoryStepKind.applyPendingCombatEffects);

    applied = _runStep(
      applied,
      step,
      (combat) => applyCombatEffects(combat, sourceCombatantId: sourceCombatantId, effects: nextPendingApplication.effects),
    );
  }

  return applied;
}
