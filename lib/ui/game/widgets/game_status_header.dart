import 'package:flutter/material.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';

class GameStatusHeader extends StatelessWidget {
  const GameStatusHeader({required this.matchProgress, super.key});

  final MatchProgress matchProgress;

  @override
  Widget build(BuildContext context) {
    final translations = context.t.game;
    final player = matchProgress.player;
    final playerLevelProgress = matchProgress.playerLevelProgress;

    return Wrap(
      spacing: 16,
      runSpacing: 4,
      children: [
        Text(translations.round(roundCount: matchProgress.phase.roundCount, roundNumber: matchProgress.currentRoundNumber)),
        Text(translations.lives(lives: player.remainingLives)),
        Text(translations.coins(coins: player.coins)),
        Text(translations.level(experience: playerLevelProgress.experience, levelNumber: playerLevelProgress.level.number)),
      ],
    );
  }
}
