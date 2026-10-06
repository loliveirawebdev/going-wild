import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/domain/models/match_progress/round_stage.dart';
import 'package:going_wild/domain/models/roster/roster_slot.dart';
import 'package:going_wild/ui/game/view_models/preparation/preparation_bloc.dart';
import 'package:going_wild/ui/game/view_models/preparation/states/preparation_state.dart';
import 'package:going_wild/ui/game/widgets/summon/summoned_slots.dart';

typedef SummonFinished<SlotKey> = void Function(SlotKey slotKey, int summonId);

class RosterSummons<SlotKey extends Object> extends StatefulWidget {
  final SlotKey? Function(RosterSlot slot) slotKeyOf;
  final Widget Function(BuildContext context, Map<SlotKey, int> summonIds, SummonFinished<SlotKey> onSummonFinished) builder;
  const RosterSummons({required this.slotKeyOf, required this.builder, super.key});

  @override
  State<RosterSummons<SlotKey>> createState() => _RosterSummonsState<SlotKey>();
}

class _RosterSummonsState<SlotKey extends Object> extends State<RosterSummons<SlotKey>> {
  var _nextSummonId = 0;

  MatchProgress? _lastMatchProgress;
  final _summonIds = <SlotKey, int>{};

  @override
  void initState() {
    super.initState();
    final preparationState = context.read<PreparationBloc>().state;
    if (preparationState is ReadyPreparationState) _lastMatchProgress = preparationState.matchProgress;
  }

  void _followPreparation(BuildContext context, PreparationState preparationState) {
    if (preparationState is! ReadyPreparationState) return;

    final previousMatchProgress = _lastMatchProgress;
    final currentMatchProgress = preparationState.matchProgress;
    _lastMatchProgress = currentMatchProgress;

    final isRearranging =
        previousMatchProgress?.roundStage == RoundStage.preparing && currentMatchProgress.roundStage == RoundStage.preparing;
    if (previousMatchProgress == null || !isRearranging || MediaQuery.disableAnimationsOf(context)) return;

    final summonedSlotKeys = summonedSlotsBetween(
      previous: previousMatchProgress.playerRoster,
      current: currentMatchProgress.playerRoster,
    ).map(widget.slotKeyOf).nonNulls;
    if (summonedSlotKeys.isEmpty) return;

    setState(() {
      for (final slotKey in summonedSlotKeys) {
        _summonIds[slotKey] = _nextSummonId++;
      }
    });
  }

  void _finishSummon(SlotKey slotKey, int summonId) {
    if (_summonIds[slotKey] != summonId) return;
    setState(() => _summonIds.remove(slotKey));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PreparationBloc, PreparationState>(
      listener: _followPreparation,
      child: widget.builder(context, Map.unmodifiable(_summonIds), _finishSummon),
    );
  }
}
