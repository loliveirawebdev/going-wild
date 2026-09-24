import 'dart:math';

import '../../models/combat/battle.dart';
import '../../models/combat/battle_result.dart';
import '../../models/combat/battle_rules.dart';
import '../../models/combat/board/board.dart';
import '../../models/combat/board/faction.dart';
import '../../models/combat/board/placement.dart';
import '../../models/combat/events/battle_event.dart';
import '../../models/combat/systems/acquire_target.dart';
import '../../models/combat/systems/advance_statuses_by_one_tick.dart';
import '../../models/combat/systems/apply_ability_effects.dart';
import '../../models/combat/systems/attack_target.dart';
import '../../models/combat/systems/cast_ability_if_ready.dart';
import '../../models/combat/systems/move_toward_target.dart';
import '../../models/combat/unit/unit.dart';
import '../../models/models.dart';
import '../character/resolve_unit_stats.dart';
import '../set/active_set_tiers.dart';

BattleResult runBattle({
  required Board board,
  required Stats baseStats,
  required BattleRules rules,
  required List<TeamSet> sets,
  required List<Placement> team,
  required Random randomGenerator,
  required List<Placement> enemies,
  required MergeCurve Function(Role) mergeCurveFor,
}) {
  final battle = Battle(
    board: board,
    rules: rules,
    randomGenerator: randomGenerator,
    units: _buildUnits(team: team, enemies: enemies, sets: sets, baseStats: baseStats, mergeCurveFor: mergeCurveFor),
  );

  battle.recordEvent(const BattleStarted(time: 0));
  bool isBattleTimeout() => battle.elapsedSeconds >= rules.maxSeconds;
  bool hasTeamMemberAlive() => battle.aliveUnitsFromFaction(Faction.team).isNotEmpty;
  bool hasEnemyMemberAlive() => battle.aliveUnitsFromFaction(Faction.enemy).isNotEmpty;

  while (hasTeamMemberAlive() && hasEnemyMemberAlive() && !isBattleTimeout()) {
    for (final unit in battle.units.where((u) => u.isAlive)) {
      advanceStatusesByOneTick(
        battle,
        unit,
      );
    }

    _applyDeferredEffects(battle);

    for (final unit in battle.units.where((u) => u.canAct)) {
      acquireTarget(battle, unit);
      castAbilityIfReady(battle, unit);
      _applyDeferredEffects(battle);

      if (!unit.canAct) continue;

      attackTarget(battle, unit);
      moveTowardTarget(battle, unit);
    }

    battle.elapsedSeconds = double.parse((battle.elapsedSeconds + rules.tickSeconds).toStringAsFixed(4));
  }

  final teamAlive = battle.aliveUnitsFromFaction(Faction.team).isNotEmpty;
  final enemyAlive = battle.aliveUnitsFromFaction(Faction.enemy).isNotEmpty;
  final winner = teamAlive == enemyAlive ? null : (teamAlive ? Faction.team : Faction.enemy);
  battle.recordEvent(BattleEnded(time: battle.elapsedSeconds, winner: winner));

  return BattleResult(
    events: battle.events,
    winningFaction: winner,
    elapsedSeconds: battle.elapsedSeconds,
    survivingUnits: battle.units.where((u) => u.isAlive).toList(),
  );
}

List<Unit> _buildUnits({
  required Stats baseStats,
  required List<TeamSet> sets,
  required List<Placement> team,
  required List<Placement> enemies,
  required MergeCurve Function(Role) mergeCurveFor,
}) {
  var nextId = 1;
  final teamActiveSets = activeSetTiers(activeCharacters: team.map((placement) => placement.character).toList(), availableSets: sets);

  Unit buildUnit(Placement placement, Faction faction, List<ActiveSet> activeSets) => Unit(
    id: nextId++,
    faction: faction,
    stars: placement.stars,
    position: placement.position,
    character: placement.character,

    stats: resolveUnitStats(
      base: baseStats,
      stars: placement.stars,
      activeSets: activeSets,
      character: placement.character,
      curve: mergeCurveFor(placement.character.role),
    ),
  );

  return [
    ...team.map((placement) => buildUnit(placement, Faction.team, teamActiveSets)),
    ...enemies.map((placement) => buildUnit(placement, Faction.enemy, const [])),
  ];
}

void _applyDeferredEffects(Battle battle) {
  while (battle.deferredEffects.isNotEmpty) {
    final deferred = battle.deferredEffects.removeAt(0);
    if (deferred.effects.isEmpty) continue;
    applyAbilityEffects(battle, casterUnit: deferred.casterUnit, effects: deferred.effects);
  }
}
