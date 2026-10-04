import 'package:going_wild/domain/models/character/stars/star_values.dart';
import 'package:going_wild/domain/models/combatant/capabilities/add_combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/applying/combat_effect_application.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/combat_effect_context.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/targeted_combat_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/ambush/vanished_combat_lasting_effect.dart';

class AmbushEffect extends TargetedCombatEffect {
  const AmbushEffect({required super.target, required this.seconds});
  final StarValues seconds;

  @override
  CombatEffectContext apply(CombatEffectApplication application) {
    final anchorCombatant = application.targetsOf(target).firstOrNull;
    if (anchorCombatant == null) return application.context;

    return application.context.createCopyWithCombatant(
      addCombatLastingEffect(
        application.sourceCombatant,

        VanishedCombatLastingEffect(
          reappearNextToCombatantId: anchorCombatant.id,
          sourceCombatantId: application.sourceCombatantId,
          remainingTicks: application.context.convertSecondsToTicks(seconds.at(application.stars)),
        ),
      ),
    );
  }
}
