import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/character/base_stats.dart';
import 'package:going_wild/content/character/merge_curves_per_role/merge_curves_per_role.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/content/engines/character/basic_character_engine.dart';
import 'package:going_wild/domain/models/character/abilities/ability.dart';
import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/domain/models/character/character_id.dart';
import 'package:going_wild/domain/models/character/rarity.dart';
import 'package:going_wild/domain/models/character/role.dart';
import 'package:going_wild/domain/models/character/stats/stat.dart';
import 'package:going_wild/domain/models/character/stats/stat_multipliers.dart';
import 'package:going_wild/domain/models/character/stats/stats.dart';
import 'package:going_wild/domain/models/combatant/ability_triggers/mana_full_trigger.dart';

import '../../../../helpers/combat_helpers.dart';

Stats statsOf(Character character, int stars) => basicCharacterEngine.statsAtStars(character, stars: stars);

double powerOf(Character character, int stars) {
  final stats = statsOf(character, stars);
  return stats[Stat.health] * stats[Stat.damage] * stats[Stat.attackSpeed];
}

Iterable<Character> charactersOfRarity(Rarity rarity) => allTeamCharacters.where((character) => character.rarity == rarity);

void main() {
  test('1 star is the base times the character multipliers', () {
    for (final character in allTeamCharacters) {
      final stats = statsOf(character, 1);

      for (final stat in Stat.values) {
        expect(
          stats[stat],
          closeTo(baseStats[stat] * character.statMultipliers[stat], 0.001),
          reason: '${character.id.value} $stat',
        );
      }
    }
  });

  test('every star is base times multipliers times the merge curve', () {
    for (final character in allTeamCharacters) {
      final mergeCurve = mergeCurveForRole(character.role);

      for (final stars in [1, 2, 3]) {
        final stats = statsOf(character, stars);

        for (final stat in Stat.values) {
          final expectedValue = baseStats[stat] * character.statMultipliers[stat] * mergeCurve[stat].at(stars);
          expect(stats[stat], closeTo(expectedValue, 0.001), reason: '${character.id.value} $stat $stars');
        }
      }
    }
  });

  test('a character with no multipliers is the base', () {
    const plainCharacter = Character(
      role: Role.support,
      id: CharacterId('cat'),
      rarity: Rarity.common,
      statMultipliers: StatMultipliers({}),
      ability: Ability(effects: [], trigger: ManaFullTrigger()),
      sprite: dummySprite,
    );

    final stats = statsOf(plainCharacter, 1);

    for (final stat in Stat.values) {
      expect(stats[stat], baseStats[stat], reason: '$stat');
    }
  });

  test('stars scale health and damage and keep attack speed, mana and range', () {
    for (final character in allTeamCharacters) {
      final oneStarStats = statsOf(character, 1);
      final threeStarStats = statsOf(character, 3);

      expect(threeStarStats[Stat.health], greaterThan(oneStarStats[Stat.health]), reason: character.id.value);
      expect(threeStarStats[Stat.damage], greaterThan(oneStarStats[Stat.damage]), reason: character.id.value);
      expect(threeStarStats[Stat.range], oneStarStats[Stat.range], reason: character.id.value);
      expect(threeStarStats[Stat.manaMax], oneStarStats[Stat.manaMax], reason: character.id.value);
      expect(threeStarStats[Stat.attackSpeed], oneStarStats[Stat.attackSpeed], reason: character.id.value);
    }
  });

  test('rarity says strength: average 1-star power grows with rarity', () {
    double averageOneStarPowerOf(Rarity rarity) {
      final charactersOfThisRarity = charactersOfRarity(rarity);
      final totalPower = charactersOfThisRarity.fold(0.0, (sum, character) => sum + powerOf(character, 1));

      return totalPower / charactersOfThisRarity.length;
    }

    for (var rarityIndex = 1; rarityIndex < Rarity.values.length; rarityIndex++) {
      final rarity = Rarity.values[rarityIndex];
      final previousRarity = Rarity.values[rarityIndex - 1];

      expect(averageOneStarPowerOf(rarity), greaterThan(averageOneStarPowerOf(previousRarity)), reason: rarity.name);
    }
  });

  test('merge is the ladder: any common at 3 stars beats any epic at 1 star', () {
    for (final commonCharacter in charactersOfRarity(Rarity.common)) {
      for (final epicCharacter in charactersOfRarity(Rarity.epic)) {
        expect(
          powerOf(commonCharacter, 3),
          greaterThan(powerOf(epicCharacter, 1)),
          reason: '${commonCharacter.id.value} vs ${epicCharacter.id.value}',
        );
      }
    }
  });

  test('an epic at 3 stars beats any non-epic at 3 stars', () {
    final nonEpicCharacters = allTeamCharacters.where((character) => character.rarity != Rarity.epic);

    for (final epicCharacter in charactersOfRarity(Rarity.epic)) {
      for (final nonEpicCharacter in nonEpicCharacters) {
        expect(
          powerOf(epicCharacter, 3),
          greaterThan(powerOf(nonEpicCharacter, 3)),
          reason: '${epicCharacter.id.value} vs ${nonEpicCharacter.id.value}',
        );
      }
    }
  });
}
