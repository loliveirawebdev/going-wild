import 'owned_character.dart';
import '../player/player.dart';
import 'shop_rules.dart';

void mergeOwnedCharacters(Player player, ShopRules rules) {
  var hasMerged = true;
  while (hasMerged) hasMerged = _mergeFirstGroupOfCopies(player, rules);
}

bool _mergeFirstGroupOfCopies(Player player, ShopRules rules) {
  for (final ownedCharacter in player.ownedCharacters) {
    if (ownedCharacter.stars >= rules.maxStars) continue;

    final copies = player.ownedCharacters
        .where((otherOwnedChar) => otherOwnedChar.character == ownedCharacter.character && otherOwnedChar.stars == ownedCharacter.stars)
        .take(rules.copiesPerMerge)
        .toList();

    if (copies.length < rules.copiesPerMerge) continue;

    for (final copy in copies) player.ownedCharacters.remove(copy);
    player.ownedCharacters.add(OwnedCharacter(character: ownedCharacter.character, stars: ownedCharacter.stars + 1));
    return true;
  }

  return false;
}
