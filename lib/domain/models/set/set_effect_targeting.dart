import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/domain/models/character/stats/stats.dart';
import 'package:going_wild/domain/models/set/set_effect_side.dart';
import 'package:going_wild/domain/models/set/team_set.dart';

class SetEffectTargeting {
  const SetEffectTargeting({required this.set, required this.side, required this.stats, required this.character});

  final TeamSet set;
  final Stats stats;
  final SetEffectSide side;
  final Character character;

  bool get isOwnTeam => side == SetEffectSide.ownTeam;
}
