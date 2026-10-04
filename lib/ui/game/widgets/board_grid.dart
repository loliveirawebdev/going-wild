import 'package:flutter/material.dart';
import 'package:going_wild/domain/models/board/board.dart';
import 'package:going_wild/domain/models/board/position.dart';

const _maxBoardWidth = 360.0;

class BoardGrid extends StatelessWidget {
  const BoardGrid({required this.board, required this.cellBuilder, super.key});

  final Board board;
  final Widget Function(BuildContext context, Position position) cellBuilder;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _maxBoardWidth),
        child: AspectRatio(
          aspectRatio: board.columns / board.rows,
          child: Column(
            children: [
              for (var row = 0; row < board.rows; row++)
                Expanded(
                  child: Row(
                    children: [
                      for (var column = 0; column < board.columns; column++)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(1),
                            child: cellBuilder(context, Position(row: row, column: column)),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
