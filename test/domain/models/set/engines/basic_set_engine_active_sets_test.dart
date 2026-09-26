import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/engines/set/basic_set_engine.dart';
import 'package:going_wild/content/set/sets.dart';
import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/domain/models/set/active_set.dart';
import 'package:going_wild/domain/models/set/team_set.dart';

List<ActiveSet> activeSetsOf(List<Character> boardCharacters) => basicSetEngine.activeSets(boardCharacters);

Iterable<ActiveSet> activeSetsFrom(TeamSet set, List<Character> boardCharacters) =>
    activeSetsOf(boardCharacters).where((activeSet) => activeSet.set == set);

void main() {
  final twoMemberSet = allSets.firstWhere((set) => set.members.length == 2);
  final fourMemberSet = allSets.firstWhere((set) => set.tiers.length >= 2 && set.members.length >= 4);

  test('an empty board activates nothing', () {
    expect(activeSetsOf([]), isEmpty);
  });

  test('one member is not enough', () {
    expect(activeSetsFrom(fourMemberSet, [fourMemberSet.members.first]), isEmpty);
  });

  test('two distinct members reach the first tier', () {
    final activeSet = activeSetsFrom(fourMemberSet, fourMemberSet.members.take(2).toList()).single;
    expect(activeSet.tier, fourMemberSet.tiers.first);
  });

  test('copies of the same character count once', () {
    final member = fourMemberSet.members.first;
    expect(activeSetsFrom(fourMemberSet, [member, member, member]), isEmpty);
  });

  test('the highest reached tier wins and lower tiers are not returned', () {
    final activeSets = activeSetsFrom(fourMemberSet, fourMemberSet.members).toList();

    expect(activeSets, hasLength(1));
    expect(activeSets.single.tier, fourMemberSet.tiers.last);
  });

  test('a two-member set activates only with both members', () {
    expect(activeSetsFrom(twoMemberSet, [twoMemberSet.members.first]), isEmpty);
    expect(activeSetsFrom(twoMemberSet, twoMemberSet.members), hasLength(1));
  });
}
