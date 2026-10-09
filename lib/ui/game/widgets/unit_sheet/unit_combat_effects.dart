import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:going_wild/domain/models/combat_history/replay/combat_replay_combatant.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/design/app_border_width.dart';
import 'package:going_wild/ui/core/design/app_color_filters.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';
import 'package:going_wild/ui/core/design/game_icon.dart';
import 'package:going_wild/ui/core/widgets/game_icon_image.dart';
import 'package:going_wild/ui/core/widgets/pill.dart';
import 'package:going_wild/ui/game/widgets/unit_sheet/combat_effect_badges.dart';

const _iconSize = 16.0;
const _pillSpacing = 6.0;
const _rowHeight = _iconSize + 4 + AppBorderWidth.thin * 2;
const _dashLength = 4.0;
const _dashGap = 3.0;

class UnitCombatEffects extends StatelessWidget {
  const UnitCombatEffects({required this.combatant, required this.edgeBleed, super.key});

  final double edgeBleed;
  final CombatReplayCombatant combatant;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bledWidth = constraints.maxWidth + edgeBleed * 2;
        final fadeStop = edgeBleed / bledWidth;

        return SizedBox(
          height: _rowHeight,
          child: OverflowBox(
            maxWidth: bledWidth,
            minWidth: bledWidth,
            child: ShaderMask(
              blendMode: BlendMode.dstIn,
              shaderCallback: (bounds) => LinearGradient(
                stops: [0, fadeStop, 1 - fadeStop, 1],
                colors: const [Color(0x00000000), Color(0xFF000000), Color(0xFF000000), Color(0x00000000)],
              ).createShader(bounds),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: edgeBleed),
                child: Row(
                  spacing: _pillSpacing,
                  children: _pillsOf(context),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _pillsOf(BuildContext context) {
    final labels = context.t.game.unitSheet.effects;

    if (!combatant.isAlive) {
      return [
        _EffectPill(
          label: labels.fallen,
          icon: ColorFiltered(
            colorFilter: AppColorFilters.lostIcon,
            child: const GameIconImage(GameIcon.heart, size: _iconSize),
          ),
        ),
      ];
    }

    final badges = combatEffectBadgesOf(context.t, combatant.combatLastingEffects);
    if (badges.isEmpty) return [_NoEffectsPill(label: labels.none)];

    return [
      for (final badge in badges)
        _EffectPill(
          label: badge.label,
          icon: SvgPicture.asset(badge.icon.assetPath, width: _iconSize, height: _iconSize),
        ),
    ];
  }
}

class _EffectPill extends StatelessWidget {
  const _EffectPill({required this.icon, required this.label});

  final Widget icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Pill(
      leading: icon,
      height: _rowHeight,
      color: AppColors.surface200,
      borderColor: AppColors.outline,
      padding: const EdgeInsets.fromLTRB(3, 0, 8, 0),
      child: Text(label, style: AppTextStyles.tag),
    );
  }
}

class _NoEffectsPill extends StatelessWidget {
  const _NoEffectsPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: const _DashedPillPainter(),
      child: Container(
        height: _rowHeight,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(label, style: AppTextStyles.tag.copyWith(color: AppColors.inkMuted)),
      ),
    );
  }
}

class _DashedPillPainter extends CustomPainter {
  const _DashedPillPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const inset = AppBorderWidth.thin / 2;
    final pillRect = (Offset.zero & size).deflate(inset);
    final pillPath = Path()..addRRect(RRect.fromRectAndRadius(pillRect, Radius.circular(pillRect.height / 2)));
    final dashPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = AppColors.surface400
      ..strokeWidth = AppBorderWidth.thin;

    for (final outline in pillPath.computeMetrics()) {
      for (var start = 0.0; start < outline.length; start += _dashLength + _dashGap) {
        canvas.drawPath(outline.extractPath(start, start + _dashLength), dashPaint);
      }
    }
  }

  @override
  bool shouldRepaint(_DashedPillPainter oldDelegate) => false;
}
