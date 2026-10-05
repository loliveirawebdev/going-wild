import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';

abstract final class AppShadows {
  static const double pressOffset = 4;

  static const List<BoxShadow> pressNeutral = [BoxShadow(color: AppColors.surface400, offset: Offset(0, pressOffset))];
  static const List<BoxShadow> pressGrass = [BoxShadow(color: AppColors.grass600, offset: Offset(0, pressOffset))];
  static const List<BoxShadow> pressBarn = [BoxShadow(color: AppColors.barn800, offset: Offset(0, pressOffset))];
  static const List<BoxShadow> pressSun = [BoxShadow(color: AppColors.sun600, offset: Offset(0, pressOffset))];
  static const List<BoxShadow> float = [BoxShadow(blurRadius: 20, offset: Offset(0, 8), color: Color(0x293A2414))];
}
