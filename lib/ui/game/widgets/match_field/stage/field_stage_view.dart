import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:going_wild/domain/models/combat_history/replay/combat_replay_combatant.dart';
import 'package:going_wild/ui/game/view_models/combat_playback/combat_playback_bloc.dart';
import 'package:going_wild/ui/game/view_models/combat_playback/states/combat_playback_state.dart';
import 'package:going_wild/ui/game/widgets/match_field/stage/field_stage.dart';

class FieldStageView extends StatefulWidget {
  const FieldStageView({required this.stage, required this.standingCombatants, required this.hiddenIds, super.key});

  final FieldStage stage;
  final Set<int> hiddenIds;
  final Iterable<CombatReplayCombatant>? standingCombatants;

  @override
  State<FieldStageView> createState() => _FieldStageViewState();
}

class _FieldStageViewState extends State<FieldStageView> {
  @override
  void initState() {
    super.initState();
    _standStill();
  }

  @override
  void didUpdateWidget(FieldStageView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _standStill();
  }

  void _standStill() {
    final standingCombatants = widget.standingCombatants;
    if (standingCombatants != null) widget.stage.standStill(standingCombatants, hiddenIds: widget.hiddenIds);
  }

  void _playCombatStep(BuildContext context, CombatPlaybackState playbackState) {
    if (playbackState is! PlayingCombatPlaybackState) return;

    widget.stage.followPlayback(
      playbackState.combatReplay,
      currentTick: playbackState.currentTick,
      timeScale: playbackState.speed.multiplier.toDouble(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CombatPlaybackBloc, CombatPlaybackState>(
      listener: _playCombatStep,
      child: IgnorePointer(child: GameWidget(game: widget.stage)),
    );
  }
}
