import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_border_width.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';
import 'package:going_wild/ui/core/design/app_shadows.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';
import 'package:going_wild/ui/core/design/interface_glyph.dart';
import 'package:going_wild/ui/core/widgets/round_icon_button.dart';

const _maxDialogWidth = 380.0;
const _innerRadius = BorderRadius.all(Radius.circular(22 - AppBorderWidth.thick));
const _scrimColor = Color(0x733A2414);
const _openingDuration = Duration(milliseconds: 180);

const _titleStyle = TextStyle(
  fontSize: 24,
  height: 28 / 24,
  color: AppColors.onPrimary,
  fontFamily: AppFonts.display,
  fontWeight: FontWeight.w400,
);

Future<T?> presentDialog<T>(BuildContext context, {required Dialog dialog}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: true,
    barrierColor: _scrimColor,
    barrierLabel: dialog.closeLabel,
    transitionDuration: _openingDuration,
    pageBuilder: (context, animation, secondaryAnimation) => dialog,
    transitionBuilder: (context, animation, secondaryAnimation, dialog) => FadeTransition(
      opacity: animation,
      child: ScaleTransition(scale: Tween<double>(begin: 0.92, end: 1).animate(animation), child: dialog),
    ),
  );
}

class Dialog extends StatelessWidget {
  const Dialog({required this.body, required this.title, required this.actions, required this.closeLabel, super.key});

  final String body;
  final String title;
  final String closeLabel;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: AppTextStyles.body,
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.space4),
            child: Container(
              constraints: const BoxConstraints(maxWidth: _maxDialogWidth),
              decoration: BoxDecoration(
                color: AppColors.surface200,
                borderRadius: AppRadius.large,
                boxShadow: AppShadows.float,
                border: Border.all(color: AppColors.surface400, width: AppBorderWidth.thick),
              ),
              child: ClipRRect(
                borderRadius: _innerRadius,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _DialogHead(title: title, closeLabel: closeLabel),
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.space4),
                      child: Text(body, style: AppTextStyles.body),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(AppSpacing.space4, 0, AppSpacing.space4, AppSpacing.space4),
                      child: Wrap(
                        spacing: AppSpacing.space2,
                        runSpacing: AppSpacing.space2,
                        alignment: WrapAlignment.end,
                        children: actions,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DialogHead extends StatelessWidget {
  const _DialogHead({required this.title, required this.closeLabel});

  final String title;
  final String closeLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.space3, horizontal: AppSpacing.space4),
      color: AppColors.wood700,
      child: Row(
        spacing: AppSpacing.space2,
        children: [
          Expanded(child: Text(title, style: _titleStyle)),
          RoundIconButton(
            label: closeLabel,
            glyph: InterfaceGlyph.close,
            size: RoundIconButtonSize.extraSmall,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
