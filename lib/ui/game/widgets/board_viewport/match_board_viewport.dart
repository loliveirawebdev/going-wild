import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:going_wild/domain/models/match_progress/round_stage.dart';
import 'package:going_wild/ui/game/view_models/preparation/preparation_bloc.dart';
import 'package:going_wild/ui/game/view_models/preparation/states/preparation_state.dart';
import 'package:going_wild/ui/game/widgets/board_scene/board_scene.dart';
import 'package:going_wild/ui/game/widgets/board_viewport/board_framing.dart';
import 'package:going_wild/ui/game/widgets/board_viewport/double_tap_listener.dart';
import 'package:going_wild/ui/game/widgets/board_viewport/scene_top_fill.dart';
import 'package:going_wild/ui/game/widgets/match_field/match_field.dart';

const _reframeDuration = Duration(milliseconds: 320);

class MatchBoardViewport extends StatefulWidget {
  final ValueListenable<double?> closedBenchTop;
  const MatchBoardViewport({required this.closedBenchTop, super.key});

  @override
  State<MatchBoardViewport> createState() => _MatchBoardViewportState();
}

class _MatchBoardViewportState extends State<MatchBoardViewport> with SingleTickerProviderStateMixin {
  final _transformation = TransformationController();
  late final _reframeController = AnimationController(vsync: this, duration: _reframeDuration);
  BoardFraming? _framing;
  Animation<Matrix4>? _reframe;

  @override
  void initState() {
    super.initState();
    widget.closedBenchTop.addListener(_onClosedBenchTopChanged);
    _reframeController.addListener(() => _transformation.value = _reframe?.value ?? _transformation.value);
  }

  @override
  void dispose() {
    widget.closedBenchTop.removeListener(_onClosedBenchTopChanged);
    _reframeController.dispose();
    _transformation.dispose();
    super.dispose();
  }

  void _onClosedBenchTopChanged() => setState(() {});

  void _followFraming(BoardFraming framing) {
    final previousFraming = _framing;
    if (framing == previousFraming) return;

    final isShowingPreviousFraming = previousFraming == null || _transformation.value == transformOf(previousFraming);
    _framing = framing;
    if (!isShowingPreviousFraming) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _framing == framing) _transformation.value = transformOf(framing);
    });
  }

  void _returnToFraming() {
    final framing = _framing;
    if (framing == null) return;

    _reframe = Matrix4Tween(begin: _transformation.value, end: transformOf(framing)).animate(
      CurvedAnimation(parent: _reframeController, curve: Curves.easeOutCubic),
    );
    _reframeController.forward(from: 0);
  }

  bool _hasFightStarted(PreparationState previous, PreparationState current) =>
      previous is ReadyPreparationState &&
      current is ReadyPreparationState &&
      previous.matchProgress.roundStage != RoundStage.fighting &&
      current.matchProgress.roundStage == RoundStage.fighting;

  @override
  Widget build(BuildContext context) {
    return BlocListener<PreparationBloc, PreparationState>(
      listenWhen: _hasFightStarted,
      listener: (context, state) => _returnToFraming(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final viewportSize = constraints.biggest;
          final framing = boardFramingOf(
            viewportSize: viewportSize,
            fieldBottomLimit: widget.closedBenchTop.value ?? viewportSize.height,
          );
          _followFraming(framing);

          return DoubleTapListener(
            onDoubleTap: _returnToFraming,
            child: InteractiveViewer(
              constrained: false,
              minScale: minimumBoardZoom,
              maxScale: maximumBoardZoom,
              transformationController: _transformation,
              child: SizedBox(
                width: viewportSize.width,
                height: framing.contentHeight,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      top: framing.sceneTop,
                      child: BoardScene(overlayBuilder: (context, scale) => MatchField(scale: scale)),
                    ),
                    if (framing.sceneTop > 0) Positioned(top: 0, left: 0, right: 0, child: SceneTopFill(height: framing.sceneTop)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
