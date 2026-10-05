import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:going_wild/domain/models/phase/phase.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/game/board_scene/board_scene.dart';

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
          ],
        ),
      ),
    );
  }
}
