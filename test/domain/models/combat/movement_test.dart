import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/domain/models/combat/combatant_actions/move_toward_target.dart';
import 'package:going_wild/domain/models/combatant/faction.dart';

import '../../../helpers/combat_helpers.dart';

void main() {
  test('steps to the neighbor cell that gets straightest toward the target', () {
    final enemy = combatant(at: at(0, 4), faction: Faction.enemy);
    final walker = combatant(at: at(7, 0), faction: Faction.team).createCopyWith(targetCombatantId: enemy.id);

    final movedCombat = moveTowardTarget(combatWith([walker, enemy]), walker.id);

    expect(findCombatant(movedCombat, walker).position, at(6, 0));
  });

  test('moves once per 1 / moveSpeed seconds', () {
    final enemy = combatant(at: at(0, 2), faction: Faction.enemy);
    final walker = combatant(
      at: at(7, 2),
      faction: Faction.team,
      stats: statsOf(moveSpeed: 2),
    ).createCopyWith(targetCombatantId: enemy.id);
    var combat = combatWith([walker, enemy]);

    for (var tick = 0; tick < testRules.ticksPerSecond; tick++) {
      combat = moveTowardTarget(combat, walker.id);
    }

    expect(findCombatant(combat, walker).position, at(5, 2));
  });

  test('a whole number of seconds between steps becomes an exact number of ticks', () {
    final enemy = combatant(at: at(0, 2), faction: Faction.enemy);
    final walker = combatant(
      at: at(7, 2),
      faction: Faction.team,
      stats: statsOf(moveSpeed: 1),
    ).createCopyWith(targetCombatantId: enemy.id);
    var combat = combatWith([walker, enemy]);

    for (var tick = 0; tick <= 2 * testRules.ticksPerSecond; tick++) {
      combat = moveTowardTarget(combat, walker.id);
    }

    expect(findCombatant(combat, walker).position, at(4, 2));
  });

  test('stops as soon as the target is in range', () {
    final enemy = combatant(at: at(2, 2), faction: Faction.enemy);
    final rangedWalker = combatant(
      at: at(4, 2),
      faction: Faction.team,
      stats: statsOf(range: 2),
    ).createCopyWith(targetCombatantId: enemy.id);
    final combat = combatWith([rangedWalker, enemy]);

    final movedCombat = moveTowardTarget(combat, rangedWalker.id);

    expect(movedCombat, same(combat));
  });

  test('routes around occupied cells', () {
    final enemy = combatant(at: at(0, 2), faction: Faction.enemy);
    final walker = combatant(at: at(7, 2), faction: Faction.team).createCopyWith(targetCombatantId: enemy.id);
    final walls = [at(6, 1), at(6, 2), at(6, 3)].map((position) => combatant(at: position, faction: Faction.team));
    final combat = combatWith([walker, ...walls, enemy]);

    final nextStepPosition = findNextStepToward(combat, walker, enemy);

    expect(nextStepPosition, isNotNull);
    expect(combat.battlefield.isPositionFree(nextStepPosition!), isTrue);
    expect(nextStepPosition.distanceToPosition(walker.position), 1);
  });

  test('stays put when there is no path', () {
    final enemy = combatant(at: at(0, 4), faction: Faction.enemy);
    final walker = combatant(at: at(7, 0), faction: Faction.team).createCopyWith(targetCombatantId: enemy.id);
    final blockers = [at(6, 0), at(6, 1), at(7, 1)].map((position) => combatant(at: position, faction: Faction.team));

    final movedCombat = moveTowardTarget(combatWith([walker, enemy, ...blockers]), walker.id);

    expect(findCombatant(movedCombat, walker).position, at(7, 0));
  });

  test('dead combatants do not block the path', () {
    final enemy = combatant(at: at(0, 0), faction: Faction.enemy);
    final walker = combatant(at: at(7, 0), faction: Faction.team).createCopyWith(targetCombatantId: enemy.id);
    final deadAlly = combatant(at: at(6, 0), faction: Faction.team).createCopyWith(currentHealth: 0);

    final movedCombat = moveTowardTarget(combatWith([walker, deadAlly, enemy]), walker.id);

    expect(findCombatant(movedCombat, walker).position, at(6, 0));
  });
}
