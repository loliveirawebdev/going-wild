import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/combat/combat.dart';
import 'package:going_wild/domain/models/combat/combatant_actions/deal_damage.dart';
import 'package:going_wild/domain/models/combat/pending_combat_effect_application.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/combat_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/combat_effect_context.dart';
import 'package:going_wild/domain/models/combatant/combatant.dart';
import 'package:going_wild/domain/models/combatant/faction.dart';
import 'package:meta/meta.dart';

class CombatContext implements CombatEffectContext {
  const CombatContext({required this.combat});
  final Combat combat;

  @override
  double get tickSeconds => combat.rules.tickSeconds;

  @override
  int get nearbyRadius => combat.rules.nearbyRadius;

  @override
  int convertSecondsToTicks(double seconds) {
    return combat.rules.convertSecondsToTicks(seconds);
  }

  @override
  Combatant combatantWithId(int combatantId) {
    return combat.battlefield.combatantWithId(combatantId);
  }

  @override
  Iterable<Combatant> aliveCombatantsFromFaction(Faction faction) {
    return combat.battlefield.aliveCombatantsFromFaction(faction);
  }

  @override
  Iterable<Combatant> targetableCombatantsFromFaction(Faction faction) {
    return combat.battlefield.targetableCombatantsFromFaction(faction);
  }

  @override
  bool isPositionFree(Position position) {
    return combat.battlefield.isPositionFree(position);
  }

  @override
  Position? pickRandomFreePositionClosestTo(Position origin) {
    return combat.battlefield.pickRandomFreePositionClosestTo(
      origin,
      combat.randomGenerator,
    );
  }

  @override
  @useResult
  CombatContext createCopyWithCombatant(Combatant updatedCombatant) {
    return CombatContext(combat: combat.createCopyWithCombatant(updatedCombatant));
  }

  @override
  @useResult
  CombatContext createCopyWithCombatantMovedTo(int combatantId, Position position) {
    return CombatContext(combat: combat.createCopyWithCombatantMovedTo(combatantId, position));
  }

  @override
  @useResult
  CombatContext createCopyWithDamageDealt({
    required int targetCombatantId,
    required double damageAmount,
    required int? sourceCombatantId,
  }) {
    return CombatContext(
      combat: dealDamageToCombatant(
        combat,
        damageAmount: damageAmount,
        targetCombatantId: targetCombatantId,
        sourceCombatantId: sourceCombatantId,
      ),
    );
  }

  @override
  @useResult
  CombatContext createCopyWithCombatEffectsScheduled({required int sourceCombatantId, required List<CombatEffect> effects}) {
    final pendingApplication = PendingCombatEffectApplication(sourceCombatantId: sourceCombatantId, effects: effects);
    final pendingApplications = [...combat.pendingCombatEffectApplications, pendingApplication];
    return CombatContext(combat: combat.createCopyWith(pendingCombatEffectApplications: pendingApplications));
  }
}
