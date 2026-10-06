import 'package:flutter/widgets.dart';
import 'package:going_wild/domain/models/board/board.dart';
import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/ui/core/design/app_border_width.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';
import 'package:going_wild/ui/core/design/app_shadows.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';
import 'package:going_wild/ui/game/widgets/board_scene/board_scene_layout.dart';

const _toastWidth = 220.0;
const _toastEdgeInset = 8.0;
const _cellOffsetFraction = 0.55;

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

class PositionedFieldRejectionToast extends StatelessWidget {
  final double scale;
  final Board board;
  final String message;
  final Position position;
  const PositionedFieldRejectionToast({
    required this.board,
    required this.scale,
    required this.message,
    required this.position,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cellRect = BoardSceneLayout.cellRectOf(board, position, scale: scale);
    final fieldWidth = BoardSceneLayout.imageSize.width * scale;
    final left = (cellRect.center.dx - _toastWidth / 2).clamp(_toastEdgeInset, fieldWidth - _toastWidth - _toastEdgeInset);

    return Positioned(
      left: left,
      width: _toastWidth,
      top: cellRect.top - cellRect.height * _cellOffsetFraction,
      child: IgnorePointer(
        child: Center(child: FieldRejectionToast(message: message)),
      ),
    );
  }
}
