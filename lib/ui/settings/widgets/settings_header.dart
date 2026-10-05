import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';
import 'package:going_wild/ui/core/design/interface_glyph.dart';
import 'package:going_wild/ui/core/widgets/round_icon_button.dart';

const _titleStyle = TextStyle(
  fontSize: 28,
  height: 32 / 28,
  color: AppColors.ink,
  fontWeight: FontWeight.w400,
  fontFamily: AppFonts.display,
);

class SettingsHeader extends StatelessWidget {
  final String title;
  const SettingsHeader({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.space1),
      child: Row(
        spacing: AppSpacing.space2,
        children: [
          RoundIconButton(
            glyph: InterfaceGlyph.back,
            onPressed: () => context.pop(),
            size: RoundIconButtonSize.extraSmall,
            label: context.t.settings.backButton,
          ),
          Expanded(child: Text(title, style: _titleStyle)),
        ],
      ),
    );
  }
}
