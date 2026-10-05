import 'package:going_wild/domain/models/set/set_tier.dart';
import 'package:going_wild/domain/models/set/team_set.dart';

class SetPresence {
  const SetPresence({required this.set, required this.presentMemberCount});

  final TeamSet set;
  final int presentMemberCount;

  List<SetTier> get reachedTiers => [
    for (final tier in set.tiers)
      if (tier.count <= presentMemberCount) tier,
  ];

  int get reachedTierCount => reachedTiers.length;
  bool get isComplete => reachedTierCount > 0 && reachedTierCount == set.tiers.length;
  SetTier? get nextTier => set.tiers.elementAtOrNull(reachedTierCount);
}
