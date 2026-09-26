import '../../base/combat_effect_context.dart';
import '../../base/lasting/combat_lasting_effect.dart';

class TauntCombatLastingEffect extends CombatLastingEffect {
  const TauntCombatLastingEffect({required this.remainingTicks, required super.sourceCombatantId});
  final int remainingTicks;

  @override
  int? get forcedTargetCombatantId => sourceCombatantId;

  @override
  bool expiresEarly(CombatEffectContext context) => !context.combatantWithId(sourceCombatantId).isTargetable;

  @override
  TauntCombatLastingEffect? createCopyAfterOneTick() {
    final remainingTicksAfterTick = remainingTicks - 1;
    if (remainingTicksAfterTick <= 0) return null;
    return TauntCombatLastingEffect(remainingTicks: remainingTicksAfterTick, sourceCombatantId: sourceCombatantId);
  }
}
