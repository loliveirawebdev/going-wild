import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_border_width.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';
import 'package:going_wild/ui/core/design/app_shadows.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';

const _gapAboveChild = 6.0;
const _maxBubbleWidth = 220.0;
const _arrowSize = Size(14, 7);
const _screenEdgeMargin = AppSpacing.space2;

const _reasonTextStyle = TextStyle(
  height: 18 / 13,
  fontSize: 13,
  color: AppColors.onPrimary,
  fontFamily: AppFonts.sans,
  fontWeight: FontWeight.w800,
);

enum _BubblePart { body, arrow }

class ReasonBubble extends StatelessWidget {
  const ReasonBubble({required this.child, required this.reason, required this.controller, super.key});

  final Widget child;
  final String reason;
  final OverlayPortalController controller;

  @override
  Widget build(BuildContext context) {
    return OverlayPortal.overlayChildLayoutBuilder(
      controller: controller,
      overlayChildBuilder: (context, layoutInfo) {
        final childRect = MatrixUtils.transformRect(layoutInfo.childPaintTransform, Offset.zero & layoutInfo.childSize);

        return IgnorePointer(
          child: CustomMultiChildLayout(
            delegate: _BubbleLayoutDelegate(childRect: childRect),
            children: [
              LayoutId(
                id: _BubblePart.body,
                child: _BubbleBody(reason: reason),
              ),
              LayoutId(
                id: _BubblePart.arrow,
                child: CustomPaint(size: _arrowSize, painter: _ArrowPainter()),
              ),
            ],
          ),
        );
      },
      child: child,
    );
  }
}

class _BubbleLayoutDelegate extends MultiChildLayoutDelegate {
  _BubbleLayoutDelegate({required this.childRect});

  final Rect childRect;

  @override
  void performLayout(Size size) {
    final maxBodyWidth = min(_maxBubbleWidth, size.width - _screenEdgeMargin * 2);
    final arrowSize = layoutChild(_BubblePart.arrow, BoxConstraints.tight(_arrowSize));
    final bodySize = layoutChild(_BubblePart.body, BoxConstraints(maxWidth: maxBodyWidth));

    final arrowTop = childRect.top - _gapAboveChild - arrowSize.height;
    final centeredBodyLeft = childRect.center.dx - bodySize.width / 2;
    final bodyLeft = centeredBodyLeft.clamp(_screenEdgeMargin, size.width - _screenEdgeMargin - bodySize.width);

    positionChild(_BubblePart.body, Offset(bodyLeft, arrowTop - bodySize.height));
    positionChild(_BubblePart.arrow, Offset(childRect.center.dx - arrowSize.width / 2, arrowTop));
  }

  @override
  bool shouldRelayout(_BubbleLayoutDelegate oldDelegate) => oldDelegate.childRect != childRect;
}

class _BubbleBody extends StatelessWidget {
  const _BubbleBody({required this.reason});

  final String reason;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.wood700,
        boxShadow: AppShadows.float,
        borderRadius: AppRadius.small,
        border: Border.all(color: AppColors.wood700, width: AppBorderWidth.thick),
      ),
      child: Text(reason, textAlign: TextAlign.center, style: _reasonTextStyle),
    );
  }
}

class _ArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final arrow = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();

    canvas.drawPath(arrow, Paint()..color = AppColors.wood700);
  }

  @override
  bool shouldRepaint(_ArrowPainter oldDelegate) => false;
}
