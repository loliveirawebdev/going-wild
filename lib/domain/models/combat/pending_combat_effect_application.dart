import 'package:going_wild/domain/models/combatant/combat_effects/base/combat_effect.dart';

class PendingCombatEffectApplication {
  const PendingCombatEffectApplication({required this.sourceCombatantId, required this.effects});

  final int sourceCombatantId;
  final List<CombatEffect> effects;
}
