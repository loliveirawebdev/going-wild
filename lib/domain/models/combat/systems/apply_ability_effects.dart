import '../../models.dart';
import '../battle.dart';
import '../unit/unit.dart';
import 'deal_damage.dart';
import 'effects/apply_ambush.dart';
import 'effects/apply_damage_over_time.dart';
import 'effects/apply_heal_over_time.dart';
import 'effects/apply_lifesteal.dart';
import 'effects/apply_next_hits_stat_modifier.dart';
import 'effects/apply_shield.dart';
import 'effects/apply_stat_modifier.dart';
import 'effects/apply_stun.dart';
import 'effects/apply_taunt.dart';
import 'effects/pull_next_to.dart';
import 'effects/push_away_from.dart';
import 'gain_mana.dart';
import 'resolve_effect_targets.dart';

void applyAbilityEffects(Battle battle, {required Unit casterUnit, required List<AbilityEffect> effects}) {
  var killedDuringCast = false;
  final stars = casterUnit.stars;
  List<Unit> targets(EffectTarget effectTarget) => resolveEffectTargets(battle, casterUnit, effectTarget);

  for (final effect in effects) {
    switch (effect) {
      case DamageEffect():
        for (final targetUnit in targets(effect.target)) {
          dealDamage(battle, sourceUnit: casterUnit, targetUnit: targetUnit, damageAmount: effect.value.at(stars));
          if (!targetUnit.isAlive) killedDuringCast = true;
        }

      case LifestealEffect():
        for (final targetUnit in targets(effect.target)) {
          applyLifesteal(battle, casterUnit, targetUnit, effect);
          if (!targetUnit.isAlive) killedDuringCast = true;
        }

      case ManaRefundOnKillEffect():
        if (killedDuringCast) {
          gainMana(
            battle,
            casterUnit,
            casterUnit.getCurrentStat(Stat.manaMax) * effect.percentage / 100,
          );
        }

      case DamageOverTimeEffect():
        for (final targetUnit in targets(effect.target)) {
          applyDamageOverTime(
            battle,
            casterUnit,
            targetUnit,
            effect,
          );
        }

      case HealEffect():
        for (final targetUnit in targets(effect.target)) {
          applyHealOverTime(
            battle,
            casterUnit,
            targetUnit,
            effect,
          );
        }

      case ShieldEffect():
        for (final targetUnit in targets(effect.target)) {
          applyShield(
            battle,
            casterUnit,
            targetUnit,
            effect,
          );
        }

      case StunEffect():
        for (final targetUnit in targets(effect.target)) {
          applyStun(
            battle,
            casterUnit,
            targetUnit,
            effect.seconds.at(stars),
          );
        }

      case TauntEffect():
        for (final targetUnit in targets(effect.target)) {
          applyTaunt(
            battle,
            casterUnit,
            targetUnit,
            effect.seconds.at(stars),
          );
        }

      case StatBuffEffect():
        for (final targetUnit in targets(effect.target)) {
          applyStatModifier(
            battle,
            casterUnit,
            targetUnit,
            stat: effect.stat,
            changeType: effect.changeType,
            value: effect.value,
            seconds: effect.seconds,
          );
        }

      case StatDebuffEffect():
        for (final targetUnit in targets(effect.target)) {
          applyStatModifier(
            battle,
            casterUnit,
            targetUnit,
            stat: effect.stat,
            changeType: effect.changeType,
            value: effect.value,
            seconds: effect.seconds,
          );
        }

      case NextHitsStatBuffEffect():
        for (final targetUnit in targets(effect.target)) {
          applyNextHitsStatModifier(
            battle,
            casterUnit,
            targetUnit,
            effect,
          );
        }

      case KnockbackEffect():
        for (final targetUnit in targets(effect.target)) {
          pushAwayFrom(
            battle,
            casterUnit,
            targetUnit,
            effect.cells,
          );
        }

      case PullEffect():
        for (final targetUnit in targets(effect.target)) {
          pullNextTo(
            battle,
            casterUnit,
            targetUnit,
          );
        }

      case AmbushEffect():
        final anchorUnit = targets(effect.target).firstOrNull;
        if (anchorUnit != null) applyAmbush(battle, casterUnit, anchorUnit, effect);
    }
  }
}
