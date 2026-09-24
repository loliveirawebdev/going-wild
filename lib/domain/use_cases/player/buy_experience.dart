import '../../models/phase/phase_run.dart';
import '../../models/player/level/gain_experience.dart';

bool buyExperience(PhaseRun phaseRun) {
  final player = phaseRun.player;
  final rules = phaseRun.rules.shopRules;
  if (player.level >= rules.maxLevel || player.coins < rules.experiencePurchaseCostInCoins) return false;

  player.coins -= rules.experiencePurchaseCostInCoins;
  gainExperience(phaseRun, rules.experiencePerPurchase);
  return true;
}
