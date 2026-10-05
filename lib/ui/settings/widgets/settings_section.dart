import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_border_width.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';
import 'package:going_wild/ui/core/design/app_shadows.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';

const _innerRadius = BorderRadius.all(Radius.circular(22 - AppBorderWidth.thick));

const _labelStyle = TextStyle(
  fontSize: 12,
  height: 16 / 12,
  letterSpacing: 0.6,
  color: AppColors.inkMuted,
  fontFamily: AppFonts.sans,
  fontWeight: FontWeight.w800,
);

class SettingsSection extends StatelessWidget {
  const SettingsSection({required this.children, super.key, this.label});

  final String? label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final label = this.label;

    return Column(
      spacing: 6,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(label.toUpperCase(), style: _labelStyle),
          ),
        Padding(
          padding: const EdgeInsets.only(bottom: AppShadows.pressOffset),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.surface100,
              borderRadius: AppRadius.large,
              boxShadow: AppShadows.pressNeutral,
              border: Border.all(color: AppColors.surface400, width: AppBorderWidth.thick),
            ),
            child: ClipRRect(
              borderRadius: _innerRadius,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final (index, child) in children.indexed) ...[
                    if (index > 0)
                      const ColoredBox(
                        color: AppColors.surface300,
                        child: SizedBox(height: AppBorderWidth.thin),
                      ),
                    child,
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
