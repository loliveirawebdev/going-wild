import 'package:going_wild/domain/models/character/stats/stat_change_type.dart';
import 'package:going_wild/domain/models/character/stats/stat_modification.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/localization/formatted_number.dart';

String statChangeTextOf(Translations translations, StatModification statModification) {
  final value = statModification.value;
  final effectTexts = translations.setEffects;
  final statName = translations['setEffects.stats.${statModification.stat.name}'] as String? ?? statModification.stat.name;

  switch (statModification.changeType) {
    case StatChangeType.multiplier:
      final percent = ((value - 1) * 100).round();
      if (percent >= 0) return effectTexts.percentIncrease(percent: percent, stat: statName);
      return effectTexts.percentDecrease(percent: -percent, stat: statName);

    case StatChangeType.absoluteValue:
      if (value >= 0) return effectTexts.valueIncrease(value: formattedNumberOf(translations, value), stat: statName);
      return effectTexts.valueDecrease(value: formattedNumberOf(translations, -value), stat: statName);
  }
}
