import 'package:flutter/widgets.dart';
import 'package:going_wild/domain/models/character/rarity.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';

Color rarityColorOf(Rarity rarity) => switch (rarity) {
  Rarity.common => AppColors.rarityCommon,
  Rarity.uncommon => AppColors.rarityUncommon,
  Rarity.rare => AppColors.rarityRare,
  Rarity.epic => AppColors.rarityEpic,
};
