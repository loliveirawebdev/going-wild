import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_border_width.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';

const _pipHeight = 24.0;

const _memberCountStyle = TextStyle(
  height: 1,
  fontSize: 14,
  fontFamily: AppFonts.display,
  fontWeight: FontWeight.w400,
);

class SetChipMemberCountPip extends StatelessWidget {
  final bool isInactive;
  final int memberCount;
  const SetChipMemberCountPip({required this.isInactive, required this.memberCount, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _pipHeight,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      constraints: const BoxConstraints(minWidth: _pipHeight),
      decoration: BoxDecoration(
        color: AppColors.surface100,
        borderRadius: AppRadius.pill,
        border: Border.all(color: AppColors.surface400, width: AppBorderWidth.thin),
      ),
      child: Text(
        '$memberCount',
        style: _memberCountStyle.copyWith(color: isInactive ? AppColors.inkMuted : AppColors.ink),
      ),
    );
  }
}
