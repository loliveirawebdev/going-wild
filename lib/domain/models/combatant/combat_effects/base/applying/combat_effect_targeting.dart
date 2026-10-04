import 'package:going_wild/domain/models/combatant/combat_effects/base/combat_effect_context.dart';
import 'package:going_wild/domain/models/combatant/combatant.dart';

class CombatEffectTargeting {
  CombatEffectTargeting({required this.context, required this.sourceCombatant});

  final Combatant sourceCombatant;
  final CombatEffectContext context;

  late final List<Combatant> allyCombatants = context.aliveCombatantsFromFaction(sourceCombatant.faction).toList();
  late final List<Combatant> enemyCombatants = context.targetableCombatantsFromFaction(sourceCombatant.faction.opposingFaction).toList();

  late final Combatant? focusCombatant = _targetableFocusCombatant();

  List<Combatant> combatantsNear(Combatant centerCombatant, List<Combatant> candidateCombatants) => [
    for (final candidateCombatant in candidateCombatants)
      if (candidateCombatant.position.distanceToPosition(centerCombatant.position) <= context.nearbyRadius) candidateCombatant,
  ];

  Combatant? _targetableFocusCombatant() {
    final focusCombatantId = sourceCombatant.targetCombatantId;
    if (focusCombatantId == null) return null;

    final focusCombatant = context.combatantWithId(focusCombatantId);
    return focusCombatant.isTargetable ? focusCombatant : null;
  }
}
