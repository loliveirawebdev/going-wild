import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';
import 'package:going_wild/ui/core/design/app_theme.dart';

void main() {
  test('the day theme paints the cream background and uses grass as the primary action', () {
    final theme = AppTheme.day();

    expect(theme.scaffoldBackgroundColor, AppColors.surface100);
    expect(theme.colorScheme.primary, AppColors.grass400);
    expect(theme.colorScheme.onPrimary, AppColors.ink);
    expect(theme.colorScheme.error, AppColors.danger);
    expect(theme.appBarTheme.scrolledUnderElevation, 0);
  });

  test('titles and game numbers use Lilita One and the rest uses Nunito no thinner than 600', () {
    final theme = AppTheme.day();

    expect(theme.textTheme.titleLarge!.fontFamily, AppFonts.display);
    expect(AppTextStyles.number.fontFamily, AppFonts.display);
    expect(theme.textTheme.bodyMedium!.fontFamily, AppFonts.sans);
    expect(theme.textTheme.bodyMedium!.fontWeight!.value, greaterThanOrEqualTo(600));
    expect(theme.textTheme.labelSmall!.fontWeight!.value, greaterThanOrEqualTo(600));
  });
}
