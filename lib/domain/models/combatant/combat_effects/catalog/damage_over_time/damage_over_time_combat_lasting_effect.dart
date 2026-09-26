import '../../base/combat_effect_context.dart';
import '../../base/lasting/combat_lasting_effect.dart';

class DamageOverTimeCombatLastingEffect extends CombatLastingEffect {
  const DamageOverTimeCombatLastingEffect({
    required this.remainingTicks,
    required this.damagePerSecond,
    required super.sourceCombatantId,
  });

  final int remainingTicks;
  final double damagePerSecond;

  @override
  bool get damagesOwnerOnTick => true;

  @override
  DamageOverTimeCombatLastingEffect? createCopyAfterOneTick() {
    final remainingTicksAfterTick = remainingTicks - 1;
    if (remainingTicksAfterTick <= 0) return null;

    return DamageOverTimeCombatLastingEffect(
      damagePerSecond: damagePerSecond,
      sourceCombatantId: sourceCombatantId,
      remainingTicks: remainingTicksAfterTick,
    );
  }

  @override
  CombatEffectContext applyTickConsequences(CombatEffectContext context, int ownerCombatantId) {
    return context.createCopyWithDamageDealt(
      targetCombatantId: ownerCombatantId,
      damageAmount: damagePerSecond * context.tickSeconds,
    );
  }
}
