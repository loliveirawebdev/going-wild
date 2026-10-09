import 'package:flutter/widgets.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/design/app_border_width.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';
import 'package:going_wild/ui/core/widgets/pill.dart';

const _countSize = 28.0;

const _lineStyle = TextStyle(
  fontSize: 14,
  height: 19 / 14,
  fontFamily: AppFonts.sans,
  fontWeight: FontWeight.w700,
);

const _countStyle = TextStyle(
  fontSize: 16,
  color: AppColors.ink,
  fontFamily: AppFonts.display,
  fontWeight: FontWeight.w400,
);

const _tagStyle = TextStyle(
  fontSize: 11,
  height: 15 / 11,
  color: AppColors.ink,
  fontFamily: AppFonts.sans,
  fontWeight: FontWeight.w900,
);

enum SetTierRowState {
  active,
  pending,
  surpassed;

  bool get isActive => this == active;
}

class SetTierRow extends StatelessWidget {
  const SetTierRow({required this.lines, required this.state, required this.memberCount, super.key});

  final int memberCount;
  final List<String> lines;
  final SetTierRowState state;

  @override
  Widget build(BuildContext context) {
    final isActive = state.isActive;

    return Container(
      padding: const EdgeInsets.fromLTRB(6, 6, 10, 6),
      decoration: BoxDecoration(
        borderRadius: AppRadius.medium,
        color: isActive ? Color.lerp(AppColors.surface100, AppColors.grass400, 0.3) : AppColors.surface100,
        border: Border.all(color: isActive ? AppColors.grass600 : AppColors.surface400, width: AppBorderWidth.thin),
      ),
      child: Row(
        spacing: AppSpacing.space2,
        children: [
          _TierMemberCount(memberCount: memberCount, isActive: isActive),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [for (final line in lines) Text(line, style: _lineStyleOf(state))],
            ),
          ),
          if (isActive) const _ActiveTag(),
        ],
      ),
    );
  }

  TextStyle _lineStyleOf(SetTierRowState state) => switch (state) {
    SetTierRowState.active => _lineStyle.copyWith(color: AppColors.ink),
    SetTierRowState.pending => _lineStyle.copyWith(color: AppColors.inkMuted),
    SetTierRowState.surpassed => _lineStyle.copyWith(
      color: AppColors.inkMuted,
      decoration: TextDecoration.lineThrough,
      decorationColor: AppColors.inkMuted.withValues(alpha: 0.4),
    ),
  };
}

class _TierMemberCount extends StatelessWidget {
  const _TierMemberCount({required this.isActive, required this.memberCount});

  final bool isActive;
  final int memberCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _countSize,
      height: _countSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? AppColors.grass400 : AppColors.surface300,
        border: Border.all(color: isActive ? AppColors.grass600 : AppColors.surface400, width: AppBorderWidth.thin),
      ),
      child: Text('$memberCount', style: _countStyle),
    );
  }
}

class _ActiveTag extends StatelessWidget {
  const _ActiveTag();

  @override
  Widget build(BuildContext context) {
    return Pill(
      color: AppColors.grass400,
      borderColor: AppColors.grass600,
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
      child: Text(context.t.game.setDialog.activeTag.toUpperCase(), style: _tagStyle),
    );
  }
}
