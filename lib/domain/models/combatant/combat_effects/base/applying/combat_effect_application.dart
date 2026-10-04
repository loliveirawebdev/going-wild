import 'package:going_wild/domain/models/combatant/combat_effects/base/applying/combat_effect_targeting.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/combat_effect_context.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/combat_effect_target.dart';
import 'package:going_wild/domain/models/combatant/combatant.dart';
import 'package:meta/meta.dart';

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
  List<Combatant> targetsOf(CombatEffectTarget effectTarget) {
    final targeting = CombatEffectTargeting(context: context, sourceCombatant: sourceCombatant);
    return effectTarget.resolve(targeting);
  }

  bool get hasKilledAnyCombatant => aliveCombatantIdsBeforeApplication.any((combatantId) => !context.combatantWithId(combatantId).isAlive);
}
