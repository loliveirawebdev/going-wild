import 'package:going_wild/domain/models/combatant/combat_effects/base/lasting/combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/ambush/vanished_combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/damage_over_time/damage_over_time_combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/heal_over_time/heal_over_time_combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/stun/stun_combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/taunt/taunt_combat_lasting_effect.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/design/combat_effect_icon.dart';

typedef CombatEffectBadge = ({CombatEffectIcon icon, String label});

List<CombatEffectBadge> combatEffectBadgesOf(Translations translations, List<CombatLastingEffect> combatLastingEffects) {
  final badges = <CombatEffectBadge>[];

  for (final combatLastingEffect in combatLastingEffects) {
    final badge = _badgeOf(translations, combatLastingEffect);
    if (badge != null && !badges.contains(badge)) badges.add(badge);
  }

  return badges;
}

CombatEffectBadge? _badgeOf(Translations translations, CombatLastingEffect combatLastingEffect) {
  final labels = translations.game.unitSheet.effects;
  final statModification = combatLastingEffect.statModification;

  return switch (combatLastingEffect) {
    VanishedCombatLastingEffect() => (icon: CombatEffectIcon.ambush, label: labels.hidden),
    DamageOverTimeCombatLastingEffect() => (icon: CombatEffectIcon.poisoned, label: labels.poisoned),
    HealOverTimeCombatLastingEffect() => (icon: CombatEffectIcon.healing, label: labels.healing),
    StunCombatLastingEffect() => (icon: CombatEffectIcon.stunned, label: labels.stunned),
    TauntCombatLastingEffect() => (icon: CombatEffectIcon.taunting, label: labels.taunted),
    _ when statModification == null => null,
    _ when statModification.isBeneficial => (icon: CombatEffectIcon.buffed, label: labels.buffed),
    _ => (icon: CombatEffectIcon.debuffed, label: labels.debuffed),
  };
}
