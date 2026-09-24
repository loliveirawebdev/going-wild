import '../models.dart';
import '../shop/owned_character.dart';

class Player {
  Player({required this.coins});

  int coins;
  int level = 1;
  int experience = 0;
  List<Character?> shopOffers = [];
  final List<OwnedCharacter> ownedCharacters = [];
}
