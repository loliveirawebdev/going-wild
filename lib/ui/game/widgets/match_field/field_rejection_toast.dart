import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_border_width.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';
import 'package:going_wild/ui/core/design/app_shadows.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';

const _messageStyle = TextStyle(
  fontSize: 13,
  height: 16 / 13,
  color: AppColors.onPrimary,
  fontFamily: AppFonts.sans,
  fontWeight: FontWeight.w800,
);

class FieldRejectionToast extends StatelessWidget {
  final String message;
  const FieldRejectionToast({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.wood700,
          borderRadius: AppRadius.pill,
          boxShadow: AppShadows.float,
          border: Border.all(color: AppColors.wood700, width: AppBorderWidth.thin),
        ),
        child: Text(message, textAlign: TextAlign.center, style: _messageStyle),
      ),
    );
  }
}
