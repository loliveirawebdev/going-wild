import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/engines/set/basic_set_engine.dart';
import 'package:going_wild/content/set/sets.dart';
import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/domain/models/set/set_presence.dart';
import 'package:going_wild/domain/models/set/team_set.dart';

List<SetPresence> setPresencesOf(List<Character> boardCharacters) => basicSetEngine.setPresences(boardCharacters);

SetPresence? setPresenceFrom(TeamSet set, List<Character> boardCharacters) =>
    setPresencesOf(boardCharacters).where((setPresence) => setPresence.set == set).firstOrNull;

void main() {
  final fourMemberSet = allSets.firstWhere((set) => set.tiers.length >= 2 && set.members.length >= 4);

  test('an empty board has no set present', () {
    expect(setPresencesOf([]), isEmpty);
  });

  test('a single member already makes its set present, below the first tier', () {
    expect(setPresenceFrom(fourMemberSet, [fourMemberSet.members.first])?.presentMemberCount, 1);
  });

  test('copies of the same character count once', () {
    final member = fourMemberSet.members.first;
    expect(setPresenceFrom(fourMemberSet, [member, member, member])?.presentMemberCount, 1);
  });

  test('every distinct member on the board is counted', () {
    expect(setPresenceFrom(fourMemberSet, fourMemberSet.members)?.presentMemberCount, fourMemberSet.members.length);
  });

  test('sets without members on the board are left out', () {
    final presentSets = setPresencesOf([fourMemberSet.members.first]).map((setPresence) => setPresence.set);
    expect(presentSets, everyElement(predicate<TeamSet>((set) => set.members.contains(fourMemberSet.members.first))));
  });

  test('an animal belongs to every set that lists it as a member', () {
    final member = fourMemberSet.members.first;
    final setsOfMember = basicSetEngine.setsOf(member);

    expect(setsOfMember, contains(fourMemberSet));
    expect(setsOfMember, everyElement(predicate<TeamSet>((set) => set.members.contains(member))));
  });
}
