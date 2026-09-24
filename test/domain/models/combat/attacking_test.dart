import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/domain/models/combat/board/faction.dart';
import 'package:going_wild/domain/models/combat/events/battle_event.dart';
import 'package:going_wild/domain/models/combat/systems/attack_target.dart';
import 'package:going_wild/domain/models/combat/systems/deal_damage.dart';
import 'package:going_wild/domain/models/combat/systems/gain_mana.dart';
import 'package:going_wild/domain/models/combat/systems/reduce_damage_by_armor.dart';
import 'package:going_wild/domain/models/combat/unit/status_effect/status_effect.dart';
import 'package:going_wild/domain/models/combat/unit/status_effect/status_effect_kind.dart';
import 'package:going_wild/domain/models/models.dart';

import '../../../helpers/combat_helpers.dart';

void main() {
  test('armor: 50 removes a third, 100 removes half, never everything', () {
    expect(reduceDamageByArmor(120, 0), 120);
    expect(reduceDamageByArmor(120, 50), closeTo(80, 0.001));
    expect(reduceDamageByArmor(120, 100), 60);
    expect(reduceDamageByArmor(120, 10000), greaterThan(0));
  });

  test('damageTakenPercentage scales the damage after armor', () {
    final source = unit(faction: Faction.enemy, at: at(0, 0));

    final target = unit(
      at: at(1, 0),
      faction: Faction.team,
      stats: statsOf(health: 1000, armor: 100, damageTakenPercentage: 0.5),
    );

    dealDamage(battleWith([source, target]), sourceUnit: source, targetUnit: target, damageAmount: 200);
    expect(target.currentHealth, 1000 - 50);
  });

  test('shield absorbs before health and breaks when spent', () {
    final source = unit(faction: Faction.enemy, at: at(0, 0));
    final target = unit(faction: Faction.team, at: at(1, 0));
    final battle = battleWith([source, target]);

    target.statusEffects.add(
      ShieldStatusEffect(
        sourceUnit: target,
        remainingShield: 60,
        remainingSeconds: 5,
        onExpire: const [],
      ),
    );

    dealDamage(battle, sourceUnit: source, targetUnit: target, damageAmount: 100);

    expect(target.currentHealth, 1000 - 40);
    expect(target.currentShield, 0);

    final damaged = battle.events.whereType<CharacterDamaged>().single;

    expect(damaged.absorbedByShield, 60);
    expect(damaged.amount, 40);
    expect(battle.events.whereType<CharacterStatusEffectEnded>().single.statusEffectKind, StatusEffectKind.shield);
  });

  test('a lethal hit floors health at zero, clears statuses and emits Died', () {
    final source = unit(faction: Faction.enemy, at: at(0, 0));
    final target = unit(faction: Faction.team, at: at(1, 0), stats: statsOf(health: 30));
    final battle = battleWith([source, target]);
    target.statusEffects.add(StunStatusEffect(sourceUnit: source, remainingSeconds: 3));

    dealDamage(battle, sourceUnit: source, targetUnit: target, damageAmount: 100);

    expect(target.currentHealth, 0);
    expect(target.isAlive, isFalse);
    expect(target.statusEffects, isEmpty);
    expect(battle.events.whereType<CharacterDied>().single.killerUnitId, source.id);
  });

  test('dead units take no more damage', () {
    final source = unit(faction: Faction.enemy, at: at(0, 0));
    final target = unit(faction: Faction.team, at: at(1, 0))..currentHealth = 0;
    final battle = battleWith([source, target]);
    dealDamage(battle, sourceUnit: source, targetUnit: target, damageAmount: 100);
    expect(battle.events, isEmpty);
  });

  test('mana gain is capped at manaMax', () {
    final me = unit(faction: Faction.team, at: at(0, 0), stats: statsOf(manaMax: 50));
    final battle = battleWith([me]);
    gainMana(battle, me, 30);
    gainMana(battle, me, 30);
    expect(me.currentMana, 50);
    gainMana(battle, me, 10);
    expect(battle.events.whereType<CharacterReceivedMana>().length, 2);
  });

  test('attacks once per 1 / attackSpeed seconds and grants mana per hit', () {
    final me = unit(faction: Faction.team, at: at(1, 0), stats: statsOf(attackSpeed: 2, manaMax: 100));
    final foe = unit(faction: Faction.enemy, at: at(0, 0), stats: statsOf(health: 10000));
    final battle = battleWith([me, foe]);
    me.target = foe;

    for (var i = 0; i < 10; i++) {
      attackTarget(
        battle,
        me,
      );
    }

    expect(battle.events.whereType<CharacterAttackLanded>().length, 2);
    expect(me.currentMana, 20);
  });

  test('does not attack out of range', () {
    final me = unit(faction: Faction.team, at: at(3, 0));
    final foe = unit(faction: Faction.enemy, at: at(0, 0));
    final battle = battleWith([me, foe]);
    me.target = foe;

    attackTarget(battle, me);
    expect(battle.events, isEmpty);
  });

  test('next-hit modifiers are consumed by attacks', () {
    final me = unit(faction: Faction.team, at: at(1, 0), stats: statsOf(attackSpeed: 100, damage: 10));
    final foe = unit(faction: Faction.enemy, at: at(0, 0), stats: statsOf(health: 10000));
    final battle = battleWith([me, foe]);
    me.target = foe;

    me.statusEffects.add(
      NextHitsStatModifierStatusEffect(
        value: 90,
        sourceUnit: me,
        remainingHits: 1,
        stat: Stat.damage,
        changeType: StatChangeType.absoluteValue,
      ),
    );

    attackTarget(battle, me);
    attackTarget(battle, me);

    final hits = battle.events.whereType<CharacterDamaged>().map((d) => d.amount).toList();
    expect(hits, [100, 10]);
    expect(me.statusEffects, isEmpty);
  });
}
