import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/data/team/characters/characters.dart';
import 'package:going_wild/data/team/sets/sets.dart';
import 'package:going_wild/domain/models/models.dart';

void main() {
  final kebab = RegExp(r'^[a-z]+(-[a-z]+)*$');

  test('character ids are unique and kebab-case', () {
    final ids = allCharacters.map((c) => c.id).toSet();
    expect(ids.length, allCharacters.length);
    for (final id in ids) {
      expect(id, matches(kebab), reason: id);
    }
  });

  test('set ids are unique and kebab-case', () {
    final ids = allSets.map((s) => s.id).toSet();
    expect(ids.length, allSets.length);
    for (final id in ids) {
      expect(id, matches(kebab), reason: id);
    }
  });

  test('set members are distinct and listed in allCharacters', () {
    for (final s in allSets) {
      expect(s.members.toSet().length, s.members.length, reason: s.id);
      for (final m in s.members) {
        expect(allCharacters, contains(m), reason: '${s.id} -> ${m.id}');
      }
    }
  });

  test('specificCharacter effects point to a member of the set', () {
    for (final s in allSets) {
      for (final effect in s.tiers.expand((t) => t.effects)) {
        if (effect.target == SetTarget.specificCharacter) {
          expect(s.members, contains(effect.character), reason: s.id);
        }
      }
    }
  });

  test('no character is in more than 3 sets', () {
    for (final c in allCharacters) {
      final count = allSets.where((s) => s.members.contains(c)).length;
      expect(count, lessThanOrEqualTo(3), reason: c.id);
    }
  });
}
