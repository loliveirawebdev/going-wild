import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';

enum SetChipTone {
  inactive(faceColor: AppColors.surface300, edgeColor: AppColors.surface400),
  firstTier(faceColor: AppColors.grass400, edgeColor: AppColors.grass600),
  secondTier(faceColor: AppColors.sun400, edgeColor: AppColors.sun600);

  final Color faceColor;
  final Color edgeColor;
  const SetChipTone({required this.faceColor, required this.edgeColor});
  static SetChipTone ofReachedTierCount(int reachedTierCount) => values[reachedTierCount.clamp(0, values.length - 1)];
}
