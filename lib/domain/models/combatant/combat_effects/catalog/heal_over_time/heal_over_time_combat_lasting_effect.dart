import 'package:going_wild/domain/models/combatant/capabilities/heal.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/combat_effect_context.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/lasting/combat_lasting_effect.dart';

class HealOverTimeCombatLastingEffect extends CombatLastingEffect {
  const HealOverTimeCombatLastingEffect({
    required this.healPerSecond,
    required this.remainingTicks,
    required super.sourceCombatantId,
  });

  final int remainingTicks;
  final double healPerSecond;

  @override
  bool get healsOwnerOnTick => true;

  @override
  HealOverTimeCombatLastingEffect? createCopyAfterOneTick() {
    final remainingTicksAfterTick = remainingTicks - 1;
    if (remainingTicksAfterTick <= 0) return null;

    return HealOverTimeCombatLastingEffect(
      healPerSecond: healPerSecond,
      sourceCombatantId: sourceCombatantId,
      remainingTicks: remainingTicksAfterTick,
    );
  }

  @override
  CombatEffectContext applyTickConsequences(CombatEffectContext context, int ownerCombatantId) {
    return context.createCopyWithCombatant(
      heal(context.combatantWithId(ownerCombatantId), healAmount: healPerSecond * context.tickSeconds),
    );
  }
}
