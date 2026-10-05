import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/set/sets.dart';
import 'package:going_wild/domain/models/set/set_presence.dart';

void main() {
  test('the reached tiers come from how many members are on the field', () {
    expect(const SetPresence(set: flyers, presentMemberCount: 1).reachedTierCount, 0);
    expect(const SetPresence(set: flyers, presentMemberCount: 3).reachedTierCount, 1);
    expect(const SetPresence(set: flyers, presentMemberCount: 4).reachedTierCount, 2);
  });

  test('a set is complete only when every tier is reached', () {
    expect(const SetPresence(set: flyers, presentMemberCount: 3).isComplete, isFalse);
    expect(const SetPresence(set: flyers, presentMemberCount: 4).isComplete, isTrue);
  });

  test('a set with a single tier is complete as soon as it reaches it', () {
    expect(const SetPresence(set: herding, presentMemberCount: 1).isComplete, isFalse);
    expect(const SetPresence(set: herding, presentMemberCount: 2).isComplete, isTrue);
  });

  test('the next tier is the first one not reached yet', () {
    expect(const SetPresence(set: flyers, presentMemberCount: 1).nextTier, flyers.tiers.first);
    expect(const SetPresence(set: flyers, presentMemberCount: 3).nextTier, flyers.tiers.last);
    expect(const SetPresence(set: flyers, presentMemberCount: 4).nextTier, isNull);
  });
}
