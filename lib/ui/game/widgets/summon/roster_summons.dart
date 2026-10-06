import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:going_wild/domain/models/roster/roster_slot.dart';
import 'package:going_wild/ui/game/view_models/preparation/preparation_bloc.dart';
import 'package:going_wild/ui/game/view_models/preparation/states/preparation_state.dart';

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
  final _summonIds = <SlotKey, int>{};

  void _followPreparation(BuildContext context, PreparationState preparationState) {
    if (preparationState is! ReadyPreparationState || MediaQuery.disableAnimationsOf(context)) return;

    final summonedSlotKeys = preparationState.summonedSlots.map(widget.slotKeyOf).nonNulls;
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
