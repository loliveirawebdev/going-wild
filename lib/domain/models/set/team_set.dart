import '../character/character.dart';
import 'set_tier.dart';

class TeamSet {
  const TeamSet({required this.id, required this.members, required this.tiers});

  final String id;
  final List<Character> members;
  final List<SetTier> tiers;
}
