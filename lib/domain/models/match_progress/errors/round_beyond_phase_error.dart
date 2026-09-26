class RoundBeyondPhaseError extends StateError {
  RoundBeyondPhaseError({required int roundNumber, required int roundCount})
    : super('Round $roundNumber does not exist in a phase of $roundCount rounds');
}
