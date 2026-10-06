import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:going_wild/domain/models/phase/phase.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/game/widgets/board_viewport/match_board_viewport.dart';
import 'package:going_wild/ui/game/widgets/exit_match_guard.dart';
import 'package:going_wild/ui/game/widgets/match_shelves/match_bottom.dart';
import 'package:going_wild/ui/game/widgets/match_top_bar/match_top_bar.dart';
import 'package:going_wild/ui/game/widgets/phase_result/phase_result_overlay.dart';
import 'package:going_wild/ui/game/widgets/round_banner/round_banner_overlay.dart';
import 'package:going_wild/ui/game/widgets/set_chips/set_chip_row.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({required this.phase, super.key});
  final Phase phase;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final _closedBenchTop = ValueNotifier<double?>(null);

  @override
  void dispose() {
    _closedBenchTop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: ExitMatchGuard(
        child: Scaffold(
          backgroundColor: AppColors.sceneGrass,
          body: Stack(
            children: [
              Positioned.fill(child: MatchBoardViewport(closedBenchTop: _closedBenchTop)),
              const Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MatchTopBar(),
                    SetChipRow(),
                  ],
                ),
              ),
              Positioned.fill(child: MatchBottom(onClosedBenchTopChanged: (closedBenchTop) => _closedBenchTop.value = closedBenchTop)),
              const Positioned.fill(child: RoundBannerOverlay()),
              const Positioned.fill(child: PhaseResultOverlay()),
            ],
          ),
        ),
      ),
    );
  }
}
