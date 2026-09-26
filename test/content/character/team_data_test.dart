import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/content/set/sets.dart';
import 'package:going_wild/domain/models/set/set_target.dart';

void main() {
  test('character ids are unique', () {
    final characterIds = allTeamCharacters.map((character) => character.id).toSet();
    expect(characterIds, hasLength(allTeamCharacters.length));
  });

  test('set ids are unique', () {
    final setIds = allSets.map((set) => set.id).toSet();
    expect(setIds, hasLength(allSets.length));
  });

  test('set members are distinct and listed in allTeamCharacters', () {
    for (final set in allSets) {
      expect(set.members.toSet(), hasLength(set.members.length), reason: set.id.value);
      for (final member in set.members) expect(allTeamCharacters, contains(member), reason: '${set.id.value} -> ${member.id.value}');
    }
  });

  test('specificCharacter effects point to a member of the set', () {
    for (final set in allSets) {
      for (final effect in set.tiers.expand((tier) => tier.effects)) {
        if (effect.target == SetTarget.specificCharacter) expect(set.members, contains(effect.character), reason: set.id.value);
      }
    }
  });

  test('no character is in more than 3 sets', () {
    for (final character in allTeamCharacters) {
      final setCount = allSets.where((set) => set.members.contains(character)).length;
      expect(setCount, lessThanOrEqualTo(3), reason: character.id.value);
    }
  });
}
