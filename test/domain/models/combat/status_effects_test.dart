import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/domain/models/combat/board/faction.dart';
import 'package:going_wild/domain/models/events/combat/battle_event.dart';
import 'package:going_wild/domain/models/combat/systems/advance_statuses_by_one_tick.dart';
import 'package:going_wild/domain/models/combat/systems/deal_damage.dart';
import 'package:going_wild/domain/models/combat/unit/status_effect/status_effect.dart';
import 'package:going_wild/domain/models/combat/unit/status_effect/status_effect_kind.dart';
import 'package:going_wild/domain/models/models.dart';

import '../../../helpers/combat_helpers.dart';

void main() {
  const explosion = [DamageEffect(target: EffectTarget.nearbyEnemies, value: StarValues(star1: 100, star2: 100, star3: 100))];

  test('damage over time hurts on every tick until its duration ends', () {
    final poisonerUnit = unit(faction: Faction.enemy, at: at(0, 0));
    final poisonedUnit = unit(faction: Faction.team, at: at(7, 4));
    final battle = battleWith([poisonerUnit, poisonedUnit]);
    poisonedUnit.statusEffects.add(DamageOverTimeStatusEffect(sourceUnit: poisonerUnit, damagePerSecond: 30, remainingSeconds: 0.95));

    for (var tick = 0; tick < 5; tick++) advanceStatusesByOneTick(battle, poisonedUnit);
    expect(poisonedUnit.currentHealth, closeTo(1000 - 15, 0.001));

    for (var tick = 0; tick < 10; tick++) advanceStatusesByOneTick(battle, poisonedUnit);
    expect(poisonedUnit.currentHealth, closeTo(1000 - 30, 0.001));
    expect(poisonedUnit.statusEffects, isEmpty);
    expect(battle.events.whereType<CharacterStatusEffectEnded>().single.statusEffectKind, StatusEffectKind.damageOverTime);
    expect(battle.events.whereType<CharacterDamaged>().map((event) => event.sourceId).toSet(), {poisonerUnit.id});
  });

  test('a shield that times out is removed and queues its on expire effects', () {
    final shieldedUnit = unit(faction: Faction.team, at: at(6, 2));
    final battle = battleWith([shieldedUnit]);
    shieldedUnit.statusEffects.add(
      ShieldStatusEffect(sourceUnit: shieldedUnit, remainingShield: 100, remainingSeconds: 0.05, onExpire: explosion),
    );

    advanceStatusesByOneTick(battle, shieldedUnit);

    expect(shieldedUnit.currentShield, 0);
    expect(battle.events.whereType<CharacterStatusEffectEnded>().single.statusEffectKind, StatusEffectKind.shield);
    expect(battle.deferredEffects.single.casterUnit, shieldedUnit);
    expect(battle.deferredEffects.single.effects, explosion);
  });

  test('a shield broken by damage also queues its on expire effects', () {
    final attackerUnit = unit(faction: Faction.enemy, at: at(5, 2));
    final shieldedUnit = unit(faction: Faction.team, at: at(6, 2));
    final battle = battleWith([attackerUnit, shieldedUnit]);
    shieldedUnit.statusEffects.add(
      ShieldStatusEffect(sourceUnit: shieldedUnit, remainingShield: 100, remainingSeconds: 5, onExpire: explosion),
    );

    dealDamage(battle, sourceUnit: attackerUnit, targetUnit: shieldedUnit, damageAmount: 150);

    expect(shieldedUnit.currentHealth, 1000 - 50);
    expect(battle.deferredEffects.single.effects, explosion);
  });

  test('a shield that still holds queues nothing', () {
    final attackerUnit = unit(faction: Faction.enemy, at: at(5, 2));
    final shieldedUnit = unit(faction: Faction.team, at: at(6, 2));
    final battle = battleWith([attackerUnit, shieldedUnit]);
    shieldedUnit.statusEffects.add(
      ShieldStatusEffect(sourceUnit: shieldedUnit, remainingShield: 100, remainingSeconds: 5, onExpire: explosion),
    );

    dealDamage(battle, sourceUnit: attackerUnit, targetUnit: shieldedUnit, damageAmount: 60);

    expect(shieldedUnit.currentShield, 40);
    expect(battle.deferredEffects, isEmpty);
  });

  test('a stat modifier wears off after its duration', () {
    final debufferUnit = unit(faction: Faction.enemy, at: at(0, 0));
    final debuffedUnit = unit(faction: Faction.team, at: at(7, 4), stats: statsOf(armor: 100));
    final battle = battleWith([debufferUnit, debuffedUnit]);
    debuffedUnit.statusEffects.add(
      StatModifierStatusEffect(
        sourceUnit: debufferUnit,
        stat: Stat.armor,
        changeType: StatChangeType.multiplier,
        value: 0.5,
        remainingSeconds: 0.15,
      ),
    );

    advanceStatusesByOneTick(battle, debuffedUnit);
    expect(debuffedUnit.getCurrentStat(Stat.armor), 50);

    advanceStatusesByOneTick(battle, debuffedUnit);
    expect(debuffedUnit.getCurrentStat(Stat.armor), 100);
    expect(battle.events.whereType<CharacterStatusEffectEnded>().single.statusEffectKind, StatusEffectKind.statModifier);
  });
}
