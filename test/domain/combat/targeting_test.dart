import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/domain/combat/board/faction.dart';
import 'package:going_wild/domain/combat/events/battle_event.dart';
import 'package:going_wild/domain/combat/systems/acquire_target.dart';
import 'package:going_wild/domain/combat/unit/status_effect/status_effect.dart';

import 'helpers.dart';

void main() {
  test('picks the nearest enemy', () {
    final me = unit(faction: Faction.team, at: at(7, 2));
    final near = unit(faction: Faction.enemy, at: at(5, 2));
    final far = unit(faction: Faction.enemy, at: at(0, 2));
    final battle = battleWith([me, near, far]);

    acquireTarget(battle, me);

    expect(me.target, near);
    expect(battle.events.whereType<CharacterNewTargetAcquired>().single.targetUnitId, near.id);
  });

  test('breaks distance ties by lowest health', () {
    final me = unit(faction: Faction.team, at: at(7, 2));
    final healthy = unit(faction: Faction.enemy, at: at(5, 1));
    final hurt = unit(faction: Faction.enemy, at: at(5, 3))..currentHealth = 10;
    final battle = battleWith([me, healthy, hurt]);

    acquireTarget(battle, me);

    expect(me.target, hurt);
  });

  test('ignores allies', () {
    final me = unit(faction: Faction.team, at: at(7, 2));
    final ally = unit(faction: Faction.team, at: at(7, 3));
    final enemy = unit(faction: Faction.enemy, at: at(0, 0));
    acquireTarget(battleWith([me, ally, enemy]), me);

    expect(me.target, enemy);
  });

  test('keeps the target while it lives even if another gets closer', () {
    final me = unit(faction: Faction.team, at: at(7, 2));
    final first = unit(faction: Faction.enemy, at: at(4, 2));
    final closer = unit(faction: Faction.enemy, at: at(0, 2));
    final battle = battleWith([me, first, closer]);
    acquireTarget(battle, me);
    closer.position = at(6, 2);

    acquireTarget(battle, me);

    expect(me.target, first);
  });

  test('retargets when the target dies', () {
    final me = unit(faction: Faction.team, at: at(7, 2));
    final first = unit(faction: Faction.enemy, at: at(4, 2));
    final other = unit(faction: Faction.enemy, at: at(0, 2));
    final battle = battleWith([me, first, other]);
    acquireTarget(battle, me);
    first.currentHealth = 0;

    acquireTarget(battle, me);

    expect(me.target, other);
  });

  test('taunt forces the target onto the taunter', () {
    final me = unit(faction: Faction.team, at: at(7, 2));
    final near = unit(faction: Faction.enemy, at: at(6, 2));
    final taunter = unit(faction: Faction.enemy, at: at(0, 0));
    final battle = battleWith([me, near, taunter]);
    me.statusEffects.add(TauntStatusEffect(sourceUnit: taunter, remainingSeconds: 2));

    acquireTarget(battle, me);

    expect(me.target, taunter);
  });

  test('no enemies left means no target', () {
    final me = unit(faction: Faction.team, at: at(7, 2));
    acquireTarget(battleWith([me]), me);
    expect(me.target, isNull);
  });
}
