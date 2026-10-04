import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';

abstract class EconomyEngine {
  const EconomyEngine();

  int get startingCoins;

  int roundIncome({required MatchProgress matchProgress});
  int rerollCostInCoins({required MatchProgress matchProgress});
  int experiencePerPurchase({required MatchProgress matchProgress});
  int experiencePurchaseCostInCoins({required MatchProgress matchProgress});
  int priceOf(Character character, {required MatchProgress matchProgress});
  int sellPriceOf(CharacterCopy characterCopy, {required MatchProgress matchProgress});
}
