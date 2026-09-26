import '../../base/lasting/combat_lasting_effect.dart';

class StunCombatLastingEffect extends CombatLastingEffect {
  const StunCombatLastingEffect({required this.remainingTicks, required super.sourceCombatantId});
  final int remainingTicks;

  @override
  bool get preventsActing => true;

  StunCombatLastingEffect createCopyWithRemainingTicks(int remainingTicks) =>
      StunCombatLastingEffect(remainingTicks: remainingTicks, sourceCombatantId: sourceCombatantId);

  @override
  StunCombatLastingEffect? createCopyAfterOneTick() {
    final remainingTicksAfterTick = remainingTicks - 1;
    if (remainingTicksAfterTick <= 0) return null;
    return createCopyWithRemainingTicks(remainingTicksAfterTick);
  }
}
