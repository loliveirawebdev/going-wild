import 'package:flutter/material.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';

abstract final class AppTheme {
  static ThemeData day() => ThemeData(
    useMaterial3: true,
    fontFamily: AppFonts.sans,
    dividerColor: AppColors.surface300,
    canvasColor: AppColors.surface100,
    highlightColor: Colors.transparent,
    splashFactory: NoSplash.splashFactory,
    scaffoldBackgroundColor: AppColors.surface100,

    textTheme: const TextTheme(
      bodyLarge: AppTextStyles.body,
      bodyMedium: AppTextStyles.body,
      titleLarge: AppTextStyles.title,
      labelSmall: AppTextStyles.label,
      labelMedium: AppTextStyles.label,
      titleMedium: AppTextStyles.heading,
      labelLarge: AppTextStyles.bodyStrong,
      headlineMedium: AppTextStyles.title,
      displayLarge: AppTextStyles.displayExtraLarge,
    ),

    colorScheme: const ColorScheme(
      shadow: AppColors.ink,
      error: AppColors.danger,
      onError: AppColors.onPrimary,
      onPrimary: AppColors.ink,
      onTertiary: AppColors.ink,
      onSurface: AppColors.ink,
      scrim: AppColors.wood700,
      onSecondary: AppColors.ink,
      primary: AppColors.grass400,
      outline: AppColors.outline,
      tertiary: AppColors.sky300,
      secondary: AppColors.sun400,
      surface: AppColors.surface100,
      brightness: Brightness.light,
      onPrimaryContainer: AppColors.ink,
      inverseSurface: AppColors.wood700,
      errorContainer: AppColors.fieldEnemy,
      onSurfaceVariant: AppColors.inkMuted,
      onErrorContainer: AppColors.barn800,
      inversePrimary: AppColors.grass600,
      outlineVariant: AppColors.surface400,
      onSecondaryContainer: AppColors.ink,
      primaryContainer: AppColors.fieldTeam,
      surfaceContainer: AppColors.surface200,
      onInverseSurface: AppColors.onPrimary,
      surfaceContainerLow: AppColors.surface100,
      surfaceContainerHigh: AppColors.surface200,
      secondaryContainer: AppColors.surface300,
      surfaceContainerLowest: AppColors.surface100,
      surfaceContainerHighest: AppColors.surface300,
    ),
  );
}
