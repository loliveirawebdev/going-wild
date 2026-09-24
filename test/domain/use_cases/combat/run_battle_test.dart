import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/data/character/base_stats.dart';
import 'package:going_wild/data/character/enemies/enemies.dart';
import 'package:going_wild/data/character/merge_curves/merge_curves.dart';
import 'package:going_wild/data/character/team/team.dart';
import 'package:going_wild/data/combat/battle_rules.dart' as rules;
import 'package:going_wild/data/set/sets.dart';
import 'package:going_wild/domain/models/combat/battle_result.dart';
import 'package:going_wild/domain/models/combat/battle_rules.dart';
import 'package:going_wild/domain/models/combat/board/faction.dart';
import 'package:going_wild/domain/models/combat/board/placement.dart';
import 'package:going_wild/domain/models/combat/events/battle_event.dart';
import 'package:going_wild/domain/models/combat/unit/status_effect/status_effect_kind.dart';
import 'package:going_wild/domain/models/combat/unit/unit.dart';
import 'package:going_wild/domain/models/models.dart';
import 'package:going_wild/domain/use_cases/combat/run_battle.dart';

import '../../../helpers/combat_helpers.dart';

BattleResult run({
  required List<Placement> team,
  required List<Placement> enemies,
  int seed = 7,
  double maxSeconds = 60,
}) => runBattle(
  team: team,
  sets: allSets,
  enemies: enemies,
  board: testBoard,
  baseStats: baseStats,
  mergeCurveFor: mergeCurveFor,
  randomGenerator: Random(seed),

  rules: BattleRules(
    maxSeconds: maxSeconds,
    manaPerHit: rules.manaPerHit,
    tickSeconds: rules.tickSeconds,
    nearbyRadius: rules.nearbyRadius,
    lowHealthTriggerPercentage: rules.lowHealthTriggerPercentage,
  ),
);

Placement place(Character c, int row, int column, {int stars = 1}) => Placement(character: c, stars: stars, position: at(row, column));

void main() {
  test('a cat beats a single rat', () {
    final result = run(team: [place(cat, 6, 2)], enemies: [place(rat, 1, 2)]);
    expect(result.winningFaction, Faction.team);
    expect(result.survivingUnits.single.character, cat);
  });

  test('events start with BattleStarted and end with BattleEnded, ordered in time', () {
    final result = run(team: [place(cat, 6, 2)], enemies: [place(rat, 1, 2)]);
    expect(result.events.first, isA<BattleStarted>());
    expect(result.events.last, isA<BattleEnded>());
    for (var i = 1; i < result.events.length; i++) {
      expect(result.events[i].time, greaterThanOrEqualTo(result.events[i - 1].time));
    }
  });

  test('same seed, same battle', () {
    final a = run(
      team: [place(dog, 6, 1), place(chicken, 7, 2)],
      enemies: [place(rat, 1, 1), place(fox, 0, 3)],
      seed: 3,
    );
    final b = run(
      team: [place(dog, 6, 1), place(chicken, 7, 2)],
      enemies: [place(rat, 1, 1), place(fox, 0, 3)],
      seed: 3,
    );
    expect(a.events.length, b.events.length);
    expect(a.winningFaction, b.winningFaction);
    expect(a.elapsedSeconds, b.elapsedSeconds);
  });

  test('a lone chicken loses to a bear', () {
    final result = run(team: [place(chicken, 6, 2)], enemies: [place(bear, 1, 2)]);
    expect(result.winningFaction, Faction.enemy);
  });

  test('dead units stop acting and the fight ends when one side is gone', () {
    final result = run(team: [place(cat, 6, 2)], enemies: [place(rat, 1, 2)]);
    final died = result.events.whereType<CharacterDied>().single;
    final after = result.events.skipWhile((e) => e != died).skip(1);
    expect(after.whereType<CharacterAttackLanded>().where((e) => e.unitId == died.unitId), isEmpty);
    expect(after.last, isA<BattleEnded>());
  });

  test('time limit gives a draw', () {
    final result = run(team: [place(bull, 7, 0)], enemies: [place(kraken, 0, 4)], seed: 1, maxSeconds: 0.3);
    expect(result.isDraw, isTrue);
    expect(result.survivingUnits, hasLength(2));
  });

  test('the dog barks and every enemy turns to it', () {
    final team = [place(dog, 6, 1), place(chicken, 7, 3)];
    final enemies = [place(rat, 2, 0), place(rat, 2, 4), place(boar, 1, 2)];
    final result = run(team: team, enemies: enemies);
    final enemyIds = List.generate(enemies.length, (index) => team.length + index + 1).toSet();

    final bark = result.events.whereType<CharacterAbilityCast>().firstWhere((cast) => cast.abilityId == 'bark');
    final dogId = bark.unitId;
    final tauntedAtBark = result.events
        .whereType<CharacterStatusEffectStarted>()
        .where((event) => event.time == bark.time && event.statusEffectKind == StatusEffectKind.taunt)
        .map((event) => event.unitId)
        .toSet();
    final targetingDogAtBark = result.events
        .whereType<CharacterNewTargetAcquired>()
        .where((event) => event.time == bark.time)
        .every((event) => event.targetUnitId == dogId);

    final deadBeforeBark = result.events
        .whereType<CharacterDied>()
        .where((event) => event.time < bark.time)
        .map((event) => event.unitId)
        .toSet();
    final enemiesAliveAtBark = enemyIds.difference(deadBeforeBark);

    expect(enemiesAliveAtBark, isNotEmpty);
    expect(tauntedAtBark, enemiesAliveAtBark);
    expect(targetingDogAtBark, isTrue);
  });

  test('a two-star unit resolves stronger than its one-star self', () {
    final one = run(team: [place(chicken, 6, 2)], enemies: [place(boar, 1, 2)]);
    final two = run(team: [place(chicken, 6, 2, stars: 2)], enemies: [place(boar, 1, 2)]);
    final oneDamage = one.events.whereType<CharacterDamaged>().where((d) => d.sourceId == 1).first.amount;
    final twoDamage = two.events.whereType<CharacterDamaged>().where((d) => d.sourceId == 1).first.amount;
    expect(twoDamage, greaterThan(oneDamage));
  });

  test('active sets change the team stats inside the battle', () {
    final without = run(team: [place(cow, 6, 2)], enemies: [place(rat, 1, 2)]);
    final withDairy = run(team: [place(cow, 6, 2), place(sheep, 7, 1)], enemies: [place(rat, 1, 2)]);
    Unit cowIn(BattleResult r) => r.survivingUnits.firstWhere((u) => u.character == cow);
    expect(cowIn(withDairy).stats.shield, greaterThan(cowIn(without).stats.shield));
  });

  test('a shield on expire effect goes off inside the battle', () {
    const shieldBomber = Character(
      id: 'shield_bomber',
      role: Role.tank,
      rarity: Rarity.common,
      statMultipliers: StatMultipliers({Stat.health: 10, Stat.manaStart: 50, Stat.manaMax: 50}),
      ability: Ability(
        id: 'shield_bomb',
        trigger: AbilityTrigger.manaFull,
        effects: [
          ShieldEffect(
            target: EffectTarget.self,
            value: StarValues(star1: 100, star2: 100, star3: 100),
            seconds: StarValues(star1: 0.5, star2: 0.5, star3: 0.5),
            onExpire: [DamageEffect(target: EffectTarget.nearbyEnemies, value: StarValues(star1: 1000, star2: 1000, star3: 1000))],
          ),
        ],
      ),
    );

    final result = run(team: [place(shieldBomber, 6, 2)], enemies: [place(rat, 5, 2)]);

    final shieldEnded = result.events.whereType<CharacterStatusEffectEnded>().firstWhere(
      (event) => event.statusEffectKind == StatusEffectKind.shield,
    );
    final ratDied = result.events.whereType<CharacterDied>().single;
    expect(ratDied.killerUnitId, 1);
    expect(ratDied.time, shieldEnded.time);
    expect(result.winningFaction, Faction.team);
  });
}
