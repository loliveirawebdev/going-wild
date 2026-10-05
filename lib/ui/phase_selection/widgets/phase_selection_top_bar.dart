import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';
import 'package:going_wild/ui/core/design/interface_glyph.dart';
import 'package:going_wild/ui/core/widgets/round_icon_button.dart';

const _backButtonSlotWidth = 30.0;

const _titleStyle = TextStyle(
  fontSize: 28,
  height: 32 / 28,
  color: AppColors.onPrimary,
  fontFamily: AppFonts.display,
  fontWeight: FontWeight.w400,
  shadows: [Shadow(color: AppColors.wood700, offset: Offset(0, 2))],
);

class PhaseSelectionTopBar extends StatelessWidget {
  const PhaseSelectionTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final translations = context.t.phaseSelection;
    final safeAreaTop = MediaQuery.paddingOf(context).top;

    return Padding(
      padding: EdgeInsets.fromLTRB(AppSpacing.space4, safeAreaTop + AppSpacing.space3, AppSpacing.space4, 0),
      child: Row(
        spacing: AppSpacing.space3,
        children: [
          RoundIconButton(
            glyph: InterfaceGlyph.back,
            onPressed: () => context.pop(),
            label: translations.backButton,
            size: RoundIconButtonSize.extraSmall,
          ),
          Expanded(
            child: Text(translations.title, textAlign: TextAlign.center, style: _titleStyle),
          ),
          const SizedBox(width: _backButtonSlotWidth),
        ],
      ),
    );
  }
}
