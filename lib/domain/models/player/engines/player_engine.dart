import 'package:going_wild/domain/models/combat/combat_result.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/domain/models/player/player.dart';

abstract class PlayerEngine {
  const PlayerEngine();
  int get startingLives;

  Player startingPlayer({required int startingCoins});
  Player playerAfterLostRound({required MatchProgress matchProgress, required CombatResult combatResult});
}
