import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_border_width.dart';
import 'package:going_wild/ui/core/design/app_color_filters.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';
import 'package:going_wild/ui/core/design/game_icon.dart';
import 'package:going_wild/ui/core/widgets/game_icon_image.dart';

const _cardWidth = 250.0;
const _coverHeight = 196.0;
const _frameWidth = 3.0;
const _ringWidth = 2.5;
const _sealSize = 34.0;
const _sealIconSize = 22.0;
const _bottomEdgeHeight = 7.0;
const _frameEdgeColor = AppColors.wood700;
const _coverAlignment = Alignment(0.44, 0);
final _innerRadius = AppRadius.insideBorderOf(AppRadius.large, borderWidth: _frameWidth);

const _nameStyle = TextStyle(
  fontSize: 22,
  height: 26 / 22,
  color: AppColors.onPrimary,
  fontFamily: AppFonts.display,
  fontWeight: FontWeight.w400,
);

const _lockedReasonStyle = TextStyle(
  fontSize: 12,
  height: 16 / 12,
  color: AppColors.inkMuted,
  fontFamily: AppFonts.sans,
  fontWeight: FontWeight.w800,
);

const _numberStyle = TextStyle(
  fontSize: 15,
  height: 20 / 15,
  color: AppColors.ink,
  fontFamily: AppFonts.display,
  fontWeight: FontWeight.w400,
);

enum PhaseCardStatus {
  open(frameColor: AppColors.wood500, nameColor: AppColors.onPrimary),
  won(frameColor: AppColors.grass600, nameColor: AppColors.onPrimary),
  locked(frameColor: AppColors.surface400, nameColor: AppColors.ink);

  final Color frameColor;
  final Color nameColor;
  const PhaseCardStatus({required this.frameColor, required this.nameColor});
}

class PhaseCard extends StatelessWidget {
  const PhaseCard({
    required this.name,
    required this.numberLabel,
    required this.coverAssetPath,
    super.key,
    this.lockedReason,
    this.status = PhaseCardStatus.open,
  });

  final String name;
  final String numberLabel;
  final String? lockedReason;
  final String coverAssetPath;
  final PhaseCardStatus status;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: _bottomEdgeHeight),
      child: Container(
        width: _cardWidth,
        decoration: BoxDecoration(
          color: AppColors.surface100,
          borderRadius: AppRadius.large,
          border: Border.all(color: status.frameColor, width: _frameWidth),
          boxShadow: const [
            BoxShadow(color: _frameEdgeColor, spreadRadius: _ringWidth),
            BoxShadow(color: _frameEdgeColor, spreadRadius: _ringWidth, offset: Offset(0, _bottomEdgeHeight)),
          ],
        ),
        child: ClipRRect(
          borderRadius: _innerRadius,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Cover(status: status, numberLabel: numberLabel, coverAssetPath: coverAssetPath),
              _NameBar(name: name, status: status, lockedReason: lockedReason),
            ],
          ),
        ),
      ),
    );
  }
}

class _Cover extends StatelessWidget {
  const _Cover({required this.status, required this.numberLabel, required this.coverAssetPath});

  final String numberLabel;
  final String coverAssetPath;
  final PhaseCardStatus status;

  @override
  Widget build(BuildContext context) {
    final sealIcon = switch (status) {
      PhaseCardStatus.open => null,
      PhaseCardStatus.won => GameIcon.trophy,
      PhaseCardStatus.locked => GameIcon.lock,
    };

    return SizedBox(
      height: _coverHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const ColoredBox(color: AppColors.surface300),
          ColorFiltered(
            colorFilter: status == PhaseCardStatus.locked ? AppColorFilters.fallenArt : AppColorFilters.none,
            child: Image.asset(coverAssetPath, fit: BoxFit.cover, alignment: _coverAlignment),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                stops: const [0, 0.38],
                end: Alignment.topCenter,
                begin: Alignment.bottomCenter,
                colors: [status.frameColor.withValues(alpha: 0.55), status.frameColor.withValues(alpha: 0)],
              ),
            ),
          ),
          Positioned(
            top: AppSpacing.space2,
            left: AppSpacing.space2,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
              decoration: BoxDecoration(
                color: AppColors.surface100,
                borderRadius: AppRadius.pill,
                border: Border.all(color: AppColors.surface400, width: AppBorderWidth.thick),
              ),
              child: Text(numberLabel, style: _numberStyle),
            ),
          ),
          if (sealIcon != null)
            Positioned(
              top: AppSpacing.space2,
              right: AppSpacing.space2,
              child: Container(
                width: _sealSize,
                height: _sealSize,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surface100,
                  border: Border.all(color: status.frameColor, width: AppBorderWidth.thick),
                ),
                child: GameIconImage(sealIcon, size: _sealIconSize),
              ),
            ),
        ],
      ),
    );
  }
}

class _NameBar extends StatelessWidget {
  const _NameBar({required this.name, required this.status, required this.lockedReason});

  final String name;
  final String? lockedReason;
  final PhaseCardStatus status;

  @override
  Widget build(BuildContext context) {
    final lockedReason = this.lockedReason;

    return Container(
      padding: const EdgeInsets.fromLTRB(AppSpacing.space3, 6, AppSpacing.space3, 7),
      decoration: BoxDecoration(
        color: status.frameColor,
        border: const Border(
          top: BorderSide(color: _frameEdgeColor, width: AppBorderWidth.thin),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: _nameStyle.copyWith(color: status.nameColor),
          ),
          if (status == PhaseCardStatus.locked && lockedReason != null) Text(lockedReason, style: _lockedReasonStyle),
        ],
      ),
    );
  }
}
