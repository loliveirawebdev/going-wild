import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/character/enemies/enemies.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/content/engines/character/basic_character_engine.dart';
import 'package:going_wild/content/engines/set/basic_set_engine.dart';
import 'package:going_wild/domain/models/board/placement.dart';
import 'package:going_wild/domain/models/character/abilities/ability.dart';
import 'package:going_wild/domain/models/character/abilities/ability_trigger.dart';
import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/domain/models/character/character_id.dart';
import 'package:going_wild/domain/models/character/rarity.dart';
import 'package:going_wild/domain/models/character/role.dart';
import 'package:going_wild/domain/models/character/stars/star_values.dart';
import 'package:going_wild/domain/models/character/stats/stat.dart';
import 'package:going_wild/domain/models/character/stats/stat_multipliers.dart';
import 'package:going_wild/domain/models/combat/combat_result.dart';
import 'package:going_wild/domain/models/combat/combat_rules.dart';
import 'package:going_wild/domain/models/combat/combatant_actions/cast_ability_if_ready.dart';
import 'package:going_wild/domain/models/combat/engines/basic_combat_engine.dart';
import 'package:going_wild/domain/models/combat_history/entries/combat_history_entry.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/combat_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/combat_effect_target.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/damage/damage_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/shield/shield_combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/shield/shield_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/taunt/taunt_combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combatant.dart';
import 'package:going_wild/domain/models/combatant/faction.dart';

import '../../../../helpers/combat_helpers.dart';

CombatResult run({
  required List<Placement> team,
  required List<Placement> enemies,
  int seed = 7,
  double maxSeconds = 60,
}) => BasicCombatEngine(
  board: testBoard,
  setEngine: basicSetEngine,
  characterEngine: basicCharacterEngine,
  rules: CombatRules(
    maxSeconds: maxSeconds,
    manaPerHit: testRules.manaPerHit,
    nearbyRadius: testRules.nearbyRadius,
    ticksPerSecond: testRules.ticksPerSecond,
    lowHealthTriggerPercentage: testRules.lowHealthTriggerPercentage,
  ),
).simulate(team: team, enemies: enemies, randomGenerator: Random(seed));

Placement place(Character character, int row, int column, {int stars = 1}) => Placement(
  position: at(row, column),
  characterCopy: CharacterCopy(stars: stars, character: character),
);

Combatant combatantOf(CombatResult result, Character character) =>
    result.combatants.firstWhere((combatant) => combatant.characterCopy.character == character);

Character shieldBomberWith(List<CombatEffect> onExpire) => Character(
  role: Role.tank,
  id: const CharacterId('cow'),
  rarity: Rarity.common,
  statMultipliers: const StatMultipliers({Stat.health: 10, Stat.damage: 0.01, Stat.manaStart: 50, Stat.manaMax: 50}),
  ability: Ability(
    trigger: AbilityTrigger.manaFull,
    effects: [
      ShieldEffect(
        onExpire: onExpire,
        target: CombatEffectTarget.self,
        value: const StarValues(star1: 100, star2: 100, star3: 100),
        seconds: const StarValues(star1: 0.5, star2: 0.5, star3: 0.5),
      ),
    ],
  ),
);

void main() {
  test('a cat beats a single rat', () {
    final result = run(team: [place(cat, 6, 2)], enemies: [place(rat, 1, 2)]);

    expect(result.winningFaction, Faction.team);
    expect(result.survivingCombatants.single.characterCopy.character, cat);
  });

  test('same seed, same round', () {
    CombatResult runWithSeedThree() => run(
      seed: 3,
      enemies: [place(rat, 1, 1), place(fox, 0, 3)],
      team: [place(dog, 6, 1), place(chicken, 7, 2)],
    );

    final firstResult = runWithSeedThree();
    final secondResult = runWithSeedThree();

    expect(firstResult.winningFaction, secondResult.winningFaction);
    expect(firstResult.elapsedSeconds, secondResult.elapsedSeconds);
    expect(
      firstResult.combatants.map((combatant) => (combatant.position, combatant.currentHealth)),
      secondResult.combatants.map((combatant) => (combatant.position, combatant.currentHealth)),
    );
  });

  test('a lone chicken loses to a bear', () {
    final result = run(team: [place(chicken, 6, 2)], enemies: [place(bear, 1, 2)]);

    expect(result.winningFaction, Faction.enemy);
  });

  test('time limit gives a draw', () {
    final result = run(seed: 1, maxSeconds: 0.3, team: [place(bull, 7, 0)], enemies: [place(kraken, 0, 4)]);

    expect(result.isDraw, isTrue);
    expect(result.isLost, isTrue);
    expect(result.elapsedSeconds, closeTo(0.3, 0.001));
    expect(result.survivingCombatants, hasLength(2));
  });

  test('the result keeps every combatant of the round, the dead ones too', () {
    final result = run(team: [place(cat, 6, 2)], enemies: [place(rat, 1, 2)]);

    expect(result.combatants.map((combatant) => combatant.characterCopy.character), [cat, rat]);
    expect(combatantOf(result, rat).isAlive, isFalse);
  });

  test('the dog barks and every alive enemy turns to it', () {
    final dogStats = basicCharacterEngine.statsAtStars(dog, stars: 1);
    final barkingDog = combatant(
      at: at(6, 1),
      character: dog,
      faction: Faction.team,
      stats: dogStats.createCopyWithStat(Stat.manaStart, dogStats[Stat.manaMax]),
    );
    final enemies = [at(2, 0), at(2, 4), at(1, 2)].map((position) => combatant(at: position, faction: Faction.enemy)).toList();
    final deadEnemy = combatant(at: at(0, 0), faction: Faction.enemy).createCopyWith(currentHealth: 0);

    final barkedCombat = castAbilityIfReady(combatWith([barkingDog, ...enemies, deadEnemy]), barkingDog.id);

    for (final enemy in enemies) {
      final tauntedEnemy = findCombatant(barkedCombat, enemy);
      expect(tauntedEnemy.targetCombatantId, barkingDog.id);
      expect(tauntedEnemy.combatLastingEffects.whereType<TauntCombatLastingEffect>().single.sourceCombatantId, barkingDog.id);
    }
    expect(findCombatant(barkedCombat, deadEnemy).combatLastingEffects, isEmpty);
  });

  test('a two-star combatant deals more damage than its one-star self', () {
    double damageDealtToKrakenBy(int stars) {
      final result = run(
        maxSeconds: 2,
        enemies: [place(kraken, 5, 2)],
        team: [place(chicken, 6, 2, stars: stars)],
      );
      final krakenCombatant = combatantOf(result, kraken);
      return krakenCombatant.stats[Stat.health] - krakenCombatant.currentHealth;
    }

    expect(damageDealtToKrakenBy(2), greaterThan(damageDealtToKrakenBy(1)));
  });

  test('stat modifications of active sets change the team stats inside the round', () {
    final result = run(maxSeconds: 0.1, enemies: [place(rat, 1, 2)], team: [place(bull, 6, 2), place(horse, 7, 1)]);
    final bullHealthAtStars = basicCharacterEngine.statsAtStars(bull, stars: 1)[Stat.health];

    expect(combatantOf(result, bull).stats[Stat.health], closeTo(bullHealthAtStars * 1.15, 0.001));
  });

  test('starting shields of active sets protect the team from the start and never the enemies', () {
    final result = run(maxSeconds: 0.1, enemies: [place(rat, 0, 2)], team: [place(cow, 6, 2), place(sheep, 7, 1)]);

    expect(combatantOf(result, cow).currentShield, 150);
    expect(combatantOf(result, sheep).currentShield, 150);
    expect(combatantOf(result, rat).currentShield, 0);
  });

  test('a shield on expire effect goes off inside the round', () {
    final bomb = [const DamageEffect(target: CombatEffectTarget.nearbyEnemies, value: StarValues(star1: 1000, star2: 1000, star3: 1000))];

    final bombResult = run(enemies: [place(rat, 5, 2)], team: [place(shieldBomberWith(bomb), 6, 2)]);
    final quietResult = run(enemies: [place(rat, 5, 2)], team: [place(shieldBomberWith(const []), 6, 2)]);

    expect(bombResult.winningFaction, Faction.team);
    expect(bombResult.elapsedSeconds, lessThan(1));
    expect(quietResult.elapsedSeconds, greaterThan(bombResult.elapsedSeconds));
  });

  test('the history starts with the combat start, ends with the combat end and never goes back in time', () {
    final result = run(team: [place(cat, 6, 2)], enemies: [place(rat, 1, 2)]);
    final ticks = result.history.entries.map((entry) => entry.tick).toList();

    expect(result.history.entries.first, isA<CombatStartedHistoryEntry>());
    expect((result.history.entries.last as CombatEndedHistoryEntry).winningFaction, result.winningFaction);
    expect(ticks, orderedEquals([...ticks]..sort()));
  });

  test('the same seed gives the same history', () {
    List<Type> historyEntryTypesOfSeedThree() => run(
      seed: 3,
      enemies: [place(rat, 1, 1), place(fox, 0, 3)],
      team: [place(dog, 6, 1), place(chicken, 7, 2)],
    ).history.entries.map((entry) => entry.runtimeType).toList();

    expect(historyEntryTypesOfSeedThree(), historyEntryTypesOfSeedThree());
  });

  test('dead combatants stop acting', () {
    final result = run(team: [place(cat, 6, 2)], enemies: [place(rat, 1, 2)]);
    final ratDeath = result.history.entries.whereType<DeathHistoryEntry>().single;
    final historyAfterDeath = result.history.entries.skipWhile((entry) => entry != ratDeath).skip(1);
    final attacksAfterDeath = historyAfterDeath.whereType<AttackLandedHistoryEntry>().where(
      (attack) => attack.combatantId == ratDeath.combatantId,
    );

    expect(attacksAfterDeath, isEmpty);
    expect(historyAfterDeath.last, isA<CombatEndedHistoryEntry>());
  });

  test('the dog barks and every alive enemy is taunted and turns to it in the same tick', () {
    final team = [place(dog, 6, 1), place(chicken, 7, 3)];
    final enemies = [place(rat, 2, 0), place(rat, 2, 4), place(boar, 1, 2)];
    final result = run(team: team, enemies: enemies);

    final dogCombatantId = combatantOf(result, dog).id;
    final bark = result.history.entries.whereType<AbilityCastHistoryEntry>().firstWhere((cast) => cast.combatantId == dogCombatantId);
    final enemyIds = [
      for (final combatant in result.combatants)
        if (combatant.faction == Faction.enemy) combatant.id,
    ];
    final deadBeforeBark = {
      for (final death in result.history.entries.whereType<DeathHistoryEntry>())
        if (death.tick < bark.tick) death.combatantId,
    };
    final tauntedAtBark = {
      for (final started in result.history.entries.whereType<LastingEffectStartedHistoryEntry>())
        if (started.tick == bark.tick && started.combatLastingEffect is TauntCombatLastingEffect) started.combatantId,
    };
    final newTargetsAtBark = result.history.entries.whereType<TargetAcquiredHistoryEntry>().where(
      (newTarget) => newTarget.tick == bark.tick,
    );

    expect(tauntedAtBark, enemyIds.toSet().difference(deadBeforeBark));
    expect(newTargetsAtBark.map((newTarget) => newTarget.targetCombatantId).toSet(), {bark.combatantId});
  });

  test('starting shields of active sets enter the history at the start of the round', () {
    final result = run(enemies: [place(rat, 0, 2)], team: [place(cow, 6, 2), place(sheep, 7, 1)]);
    final startedAtBeginning = result.history.entries.whereType<LastingEffectStartedHistoryEntry>().where((started) => started.tick == 0);

    expect(startedAtBeginning.map((started) => started.combatantId).toSet(), {
      combatantOf(result, cow).id,
      combatantOf(result, sheep).id,
    });
    expect(startedAtBeginning.map((started) => started.combatLastingEffect), everyElement(isA<ShieldCombatLastingEffect>()));
  });

  test('a shield on expire effect kills in the same tick the shield ends, credited to the shield owner', () {
    final bomb = [DamageEffect(value: atEveryStar(1000), target: CombatEffectTarget.nearbyEnemies)];
    final result = run(enemies: [place(rat, 5, 2)], team: [place(shieldBomberWith(bomb), 6, 2)]);

    final shieldEnded = result.history.entries.whereType<LastingEffectEndedHistoryEntry>().firstWhere(
      (ended) => ended.combatLastingEffect is ShieldCombatLastingEffect,
    );
    final ratDeath = result.history.entries.whereType<DeathHistoryEntry>().single;

    expect(ratDeath.tick, shieldEnded.tick);
    expect(ratDeath.killerCombatantId, shieldEnded.combatantId);
  });
}
