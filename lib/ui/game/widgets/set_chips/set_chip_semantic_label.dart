import 'package:flutter/widgets.dart';
import 'package:going_wild/domain/models/set/set_presence.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/localization/set_name.dart';

String setChipSemanticLabelOf(BuildContext context, SetPresence setPresence) {
  final translations = context.t.game.setChips;
  final name = setNameOf(context.t, setPresence.set);
  final count = setPresence.presentMemberCount;
  final nextTier = setPresence.nextTier;

  if (setPresence.isComplete || nextTier == null) return translations.completeLabel(name: name, count: count);
  if (setPresence.reachedTierCount == 0) return translations.inactiveLabel(name: name, count: count, nextTierCount: nextTier.count);

  return translations.levelLabel(name: name, count: count, nextTierCount: nextTier.count, level: setPresence.reachedTierCount);
}
