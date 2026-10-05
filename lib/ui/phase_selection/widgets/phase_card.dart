import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_border_width.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';

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

class PhaseCard extends StatelessWidget {
  const PhaseCard({required this.name, required this.numberLabel, required this.coverAssetPath, super.key});

  final String name;
  final String numberLabel;
  final String coverAssetPath;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: _bottomEdgeHeight),
      child: Container(
        width: _cardWidth,
        decoration: BoxDecoration(
          color: AppColors.surface100,
          borderRadius: AppRadius.large,
          border: Border.all(color: _frameColor, width: _frameWidth),
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
              _Cover(numberLabel: numberLabel, coverAssetPath: coverAssetPath),
              _NameBar(name: name),
            ],
          ),
        ),
      ),
    );
  }
}

class _Cover extends StatelessWidget {
  const _Cover({required this.numberLabel, required this.coverAssetPath});

  final String numberLabel;
  final String coverAssetPath;

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
  const _NameBar({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(AppSpacing.space3, 6, AppSpacing.space3, 7),
      decoration: const BoxDecoration(
        color: _frameColor,
        border: Border(
          top: BorderSide(color: _frameEdgeColor, width: AppBorderWidth.thin),
        ),
      ),
      child: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: _nameStyle),
    );
  }
}
