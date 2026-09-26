import 'package:meta/meta.dart';

import '../../combatant/combat_effects/base/applying/combat_effect_application.dart';
import '../../combatant/combat_effects/base/combat_effect.dart';
import '../combat.dart';
import '../combat_context.dart';

@useResult
Combat applyCombatEffects(Combat combat, {required int sourceCombatantId, required List<CombatEffect> effects}) {
  final aliveCombatantIdsBeforeApplication = {
    for (final combatant in combat.battlefield.combatants)
      if (combatant.isAlive) combatant.id,
  };

  var application = CombatEffectApplication(
    sourceCombatantId: sourceCombatantId,
    context: CombatContext(combat: combat),
    aliveCombatantIdsBeforeApplication: aliveCombatantIdsBeforeApplication,
  );

  for (final effect in effects) {
    final contextAfterEffect = effect.apply(application);
    application = application.createCopyWithContext(contextAfterEffect);
  }

  return (application.context as CombatContext).combat;
}
