import 'package:going_wild/domain/models/set/set_tier.dart';
import 'package:going_wild/domain/models/set/team_set.dart';

class ActiveSet {
  const ActiveSet({required this.set, required this.tier});

  final TeamSet set;
  final SetTier tier;
}
