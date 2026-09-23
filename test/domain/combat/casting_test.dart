import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/domain/combat/board/faction.dart';
import 'package:going_wild/domain/combat/events/battle_event.dart';
import 'package:going_wild/domain/combat/systems/cast_ability_if_ready.dart';
import 'package:going_wild/domain/combat/unit/status_effect/status_effect.dart';
import 'package:going_wild/domain/combat/unit/unit.dart';
import 'package:going_wild/domain/models/models.dart';

import 'helpers.dart';

StarValues v(double x) {
  return StarValues(
    star1: x,
    star2: x,
    star3: x,
  );
}

Ability ability(List<AbilityEffect> effects, {AbilityTrigger trigger = AbilityTrigger.manaFull}) {
  return Ability(
    id: 'test',
    trigger: trigger,
    effects: effects,
  );
}

void main() {
  test('casts when mana is full and resets mana to zero', () {
    final me = unit(
      faction: Faction.team,
      at: at(1, 0),
      stats: statsOf(manaMax: 50, manaStart: 50),
      character: dummy(
        ability: ability([
          DamageEffect(
            value: v(300),
            target: EffectTarget.focus,
          ),
        ]),
      ),
    );

    final foe = unit(faction: Faction.enemy, at: at(0, 0));
    final battle = battleWith([me, foe]);
    me.target = foe;

    castAbilityIfReady(battle, me);

    expect(me.currentMana, 0);
    expect(battle.events.whereType<CharacterAbilityCast>().single.abilityId, 'test');
    expect(foe.currentHealth, 700);
  });

  test('does not cast below full mana', () {
    final me = unit(
      faction: Faction.team,
      at: at(1, 0),
      stats: statsOf(manaMax: 50, manaStart: 49),
      character: dummy(
        ability: ability([
          DamageEffect(
            target: EffectTarget.focus,
            value: v(300),
          ),
        ]),
      ),
    );

    final battle = battleWith([me]);
    castAbilityIfReady(battle, me);
    expect(battle.events, isEmpty);
  });

  test('low health trigger fires once, at or below the threshold', () {
    final me = unit(
      faction: Faction.team,
      at: at(1, 0),
      stats: statsOf(health: 100),
      character: dummy(
        ability: ability([
          StatBuffEffect(
            target: EffectTarget.self,
            stat: Stat.armor,
            changeType: StatChangeType.absoluteValue,
            value: v(50),
            seconds: v(3),
          ),
        ], trigger: AbilityTrigger.lowHealth),
      ),
    );

    final battle = battleWith([me]);

    me.currentHealth = 31;
    castAbilityIfReady(battle, me);
    expect(battle.events.whereType<CharacterAbilityCast>(), isEmpty);

    me.currentHealth = 30;
    castAbilityIfReady(battle, me);
    castAbilityIfReady(battle, me);
    expect(battle.events.whereType<CharacterAbilityCast>().length, 1);
  });

  test('taunt makes targets attack the caster', () {
    final me = unit(
      faction: Faction.team,
      at: at(4, 2),
      character: dummy(
        ability: ability([
          TauntEffect(
            target: EffectTarget.allEnemies,
            seconds: v(2),
          ),
        ]),
      ),
      stats: statsOf(manaStart: 50),
    );

    final a = unit(faction: Faction.enemy, at: at(0, 0));
    final b = unit(faction: Faction.enemy, at: at(0, 4));
    final battle = battleWith([me, a, b]);

    castAbilityIfReady(battle, me);

    expect(a.target, me);
    expect(b.target, me);
    expect(a.statusEffects.whereType<TauntStatusEffect>().single.sourceUnit, me);
  });

  test('stun extends to the longer duration instead of stacking', () {
    final me = unit(
      faction: Faction.team,
      at: at(1, 0),
      stats: statsOf(manaStart: 50),
      character: dummy(
        ability: ability([
          StunEffect(
            target: EffectTarget.focus,
            seconds: v(1),
          ),
        ]),
      ),
    );

    final foe = unit(faction: Faction.enemy, at: at(0, 0));
    final battle = battleWith([me, foe]);
    me.target = foe;
    foe.statusEffects.add(StunStatusEffect(sourceUnit: me, remainingSeconds: 3));

    castAbilityIfReady(battle, me);

    expect(foe.statusEffects.whereType<StunStatusEffect>().single.remainingSeconds, 3);
  });

  test('the same buff renews its duration instead of stacking', () {
    final me = unit(
      faction: Faction.team,
      at: at(1, 0),
      stats: statsOf(manaStart: 50, manaMax: 50),
      character: dummy(
        ability: ability([
          StatBuffEffect(
            target: EffectTarget.self,
            stat: Stat.damage,
            changeType: StatChangeType.multiplier,
            value: v(2),
            seconds: v(3),
          ),
        ]),
      ),
    );

    final battle = battleWith([me]);

    castAbilityIfReady(battle, me);
    me.statusEffects.whereType<StatModifierStatusEffect>().single.remainingSeconds = 0.5;
    me.currentMana = 50;
    castAbilityIfReady(battle, me);

    final buffs = me.statusEffects.whereType<StatModifierStatusEffect>().toList();
    expect(buffs, hasLength(1));
    expect(buffs.single.remainingSeconds, 3);
    expect(me.getCurrentStat(Stat.damage), 200);
  });

  test('knockback pushes away from the caster and stops at the edge', () {
    final me = unit(
      faction: Faction.team,
      at: at(2, 2),
      stats: statsOf(manaStart: 50),
      character: dummy(ability: ability([const KnockbackEffect(target: EffectTarget.focus, cells: 5)])),
    );

    final foe = unit(faction: Faction.enemy, at: at(1, 2));
    final battle = battleWith([me, foe]);
    me.target = foe;

    castAbilityIfReady(battle, me);

    expect(foe.position, at(0, 2));
  });

  test('lifesteal heals the caster by the damage dealt', () {
    final me = unit(
      faction: Faction.team,
      at: at(1, 0),
      stats: statsOf(manaStart: 50, health: 1000),
      character: dummy(
        ability: ability([LifestealEffect(target: EffectTarget.focus, value: v(200))]),
      ),
    );

    final foe = unit(faction: Faction.enemy, at: at(0, 0), stats: statsOf(armor: 100));
    final battle = battleWith([me, foe]);
    me.target = foe;
    me.currentHealth = 500;

    castAbilityIfReady(battle, me);

    expect(foe.currentHealth, 900);
    expect(me.currentHealth, 600);
  });

  test('mana refund happens only when the cast kills', () {
    Unit caster(double foeHealth) {
      final me = unit(
        faction: Faction.team,
        at: at(1, 0),
        stats: statsOf(manaStart: 100, manaMax: 100),
        character: dummy(
          ability: ability([
            DamageEffect(target: EffectTarget.focus, value: v(50)),
            const ManaRefundOnKillEffect(percentage: 50),
          ]),
        ),
      );

      final foe = unit(
        faction: Faction.enemy,
        at: at(0, 0),
        stats: statsOf(health: foeHealth),
      );

      me.target = foe;
      castAbilityIfReady(battleWith([me, foe]), me);
      return me;
    }

    expect(caster(40).currentMana, 50);
    expect(caster(400).currentMana, 0);
  });

  test('pull brings the farthest enemy next to the caster', () {
    final me = unit(
      faction: Faction.team,
      at: at(7, 2),
      stats: statsOf(manaStart: 50),
      character: dummy(ability: ability([const PullEffect(target: EffectTarget.farthestEnemy)])),
    );

    final near = unit(faction: Faction.enemy, at: at(5, 2));
    final far = unit(faction: Faction.enemy, at: at(0, 0));
    final battle = battleWith([me, near, far]);

    castAbilityIfReady(battle, me);

    expect(far.position.distanceToPosition(me.position), 1);
    expect(near.position, at(5, 2));
  });

  test('ambush vanishes the caster and drops its target', () {
    final me = unit(
      faction: Faction.enemy,
      at: at(0, 0),
      stats: statsOf(health: 100),
      character: dummy(
        ability: ability([
          AmbushEffect(target: EffectTarget.lowestHealthEnemy, seconds: v(1)),
        ], trigger: AbilityTrigger.lowHealth),
      ),
    );

    final foe = unit(faction: Faction.team, at: at(7, 4));
    final battle = battleWith([me, foe]);
    me.target = foe;
    me.currentHealth = 10;

    castAbilityIfReady(battle, me);

    expect(me.isVanished, isTrue);
    expect(me.isTargetable, isFalse);
    expect(me.target, isNull);
  });
}
