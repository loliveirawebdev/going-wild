import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/set/sets.dart';
import 'package:going_wild/domain/models/set/set_presence.dart';
import 'package:going_wild/domain/models/set/team_set.dart';

SetPresence presenceOf(TeamSet set, {required int memberCount}) =>
    SetPresence(set: set, presentMembers: set.members.take(memberCount).toList());

void main() {
  test('the reached tiers come from how many members are on the field', () {
    expect(presenceOf(flyers, memberCount: 1).reachedTierCount, 0);
    expect(presenceOf(flyers, memberCount: 3).reachedTierCount, 1);
    expect(presenceOf(flyers, memberCount: 4).reachedTierCount, 2);
  });

  test('a set is complete only when every tier is reached', () {
    expect(presenceOf(flyers, memberCount: 3).isComplete, isFalse);
    expect(presenceOf(flyers, memberCount: 4).isComplete, isTrue);
  });

  test('a set with a single tier is complete as soon as it reaches it', () {
    expect(presenceOf(herding, memberCount: 1).isComplete, isFalse);
    expect(presenceOf(herding, memberCount: 2).isComplete, isTrue);
  });

  test('the next tier is the first one not reached yet', () {
    expect(presenceOf(flyers, memberCount: 1).nextTier, flyers.tiers.first);
    expect(presenceOf(flyers, memberCount: 3).nextTier, flyers.tiers.last);
    expect(presenceOf(flyers, memberCount: 4).nextTier, isNull);
  });
}
