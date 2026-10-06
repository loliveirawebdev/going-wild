import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/domain/models/character/stats/stat.dart';
import 'package:going_wild/domain/models/character/stats/stat_change_type.dart';
import 'package:going_wild/domain/models/character/stats/stat_modification.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/damage_over_time/damage_over_time_combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/shield/shield_combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/stat_modifier/stat_modifier_combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/stun/stun_combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/taunt/taunt_combat_lasting_effect.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/game/widgets/unit_sheet/combat_effect_badges.dart';

StatModifierCombatLastingEffect statModifierOf(Stat stat, double value, StatChangeType changeType) => StatModifierCombatLastingEffect(
  remainingTicks: 3,
  sourceCombatantId: 2,
  statModification: StatModification(stat: stat, value: value, changeType: changeType),
);

void main() {
  test('each kind of lasting effect shows once, a shield shows none, and taking more damage counts as weakened', () {
    final badges = combatEffectBadgesOf(AppLocale.pt.buildSync(), [
      const StunCombatLastingEffect(remainingTicks: 3, sourceCombatantId: 2),
      const DamageOverTimeCombatLastingEffect(remainingTicks: 3, damagePerSecond: 5, sourceCombatantId: 2),
      const DamageOverTimeCombatLastingEffect(remainingTicks: 3, damagePerSecond: 5, sourceCombatantId: 3),
      const TauntCombatLastingEffect(remainingTicks: 3, sourceCombatantId: 4),
      const ShieldCombatLastingEffect(onExpire: [], remainingTicks: 3, remainingShield: 40, sourceCombatantId: 1),
      statModifierOf(Stat.damage, 1.2, StatChangeType.multiplier),
      statModifierOf(Stat.damageTakenPercentage, 1.2, StatChangeType.multiplier),
    ]);

    expect([for (final badge in badges) badge.label], ['Atordoado', 'Envenenado', 'Provocado', 'Fortalecido', 'Enfraquecido']);
  });
}
