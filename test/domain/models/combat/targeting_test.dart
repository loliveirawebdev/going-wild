import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/domain/models/combat/combatant_actions/acquire_target.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/taunt/taunt_combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/faction.dart';

import '../../../helpers/combat_helpers.dart';

void main() {
  test('picks the nearest enemy', () {
    final attacker = combatant(at: at(7, 2), faction: Faction.team);
    final nearEnemy = combatant(at: at(5, 2), faction: Faction.enemy);
    final farEnemy = combatant(at: at(0, 2), faction: Faction.enemy);

    final targetedCombat = acquireTarget(combatWith([attacker, nearEnemy, farEnemy]), attacker.id);

    expect(findCombatant(targetedCombat, attacker).targetCombatantId, nearEnemy.id);
  });

  test('breaks distance ties by lowest health', () {
    final attacker = combatant(at: at(7, 2), faction: Faction.team);
    final healthyEnemy = combatant(at: at(5, 1), faction: Faction.enemy);
    final hurtEnemy = combatant(at: at(5, 3), faction: Faction.enemy).createCopyWith(currentHealth: 10);

    final targetedCombat = acquireTarget(combatWith([attacker, healthyEnemy, hurtEnemy]), attacker.id);

    expect(findCombatant(targetedCombat, attacker).targetCombatantId, hurtEnemy.id);
  });

  test('breaks distance and health ties by lowest id', () {
    final attacker = combatant(at: at(7, 2), faction: Faction.team);
    final firstEnemy = combatant(at: at(5, 3), faction: Faction.enemy);
    final secondEnemy = combatant(at: at(5, 1), faction: Faction.enemy);

    final targetedCombat = acquireTarget(combatWith([attacker, secondEnemy, firstEnemy]), attacker.id);

    expect(findCombatant(targetedCombat, attacker).targetCombatantId, firstEnemy.id);
  });

  test('ignores allies', () {
    final attacker = combatant(at: at(7, 2), faction: Faction.team);
    final ally = combatant(at: at(7, 3), faction: Faction.team);
    final enemy = combatant(at: at(0, 0), faction: Faction.enemy);

    final targetedCombat = acquireTarget(combatWith([attacker, ally, enemy]), attacker.id);

    expect(findCombatant(targetedCombat, attacker).targetCombatantId, enemy.id);
  });

  test('keeps the target while it lives even if another gets closer', () {
    final attacker = combatant(at: at(7, 2), faction: Faction.team);
    final firstEnemy = combatant(at: at(4, 2), faction: Faction.enemy);
    final approachingEnemy = combatant(at: at(0, 2), faction: Faction.enemy);
    final targetedCombat = acquireTarget(combatWith([attacker, firstEnemy, approachingEnemy]), attacker.id);
    final approachedCombat = targetedCombat.createCopyWithCombatantMovedTo(approachingEnemy.id, at(6, 2));

    final retargetedCombat = acquireTarget(approachedCombat, attacker.id);

    expect(findCombatant(retargetedCombat, attacker).targetCombatantId, firstEnemy.id);
  });

  test('retargets when the target dies', () {
    final attacker = combatant(at: at(7, 2), faction: Faction.team);
    final firstEnemy = combatant(at: at(4, 2), faction: Faction.enemy);
    final otherEnemy = combatant(at: at(0, 2), faction: Faction.enemy);
    final targetedCombat = acquireTarget(combatWith([attacker, firstEnemy, otherEnemy]), attacker.id);
    final combatWithDeadTarget = targetedCombat.createCopyWithCombatant(firstEnemy.createCopyWith(currentHealth: 0));

    final retargetedCombat = acquireTarget(combatWithDeadTarget, attacker.id);

    expect(findCombatant(retargetedCombat, attacker).targetCombatantId, otherEnemy.id);
  });

  test('taunt forces the target onto the taunter', () {
    final taunter = combatant(at: at(0, 0), faction: Faction.enemy);
    final nearEnemy = combatant(at: at(6, 2), faction: Faction.enemy);
    final tauntedAttacker = withCombatLastingEffects(combatant(at: at(7, 2), faction: Faction.team), [
      TauntCombatLastingEffect(remainingTicks: 20, sourceCombatantId: taunter.id),
    ]);

    final targetedCombat = acquireTarget(combatWith([tauntedAttacker, nearEnemy, taunter]), tauntedAttacker.id);

    expect(findCombatant(targetedCombat, tauntedAttacker).targetCombatantId, taunter.id);
  });

  test('taunt from a dead taunter is ignored', () {
    final deadTaunter = combatant(at: at(0, 0), faction: Faction.enemy).createCopyWith(currentHealth: 0);
    final nearEnemy = combatant(at: at(6, 2), faction: Faction.enemy);
    final tauntedAttacker = withCombatLastingEffects(combatant(at: at(7, 2), faction: Faction.team), [
      TauntCombatLastingEffect(remainingTicks: 20, sourceCombatantId: deadTaunter.id),
    ]);

    final targetedCombat = acquireTarget(combatWith([tauntedAttacker, nearEnemy, deadTaunter]), tauntedAttacker.id);

    expect(findCombatant(targetedCombat, tauntedAttacker).targetCombatantId, nearEnemy.id);
  });

  test('no enemies left means no target', () {
    final attacker = combatant(at: at(7, 2), faction: Faction.team);

    final targetedCombat = acquireTarget(combatWith([attacker]), attacker.id);

    expect(findCombatant(targetedCombat, attacker).targetCombatantId, isNull);
  });
}
