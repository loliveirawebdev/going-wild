import '../base/stats.dart';
import '../character/merge_curve.dart';
import '../character/role.dart';
import '../combat/battle_rules.dart';
import '../combat/board/board.dart';
import '../set/team_set.dart';
import '../shop/shop_rules.dart';

class PhaseRules {
  const PhaseRules({
    required this.board,
    required this.sets,
    required this.baseStats,
    required this.shopRules,
    required this.battleRules,
    required this.mergeCurveFor,
    required this.benchSize,
    required this.startingPlayerLives,
  });

  final Board board;
  final int benchSize;
  final Stats baseStats;
  final int startingPlayerLives;
  final ShopRules shopRules;
  final List<TeamSet> sets;
  final BattleRules battleRules;
  final MergeCurve Function(Role role) mergeCurveFor;
}
