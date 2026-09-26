import '../character/character.dart';
import 'set_id.dart';
import 'set_tier.dart';

class TeamSet {
  const TeamSet({required this.id, required this.members, required this.tiers});

  final SetId id;
  final List<SetTier> tiers;
  final List<Character> members;
}
