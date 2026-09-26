import '../../character/character.dart';
import '../../character/character_copy.dart';
import '../../player/player.dart';

abstract class EconomyEngine {
  const EconomyEngine();

  int get startingCoins;
  int get rerollCostInCoins;
  int get experiencePerPurchase;
  int get experiencePurchaseCostInCoins;

  int priceOf(Character character);
  int roundIncome({required Player player, required int waveReward});
  int sellPriceOf(CharacterCopy characterCopy, {required int copiesInside});
}
