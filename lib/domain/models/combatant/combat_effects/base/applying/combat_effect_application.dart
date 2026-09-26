import 'package:meta/meta.dart';

import '../combat_effect_context.dart';
import '../../../combatant.dart';
import '../combat_effect_target.dart';
import 'resolve_combat_effect_targets.dart';

class CombatEffectApplication {
  const CombatEffectApplication({
    required this.context,
    required this.sourceCombatantId,
    required this.aliveCombatantIdsBeforeApplication,
  });

  final CombatEffectContext context;
  final int sourceCombatantId;
  final Set<int> aliveCombatantIdsBeforeApplication;

  @useResult
  CombatEffectApplication createCopyWithContext(CombatEffectContext context) => CombatEffectApplication(
    context: context,
    sourceCombatantId: sourceCombatantId,
    aliveCombatantIdsBeforeApplication: aliveCombatantIdsBeforeApplication,
  );

  int get stars => sourceCombatant.characterCopy.stars;
  Combatant get sourceCombatant => context.combatantWithId(sourceCombatantId);
  List<Combatant> targetsOf(CombatEffectTarget effectTarget) => resolveCombatEffectTargets(context, sourceCombatant, effectTarget);
  bool get hasKilledAnyCombatant => aliveCombatantIdsBeforeApplication.any((combatantId) => !context.combatantWithId(combatantId).isAlive);
}
