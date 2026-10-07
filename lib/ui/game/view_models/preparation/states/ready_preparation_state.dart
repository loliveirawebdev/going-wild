part of 'preparation_state.dart';

class ReadyPreparationState extends PreparationState {
  const ReadyPreparationState({required this.matchProgress, this.rejection, this.summonedSlots = const []});

  final MatchProgress matchProgress;
  final List<RosterSlot> summonedSlots;

  PlayerOptions get playerOptions => PlayerOptions(matchProgress);
  final PreparationRejection? rejection;

  @override
  String toString() {
    final player = matchProgress.player;
    final level = matchProgress.playerLevelProgress.level.number;
    final round = '${matchProgress.currentRoundNumber}/${matchProgress.phase.roundCount}';
    return 'ReadyPreparationState(round: $round, stage: ${matchProgress.roundStage.name}, coins: ${player.coins}, level: $level, rejection: $rejection)';
  }
}
