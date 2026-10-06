import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:going_wild/domain/models/combat_history/replay/combat_replay_combatant.dart';
import 'package:going_wild/domain/models/combat_history/replay/combat_replay_frame.dart';
import 'package:going_wild/domain/models/phase/phase_engines.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/widgets/dialog.dart';
import 'package:going_wild/ui/game/view_models/combat_playback/combat_playback_bloc.dart';
import 'package:going_wild/ui/game/view_models/combat_playback/states/combat_playback_state.dart';
import 'package:going_wild/ui/game/widgets/unit_sheet/unit_sale.dart';
import 'package:going_wild/ui/game/widgets/unit_sheet/unit_sheet.dart';
import 'package:going_wild/ui/game/widgets/unit_sheet/unit_side.dart';

Future<void> presentLiveCombatUnitSheet(
  BuildContext context, {
  required UnitSide side,
  required PhaseEngines engines,
  required CombatReplayCombatant combatant,
  UnitSale? sale,
}) {
  return presentDialog<void>(
    context,
    barrierLabel: context.t.game.unitSheet.closeButton,
    dialog: LiveCombatUnitSheet(
      side: side,
      sale: sale,
      engines: engines,
      combatant: combatant,
      combatPlayback: context.read<CombatPlaybackBloc>(),
    ),
  );
}

class LiveCombatUnitSheet extends StatelessWidget {
  final UnitSide side;
  final UnitSale? sale;
  final PhaseEngines engines;
  final CombatReplayCombatant combatant;
  final CombatPlaybackBloc combatPlayback;
  const LiveCombatUnitSheet({
    required this.side,
    required this.engines,
    required this.combatant,
    required this.combatPlayback,
    super.key,
    this.sale,
  });

  CombatReplayFrame? _frameOf(CombatPlaybackState playbackState) => switch (playbackState) {
    PlayingCombatPlaybackState() => playbackState.currentFrame,
    FinishedCombatPlaybackState() => playbackState.finalFrame,
    IdleCombatPlaybackState() => null,
  };

  CombatReplayCombatant _liveCombatantIn(CombatPlaybackState playbackState) {
    final frameCombatants = _frameOf(playbackState)?.combatants ?? const [];
    return frameCombatants.where((frameCombatant) => frameCombatant.id == combatant.id).firstOrNull ?? combatant;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CombatPlaybackBloc, CombatPlaybackState>(
      bloc: combatPlayback,
      buildWhen: (previous, current) => _frameOf(current) != null,
      builder: (context, playbackState) => UnitSheet(
        side: side,
        sale: sale,
        engines: engines,
        characterCopy: combatant.characterCopy,
        combatant: _liveCombatantIn(playbackState),
      ),
    );
  }
}
