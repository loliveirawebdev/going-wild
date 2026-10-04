import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/combat_effect.dart';
import 'package:going_wild/domain/models/combatant/combatant.dart';
import 'package:going_wild/domain/models/combatant/faction.dart';
import 'package:meta/meta.dart';

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
  CombatEffectContext createCopyWithDamageDealt({
    required int targetCombatantId,
    required double damageAmount,
    required int? sourceCombatantId,
  });
  @useResult
  CombatEffectContext createCopyWithCombatEffectsScheduled({required int sourceCombatantId, required List<CombatEffect> effects});
}
