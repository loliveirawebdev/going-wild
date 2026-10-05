import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:going_wild/domain/models/phase/phase.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/game/widgets/board_scene/board_scene.dart';
import 'package:going_wild/ui/game/widgets/match_top_bar/match_top_bar.dart';
import 'package:going_wild/ui/game/widgets/set_chips/preview_board_characters.dart';
import 'package:going_wild/ui/game/widgets/set_chips/set_chip_row.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({required this.phase, super.key});

  final Phase phase;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.sceneGrass,
        body: Stack(
          children: [
            Positioned(top: 0, left: 0, right: 0, child: BoardScene(board: phase.engines.combatEngine.board)),
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  MatchTopBar(),
                  SetChipRow(previewBoardCharacters: kDebugMode ? previewBoardCharacters : null),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
