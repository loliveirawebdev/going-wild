import 'dart:math';

import 'package:flutter/material.dart';
import 'package:going_wild/domain/models/board/board.dart';
import 'package:going_wild/domain/models/board/position.dart';

const _maxBoardWidth = 360.0;
const _cellScale = 0.94;

class BoardGrid extends StatelessWidget {
  const BoardGrid({required this.board, required this.cellBuilder, super.key});

  final Board board;
  final Widget Function(BuildContext context, Position position) cellBuilder;

  @override
  Widget build(BuildContext context) {
    final positions = board.allPositions.toList();
    final leftEdge = positions.map((position) => position.centerX).reduce(min) - sqrt(3) / 2;
    final rightEdge = positions.map((position) => position.centerX).reduce(max) + sqrt(3) / 2;
    final topEdge = positions.map((position) => position.centerY).reduce(min) - 1;
    final bottomEdge = positions.map((position) => position.centerY).reduce(max) + 1;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _maxBoardWidth),
        child: AspectRatio(
          aspectRatio: (rightEdge - leftEdge) / (bottomEdge - topEdge),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final pixelsPerUnit = constraints.maxWidth / (rightEdge - leftEdge);
              final cellWidth = sqrt(3) * pixelsPerUnit * _cellScale;
              final cellHeight = 2 * pixelsPerUnit * _cellScale;

              return Stack(
                children: [
                  for (final position in positions)
                    Positioned(
                      width: cellWidth,
                      height: cellHeight,
                      top: (position.centerY - topEdge) * pixelsPerUnit - cellHeight / 2,
                      left: (position.centerX - leftEdge) * pixelsPerUnit - cellWidth / 2,
                      child: ClipPath(clipper: const _HexagonClipper(), child: cellBuilder(context, position)),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _HexagonClipper extends CustomClipper<Path> {
  const _HexagonClipper();

  @override
  Path getClip(Size size) => Path()
    ..moveTo(size.width / 2, 0)
    ..lineTo(size.width, size.height / 4)
    ..lineTo(size.width, size.height * 3 / 4)
    ..lineTo(size.width / 2, size.height)
    ..lineTo(0, size.height * 3 / 4)
    ..lineTo(0, size.height / 4)
    ..close();

  @override
  bool shouldReclip(_HexagonClipper oldClipper) => false;
}
