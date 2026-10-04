import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/domain/models/set/set_id.dart';
import 'package:going_wild/domain/models/set/set_tier.dart';

class TeamSet {
  const TeamSet({required this.id, required this.members, required this.tiers});

  final SetId id;
  final List<SetTier> tiers;
  final List<Character> members;
}
