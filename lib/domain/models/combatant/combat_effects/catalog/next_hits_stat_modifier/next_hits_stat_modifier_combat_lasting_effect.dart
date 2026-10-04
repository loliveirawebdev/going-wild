import 'package:going_wild/domain/models/character/stats/stat_modification.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/lasting/combat_lasting_effect.dart';

class NextHitsStatModifierCombatLastingEffect extends CombatLastingEffect {
  const NextHitsStatModifierCombatLastingEffect({
    required this.remainingHits,
    required this.statModification,
    required super.sourceCombatantId,
  });

  final int remainingHits;

  @override
  final StatModification statModification;

  @override
  CombatLastingEffect? createCopyAfterAttackLanded() {
    final remainingHitsAfterAttack = remainingHits - 1;
    if (remainingHitsAfterAttack <= 0) return null;

    return NextHitsStatModifierCombatLastingEffect(
      statModification: statModification,
      sourceCombatantId: sourceCombatantId,
      remainingHits: remainingHitsAfterAttack,
    );
  }
}
