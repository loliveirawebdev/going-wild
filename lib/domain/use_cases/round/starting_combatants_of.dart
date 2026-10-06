import 'package:going_wild/domain/models/combatant/combatant.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';

List<Combatant> startingCombatantsOf(MatchProgress matchProgress) => matchProgress.phase.engines.combatEngine.startingCombatantsOf(
  enemies: matchProgress.currentWave.enemies,
  team: matchProgress.playerRoster.placements,
);
