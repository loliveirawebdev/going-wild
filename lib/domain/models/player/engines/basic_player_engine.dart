import 'package:going_wild/domain/models/combat/combat_result.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/domain/models/player/engines/player_engine.dart';
import 'package:going_wild/domain/models/player/errors/player_has_no_lives_left_error.dart';
import 'package:going_wild/domain/models/player/player.dart';
import 'package:going_wild/domain/models/player/player_factory.dart';

class BasicPlayerEngine extends PlayerEngine {
  const BasicPlayerEngine({required this.startingLives, required this.livesLostPerLostRound});

  final int startingLives;
  final int livesLostPerLostRound;

  @override
  Player startingPlayer({required int startingCoins}) => PlayerFactory.starting(coins: startingCoins, lives: startingLives);

  @override
  Player playerAfterLostRound({required MatchProgress matchProgress, required CombatResult combatResult}) {
    final player = matchProgress.player;
    if (player.isOutOfLives) throw PlayerHasNoLivesLeftError();
    return Player(coins: player.coins, remainingLives: player.remainingLives - livesLostPerLostRound);
  }
}
