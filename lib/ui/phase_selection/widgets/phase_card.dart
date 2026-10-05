import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_border_width.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';
import 'package:going_wild/ui/core/widgets/pressable.dart';

const _cardWidth = 250.0;
const _coverHeight = 196.0;
const _frameWidth = 3.0;
const _ringWidth = 2.5;
const _bottomEdgeHeight = 7.0;
const _frameColor = AppColors.wood500;
const _frameEdgeColor = AppColors.wood700;
const _coverAlignment = Alignment(0.44, 0);
const _innerRadius = BorderRadius.all(Radius.circular(22 - _frameWidth));

const _nameStyle = TextStyle(
  fontSize: 22,
  height: 26 / 22,
  color: AppColors.onPrimary,
  fontFamily: AppFonts.display,
  fontWeight: FontWeight.w400,
);

const _numberStyle = TextStyle(
  fontSize: 15,
  height: 20 / 15,
  color: AppColors.ink,
  fontFamily: AppFonts.display,
  fontWeight: FontWeight.w400,
);

const _detailLabelStyle = TextStyle(
  fontSize: 12,
  letterSpacing: 0.5,
  color: AppColors.inkMuted,
  fontFamily: AppFonts.sans,
  fontWeight: FontWeight.w800,
);

const _detailValueStyle = TextStyle(
  fontSize: 14,
  height: 19 / 14,
  color: AppColors.ink,
  fontFamily: AppFonts.sans,
  fontWeight: FontWeight.w800,
);

class PhaseCardDetail {
  final String label;
  final String value;
  const PhaseCardDetail({required this.label, required this.value});
}

class PhaseCard extends StatelessWidget {
  const PhaseCard({
    required this.name,
    required this.details,
    required this.numberLabel,
    required this.coverAssetPath,
    super.key,
    this.onPressed,
  });

  final String name;
  final String numberLabel;
  final String coverAssetPath;
  final VoidCallback? onPressed;
  final List<PhaseCardDetail> details;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onPressed: onPressed,
      semanticLabel: name,
      builder: (context, pressedAmount, child) => Padding(
        padding: const EdgeInsets.only(bottom: _bottomEdgeHeight),
        child: Container(
          width: _cardWidth,
          transform: Matrix4.translationValues(0, _bottomEdgeHeight * pressedAmount, 0),
          decoration: BoxDecoration(
            color: AppColors.surface100,
            borderRadius: AppRadius.large,
            border: Border.all(color: _frameColor, width: _frameWidth),
            boxShadow: [
              const BoxShadow(color: _frameEdgeColor, spreadRadius: _ringWidth),
              BoxShadow(
                color: _frameEdgeColor,
                spreadRadius: _ringWidth,
                offset: Offset(0, _bottomEdgeHeight * (1 - pressedAmount)),
              ),
            ],
          ),
          child: child,
        ),
      ),
      child: ClipRRect(
        borderRadius: _innerRadius,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Cover(numberLabel: numberLabel, coverAssetPath: coverAssetPath),
            _NameBar(name: name),
            _Details(details: details),
          ],
        ),
      ),
    );
  }
}

class _Cover extends StatelessWidget {
  final String numberLabel;
  final String coverAssetPath;
  const _Cover({required this.numberLabel, required this.coverAssetPath});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _coverHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const ColoredBox(color: AppColors.surface300),
          Image.asset(coverAssetPath, fit: BoxFit.cover, alignment: _coverAlignment),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                stops: const [0, 0.38],
                end: Alignment.topCenter,
                begin: Alignment.bottomCenter,
                colors: [_frameColor.withValues(alpha: 0.55), _frameColor.withValues(alpha: 0)],
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
        ],
      ),
    );
  }
}

class _NameBar extends StatelessWidget {
  final String name;
  const _NameBar({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(AppSpacing.space3, 6, AppSpacing.space3, 7),
      decoration: const BoxDecoration(
        color: _frameColor,
        border: Border.symmetric(
          horizontal: BorderSide(
            color: _frameEdgeColor,
            width: AppBorderWidth.thin,
          ),
        ),
      ),
      child: Text(
        name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: _nameStyle,
      ),
    );
  }
}

class _Details extends StatelessWidget {
  final List<PhaseCardDetail> details;
  const _Details({required this.details});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.space3, 10, AppSpacing.space3, AppSpacing.space3),
      child: Column(
        spacing: 6,
        children: [
          for (final detail in details)
            Row(
              spacing: AppSpacing.space2,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(detail.label.toUpperCase(), style: _detailLabelStyle),
                Flexible(
                  child: Text(detail.value, maxLines: 1, overflow: TextOverflow.ellipsis, style: _detailValueStyle),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
