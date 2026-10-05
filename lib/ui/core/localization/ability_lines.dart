import 'package:going_wild/domain/models/character/abilities/ability.dart';
import 'package:going_wild/domain/models/character/abilities/ability_effect.dart';
import 'package:going_wild/domain/models/character/stats/stat_modification.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/combat_effect_target.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/targeted_combat_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/ambush/ambush_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/damage/damage_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/damage_over_time/damage_over_time_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/heal_over_time/heal_over_time_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/knockback/knockback_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/lifesteal/lifesteal_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/mana_refund_on_kill/mana_refund_on_kill_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/next_hits_stat_modifier/next_hits_stat_modifier_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/pull/pull_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/shield/shield_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/stat_modifier/stat_modifier_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/stun/stun_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/taunt/taunt_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/targets/all_enemies_target.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/targets/enemies_around_focus_target.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/targets/farthest_enemy_target.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/targets/focus_target.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/targets/lowest_health_ally_target.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/targets/lowest_health_enemy_target.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/targets/nearby_allies_target.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/targets/nearby_enemies_target.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/targets/self_target.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/localization/formatted_number.dart';
import 'package:going_wild/ui/core/localization/stat_change_text.dart';

List<String> abilityLinesOf(Translations translations, Ability ability, {required int stars}) =>
    _effectLinesOf(translations, ability.effects, stars: stars);

List<String> _effectLinesOf(Translations translations, List<AbilityEffect> effects, {required int stars}) {
  final effectTextsByTarget = <CombatEffectTarget, List<String>>{};
  final untargetedLines = <String>[];
  final followUpLines = <String>[];

  for (final effect in effects) {
    final effectText = _effectTextOf(translations, effect, stars: stars);

    if (effect is ShieldEffect && effect.onExpire.isNotEmpty) {
      final expiryEffects = _listedTextOf(translations, _effectLinesOf(translations, effect.onExpire, stars: stars));
      followUpLines.add(translations.abilityEffects.onShieldExpire(effects: expiryEffects));
    }

    if (effectText == null) continue;
    if (effect is TargetedCombatEffect) {
      effectTextsByTarget.putIfAbsent(effect.target, () => []).add(effectText);
      continue;
    }

    untargetedLines.add(effectText);
  }

  return [
    for (final MapEntry(key: target, value: effectTexts) in effectTextsByTarget.entries)
      translations.abilityEffects.targeted(
        target: _targetNameOf(translations, target),
        effects: _listedTextOf(translations, effectTexts),
      ),
    ...followUpLines,
    ...untargetedLines,
  ];
}

String _listedTextOf(Translations translations, List<String> texts) {
  if (texts.length < 2) return texts.join();
  final leadingTexts = texts.sublist(0, texts.length - 1).join(translations.abilityEffects.joiner);
  return '$leadingTexts${translations.abilityEffects.lastJoiner}${texts.last}';
}

String? _effectTextOf(Translations translations, AbilityEffect effect, {required int stars}) {
  final effectTexts = translations.abilityEffects;
  String numberOf(double number) => formattedNumberOf(translations, number);

  return switch (effect) {
    PullEffect() => effectTexts.pull,

    KnockbackEffect(:final cells) => effectTexts.knockback(
      cells: cells,
    ),

    DamageEffect(:final value) => effectTexts.damage(
      value: numberOf(value.at(stars)),
    ),

    StunEffect(:final seconds) => effectTexts.stun(
      seconds: numberOf(seconds.at(stars)),
    ),

    TauntEffect(:final seconds) => effectTexts.taunt(
      seconds: numberOf(seconds.at(stars)),
    ),

    AmbushEffect(:final seconds) => effectTexts.ambush(
      seconds: numberOf(seconds.at(stars)),
    ),

    LifestealEffect(:final value) => effectTexts.lifesteal(
      value: numberOf(value.at(stars)),
    ),

    ManaRefundOnKillEffect(:final percentage) => effectTexts.manaRefundOnKill(
      percentage: percentage,
    ),

    ShieldEffect(:final value, :final seconds) => effectTexts.shield(
      value: numberOf(value.at(stars)),
      seconds: numberOf(seconds.at(stars)),
    ),

    DamageOverTimeEffect(:final damagePerSecond, :final seconds) => effectTexts.damageOverTime(
      value: numberOf(damagePerSecond.at(stars)),
      seconds: numberOf(seconds.at(stars)),
    ),

    HealOverTimeEffect(:final healPerSecond, :final seconds) => effectTexts.healOverTime(
      value: numberOf(healPerSecond.at(stars)),
      seconds: numberOf(seconds.at(stars)),
    ),

    StatModifierEffect(:final stat, :final value, :final changeType, :final seconds) => effectTexts.timedChange(
      seconds: numberOf(seconds.at(stars)),
      change: statChangeTextOf(translations, StatModification(stat: stat, value: value.at(stars), changeType: changeType)),
    ),

    NextHitsStatModifierEffect(:final stat, :final value, :final changeType, :final hits) => effectTexts.nextHitsChange(
      hits: hits,
      change: statChangeTextOf(translations, StatModification(stat: stat, value: value.at(stars), changeType: changeType)),
    ),

    _ => null,
  };
}

String _targetNameOf(Translations translations, CombatEffectTarget target) {
  final targetNames = translations.abilityEffects.targets;

  return switch (target) {
    SelfTarget() => targetNames.self,
    FocusTarget() => targetNames.focus,
    AllEnemiesTarget() => targetNames.allEnemies,
    NearbyAlliesTarget() => targetNames.nearbyAllies,
    FarthestEnemyTarget() => targetNames.farthestEnemy,
    NearbyEnemiesTarget() => targetNames.nearbyEnemies,
    LowestHealthAllyTarget() => targetNames.lowestHealthAlly,
    LowestHealthEnemyTarget() => targetNames.lowestHealthEnemy,
    EnemiesAroundFocusTarget() => targetNames.enemiesAroundFocus,
    _ => targetNames.focus,
  };
}
