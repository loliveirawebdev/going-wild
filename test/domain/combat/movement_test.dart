import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/domain/combat/board/faction.dart';
import 'package:going_wild/domain/combat/events/battle_event.dart';
import 'package:going_wild/domain/combat/systems/move_toward_target.dart';

import 'helpers.dart';

void main() {
  test('steps one cell toward the target, diagonals allowed', () {
    final me = unit(faction: Faction.team, at: at(7, 0));
    final foe = unit(faction: Faction.enemy, at: at(0, 4));
    final battle = battleWith([me, foe]);
    me.target = foe;

    moveTowardTarget(battle, me);

    expect(me.position, at(6, 1));
    expect(battle.events.whereType<CharacterMoved>().single.to, at(6, 1));
  });

  test('moves once per 1 / moveSpeed seconds', () {
    final me = unit(faction: Faction.team, at: at(7, 2), stats: statsOf(moveSpeed: 2));
    final foe = unit(faction: Faction.enemy, at: at(0, 2));
    final battle = battleWith([me, foe]);
    me.target = foe;

    for (var i = 0; i < 10; i++) {
      moveTowardTarget(
        battle,
        me,
      );
    }

    expect(me.position, at(5, 2));
  });

  test('stops as soon as the target is in range', () {
    final ranged = unit(faction: Faction.team, at: at(4, 2), stats: statsOf(range: 2));
    final foe = unit(faction: Faction.enemy, at: at(2, 2));
    final battle = battleWith([ranged, foe]);
    ranged.target = foe;

    moveTowardTarget(battle, ranged);

    expect(ranged.position, at(4, 2));
    expect(battle.events, isEmpty);
  });

  test('routes around occupied cells', () {
    final me = unit(faction: Faction.team, at: at(7, 2));
    final wallA = unit(faction: Faction.team, at: at(6, 1));
    final wallB = unit(faction: Faction.team, at: at(6, 2));
    final wallC = unit(faction: Faction.team, at: at(6, 3));
    final foe = unit(faction: Faction.enemy, at: at(0, 2));
    final battle = battleWith([me, wallA, wallB, wallC, foe]);
    me.target = foe;

    final step = findNextStepToward(battle, me, foe);

    expect(step, isNotNull);
    expect(battle.isPositionFree(step!), isTrue);
    expect(step.distanceToPosition(me.position), 1);
  });

  test('stays put when there is no path', () {
    final me = unit(faction: Faction.team, at: at(7, 0));
    final foe = unit(faction: Faction.enemy, at: at(0, 4));
    final blockers = [at(6, 0), at(6, 1), at(7, 1)].map((p) => unit(faction: Faction.team, at: p)).toList();
    final battle = battleWith([me, foe, ...blockers]);
    me.target = foe;

    moveTowardTarget(battle, me);

    expect(me.position, at(7, 0));
  });
}
