import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/data/character/team/team.dart';
import 'package:going_wild/data/set/sets.dart';
import 'package:going_wild/domain/models/models.dart';

void main() {
  final snake = RegExp(r'^[a-z]+(_[a-z]+)*$');

  test('character ids are unique and snake_case', () {
    final ids = allTeamCharacters.map((c) => c.id).toSet();
    expect(ids.length, allTeamCharacters.length);
    for (final id in ids) expect(id, matches(snake), reason: id);
  });

  test('set ids are unique and snake_case', () {
    final ids = allSets.map((s) => s.id).toSet();
    expect(ids.length, allSets.length);
    for (final id in ids) expect(id, matches(snake), reason: id);
  });

  test('set members are distinct and listed in allTeamCharacters', () {
    for (final s in allSets) {
      expect(s.members.toSet().length, s.members.length, reason: s.id);
      for (final m in s.members) expect(allTeamCharacters, contains(m), reason: '${s.id} -> ${m.id}');
    }
  });

  test('specificCharacter effects point to a member of the set', () {
    for (final s in allSets) {
      for (final effect in s.tiers.expand((t) => t.effects)) {
        if (effect.target == SetTarget.specificCharacter) {
          expect(
            s.members,
            contains(effect.character),
            reason: s.id,
          );
        }
      }
    }
  });

  test('no character is in more than 3 sets', () {
    for (final c in allTeamCharacters) {
      final count = allSets.where((s) => s.members.contains(c)).length;
      expect(count, lessThanOrEqualTo(3), reason: c.id);
    }
  });
}
