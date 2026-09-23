import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/data/team/sets/sets.dart';
import 'package:going_wild/domain/models/models.dart';
import 'package:going_wild/domain/use_cases/active_set_tiers.dart';

void main() {
  final fourMemberSet = allSets.firstWhere((s) => s.tiers.length >= 2 && s.members.length >= 4);
  final twoMemberSet = allSets.firstWhere((s) => s.members.length == 2);
  List<ActiveSet> active(List<Character> board) => activeSetTiers(activeCharacters: board, availableSets: allSets);

  test('an empty board activates nothing', () {
    expect(active([]), isEmpty);
  });

  test('one member is not enough', () {
    final tiersOf = active([fourMemberSet.members.first]).where((a) => a.set == fourMemberSet);
    expect(tiersOf, isEmpty);
  });

  test('two distinct members reach the first tier', () {
    final result = active(fourMemberSet.members.take(2).toList()).singleWhere((a) => a.set == fourMemberSet);
    expect(result.tier, fourMemberSet.tiers.first);
  });

  test('copies of the same character count once', () {
    final m = fourMemberSet.members.first;
    expect(active([m, m, m]).where((a) => a.set == fourMemberSet), isEmpty);
  });

  test('the highest reached tier wins and lower tiers are not returned', () {
    final result = active(fourMemberSet.members).where((a) => a.set == fourMemberSet).toList();
    expect(result, hasLength(1));
    expect(result.single.tier, fourMemberSet.tiers.last);
  });

  test('a two-member set activates only with both members', () {
    expect(active([twoMemberSet.members.first]).where((a) => a.set == twoMemberSet), isEmpty);
    expect(active(twoMemberSet.members).where((a) => a.set == twoMemberSet), hasLength(1));
  });
}
