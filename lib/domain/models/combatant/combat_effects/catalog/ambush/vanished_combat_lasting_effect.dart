import 'package:going_wild/domain/models/combatant/combat_effects/base/combat_effect_context.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/lasting/combat_lasting_effect.dart';

class VanishedCombatLastingEffect extends CombatLastingEffect {
  const VanishedCombatLastingEffect({
    required this.remainingTicks,
    required super.sourceCombatantId,
    required this.reappearNextToCombatantId,
  });

  final int remainingTicks;
  final int reappearNextToCombatantId;

  @override
  bool get preventsActing => true;

  @override
  bool get preventsBeingTargeted => true;

  @override
  VanishedCombatLastingEffect? createCopyAfterOneTick() {
    final remainingTicksAfterTick = remainingTicks - 1;
    if (remainingTicksAfterTick <= 0) return null;

    return VanishedCombatLastingEffect(
      sourceCombatantId: sourceCombatantId,
      remainingTicks: remainingTicksAfterTick,
      reappearNextToCombatantId: reappearNextToCombatantId,
    );
  }

  @override
  CombatEffectContext applyExpirationConsequences(CombatEffectContext context, int ownerCombatantId) {
    final reappearNextToCombatant = context.combatantWithId(reappearNextToCombatantId);
    final ownerCombatant = context.combatantWithId(ownerCombatantId);
    final anchorPosition = reappearNextToCombatant.isTargetable ? reappearNextToCombatant.position : ownerCombatant.position;
    final freePosition = context.pickRandomFreePositionClosestTo(anchorPosition);
    final reappearedContext = freePosition == null ? context : context.createCopyWithCombatantMovedTo(ownerCombatantId, freePosition);
    if (!reappearNextToCombatant.isTargetable) return reappearedContext;

    final reappearedCombatant = reappearedContext.combatantWithId(ownerCombatantId);
    return reappearedContext.createCopyWithCombatant(reappearedCombatant.createCopyWith(targetCombatantId: reappearNextToCombatantId));
  }
}
