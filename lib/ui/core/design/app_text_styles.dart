import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';

abstract final class AppFonts {
  static const String sans = 'Nunito';
  static const String display = 'LilitaOne';
}

abstract final class AppTextStyles {
  static const TextStyle displayExtraLarge = TextStyle(
    height: 1.1,
    fontSize: 40,
    color: AppColors.ink,
    fontFamily: AppFonts.display,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle title = TextStyle(
    fontSize: 28,
    height: 1.1429,
    color: AppColors.ink,
    fontFamily: AppFonts.display,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle number = TextStyle(
    height: 1.2,
    fontSize: 20,
    letterSpacing: 0.5,
    color: AppColors.ink,
    fontFamily: AppFonts.display,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle heading = TextStyle(
    fontSize: 18,
    height: 1.3333,
    color: AppColors.ink,
    fontFamily: AppFonts.sans,
    fontWeight: FontWeight.w900,
  );

  static const TextStyle body = TextStyle(
    height: 1.4,
    fontSize: 15,
    color: AppColors.ink,
    fontFamily: AppFonts.sans,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle bodyStrong = TextStyle(
    height: 1.4,
    fontSize: 15,
    color: AppColors.ink,
    fontFamily: AppFonts.sans,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle tag = TextStyle(
    fontSize: 12,
    height: 16 / 12,
    color: AppColors.ink,
    fontFamily: AppFonts.sans,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 11,
    height: 14 / 11,
    color: AppColors.inkMuted,
    fontFamily: AppFonts.sans,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle overline = TextStyle(
    fontSize: 11,
    height: 14 / 11,
    letterSpacing: 0.6,
    color: AppColors.inkMuted,
    fontFamily: AppFonts.sans,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle label = TextStyle(
    fontSize: 12,
    height: 1.3333,
    letterSpacing: 0.6,
    color: AppColors.ink,
    fontFamily: AppFonts.sans,
    fontWeight: FontWeight.w800,
  );
}
