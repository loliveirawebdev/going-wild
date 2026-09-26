import 'package:meta/meta.dart';

import '../../../board/position.dart';
import '../../combatant.dart';
import '../../faction.dart';
import 'combat_effect.dart';

abstract class CombatEffectContext {
  int get nearbyRadius;
  double get tickSeconds;
  int convertSecondsToTicks(double seconds);

  bool isPositionFree(Position position);
  Combatant combatantWithId(int combatantId);
  Iterable<Combatant> aliveCombatantsFromFaction(Faction faction);
  Iterable<Combatant> targetableCombatantsFromFaction(Faction faction);
  Position? pickRandomFreePositionClosestTo(Position origin);

  @useResult
  CombatEffectContext createCopyWithCombatant(Combatant updatedCombatant);
  @useResult
  CombatEffectContext createCopyWithCombatantMovedTo(int combatantId, Position position);
  @useResult
  CombatEffectContext createCopyWithDamageDealt({required int targetCombatantId, required double damageAmount});
  @useResult
  CombatEffectContext createCopyWithCombatEffectsScheduled({required int sourceCombatantId, required List<CombatEffect> effects});
}
