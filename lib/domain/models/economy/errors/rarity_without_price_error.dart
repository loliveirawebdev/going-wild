import '../../character/rarity.dart';

class RarityWithoutPriceError extends StateError {
  RarityWithoutPriceError({required Rarity rarity}) : super('Rarity ${rarity.name} has no price in the economy');
}
