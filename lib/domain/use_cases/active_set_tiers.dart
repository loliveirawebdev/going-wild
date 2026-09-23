import '../models/models.dart';

typedef ActiveSet = ({TeamSet set, SetTier tier});

List<ActiveSet> activeSetTiers({required List<Character> activeCharacters, required List<TeamSet> availableSets}) {
  final activeSets = <ActiveSet>[];
  final activeCharactersSet = activeCharacters.toSet();

  for (final set in availableSets) {
    final present = set.members.where(activeCharactersSet.contains).length;
    final reached = set.tiers.where((t) => t.count <= present);
    if (reached.isNotEmpty) activeSets.add((set: set, tier: reached.last));
  }

  return activeSets;
}
