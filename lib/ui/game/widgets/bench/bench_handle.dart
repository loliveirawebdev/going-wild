import 'package:flutter/widgets.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/interface_glyph.dart';
import 'package:going_wild/ui/core/widgets/interface_glyph_image.dart';

const _handleSize = Size(44, 16);
const _touchAreaSize = Size(88, 28);
const _arrowSize = 13.0;
const _handleRadius = BorderRadius.vertical(top: Radius.circular(10));

class BenchHandle extends StatelessWidget {
  final bool isExpanded;
  final ValueChanged<bool> onExpandedChanged;
  const BenchHandle({required this.isExpanded, required this.onExpandedChanged, super.key});

  void _onDragEnded(DragEndDetails details) {
    final verticalVelocity = details.primaryVelocity ?? 0;
    if (verticalVelocity < 0) onExpandedChanged(true);
    if (verticalVelocity > 0) onExpandedChanged(false);
  }

  @override
  Widget build(BuildContext context) {
    final translations = context.t.game.bench;

    return Semantics(
      button: true,
      container: true,
      label: isExpanded ? translations.collapseButton : translations.expandButton,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onVerticalDragEnd: _onDragEnded,
        onTap: () => onExpandedChanged(!isExpanded),
        child: SizedBox.fromSize(
          size: _touchAreaSize,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: _handleSize.width,
              height: _handleSize.height,
              alignment: Alignment.center,
              decoration: const BoxDecoration(color: AppColors.wood500, borderRadius: _handleRadius),
              child: RotatedBox(
                quarterTurns: isExpanded ? 1 : 3,
                child: const InterfaceGlyphImage(InterfaceGlyph.next, size: _arrowSize, color: AppColors.onPrimary),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
