class MatchIsOverError extends StateError {
  MatchIsOverError() : super('The match is over and accepts no more actions');
}
