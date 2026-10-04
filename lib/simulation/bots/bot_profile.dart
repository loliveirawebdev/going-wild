import 'dart:math';

import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:meta/meta.dart';

typedef ShoppingStrategy = MatchProgress Function(MatchProgress matchProgress, Random randomGenerator);
typedef PlacementStrategy = MatchProgress Function(MatchProgress matchProgress, Random randomGenerator);

class BotProfile {
  const BotProfile({required this.name, required this.shopping, required this.placement, required this.description});

  final String name;
  final String description;
  final ShoppingStrategy shopping;
  final PlacementStrategy placement;

  @useResult
  MatchProgress playRound(MatchProgress matchProgress, Random randomGenerator) {
    final shoppedMatchProgress = shopping(matchProgress, randomGenerator);
    return placement(shoppedMatchProgress, randomGenerator);
  }

  @override
  String toString() => 'BotProfile($name)';
}
