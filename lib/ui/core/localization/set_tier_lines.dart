import 'package:going_wild/domain/models/character/stats/stat_change_type.dart';
import 'package:going_wild/domain/models/character/stats/stat_modification.dart';
import 'package:going_wild/domain/models/set/effects/set_bonus_coins_per_round.dart';
import 'package:going_wild/domain/models/set/effects/set_starting_shield.dart';
import 'package:going_wild/domain/models/set/effects/set_stat_modification.dart';
import 'package:going_wild/domain/models/set/set_effect.dart';
import 'package:going_wild/domain/models/set/set_target.dart';
import 'package:going_wild/domain/models/set/set_tier.dart';
import 'package:going_wild/domain/models/set/targets/all_enemies_set_target.dart';
import 'package:going_wild/domain/models/set/targets/entire_team_set_target.dart';
import 'package:going_wild/domain/models/set/targets/set_members_set_target.dart';
import 'package:going_wild/domain/models/set/targets/specific_character_set_target.dart';
import 'package:going_wild/domain/models/set/targets/team_melees_set_target.dart';
import 'package:going_wild/domain/models/set/targets/team_rangeds_set_target.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/localization/character_name.dart';

List<String> setTierLinesOf(Translations translations, SetTier tier) {
  final effectTextsByTarget = <SetTarget?, List<String>>{};

  for (final effect in tier.effects) {
    final effectText = _effectTextOf(translations, effect);
    if (effectText != null) effectTextsByTarget.putIfAbsent(effect.target, () => []).add(effectText);
  }

  return [
    for (final MapEntry(key: target, value: effectTexts) in effectTextsByTarget.entries)
      _targetedTextOf(translations, target, effectTexts.join(translations.setEffects.joiner)),
  ];
}

String _formattedNumberOf(double number) => number == number.roundToDouble() ? '${number.round()}' : number.toStringAsFixed(1);

String? _effectTextOf(Translations translations, SetEffect effect) => switch (effect) {
  SetStatModification(:final statModification) => _statModificationTextOf(translations, statModification),
  SetBonusCoinsPerRound(:final coins) => translations.setEffects.bonusCoins(coins: coins),
  SetStartingShield(:final value, :final seconds) => translations.setEffects.startingShield(
    value: _formattedNumberOf(value),
    seconds: _formattedNumberOf(seconds),
  ),
  _ => null,
};

String _statModificationTextOf(Translations translations, StatModification statModification) {
  final effectTexts = translations.setEffects;
  final statName = translations['setEffects.stats.${statModification.stat.name}'] as String? ?? statModification.stat.name;
  final value = statModification.value;

  switch (statModification.changeType) {
    case StatChangeType.multiplier:
      final percent = ((value - 1) * 100).round();
      if (percent >= 0) return effectTexts.percentIncrease(percent: percent, stat: statName);
      return effectTexts.percentDecrease(percent: -percent, stat: statName);

    case StatChangeType.absoluteValue:
      if (value >= 0) return effectTexts.valueIncrease(value: _formattedNumberOf(value), stat: statName);
      return effectTexts.valueDecrease(value: _formattedNumberOf(-value), stat: statName);
  }
}

String _targetedTextOf(Translations translations, SetTarget? target, String effects) {
  final targetTexts = translations.setEffects.targets;

  return switch (target) {
    EntireTeamSetTarget() => targetTexts.entireTeam(effects: effects),
    TeamMeleesSetTarget() => targetTexts.teamMelees(effects: effects),
    SetMembersSetTarget() => targetTexts.setMembers(effects: effects),
    AllEnemiesSetTarget() => targetTexts.allEnemies(effects: effects),
    TeamRangedsSetTarget() => targetTexts.teamRangeds(effects: effects),
    SpecificCharacterSetTarget(:final character) => targetTexts.specificCharacter(
      effects: effects,
      name: characterNameOf(translations, character),
    ),
    _ => effects,
  };
}
