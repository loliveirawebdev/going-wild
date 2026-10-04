import 'package:going_wild/domain/models/character/stats/stat_modification.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/lasting/combat_lasting_effect.dart';

class StatModifierCombatLastingEffect extends CombatLastingEffect {
  const StatModifierCombatLastingEffect({required this.remainingTicks, required this.statModification, required super.sourceCombatantId});

  final int remainingTicks;

  @override
  final StatModification statModification;

  StatModifierCombatLastingEffect createCopyWithRemainingTicks(int remainingTicks) => StatModifierCombatLastingEffect(
    remainingTicks: remainingTicks,
    statModification: statModification,
    sourceCombatantId: sourceCombatantId,
  );

  @override
  StatModifierCombatLastingEffect? createCopyAfterOneTick() {
    final remainingTicksAfterTick = remainingTicks - 1;
    if (remainingTicksAfterTick <= 0) return null;
    return createCopyWithRemainingTicks(remainingTicksAfterTick);
  }
}
