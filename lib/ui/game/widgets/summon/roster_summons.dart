import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:going_wild/domain/models/roster/roster_slot.dart';
import 'package:going_wild/ui/core/widgets/transient_effects.dart';
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

class _RosterSummonsState<SlotKey extends Object> extends State<RosterSummons<SlotKey>>
    with TransientEffects<RosterSummons<SlotKey>, SlotKey> {
  void _followPreparation(BuildContext context, PreparationState preparationState) {
    if (preparationState is! ReadyPreparationState || MediaQuery.disableAnimationsOf(context)) return;
    spawnEffects(preparationState.summonedSlots.map(widget.slotKeyOf).nonNulls, replacesEqualEffects: true);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PreparationBloc, PreparationState>(
      listener: _followPreparation,
      child: widget.builder(context, transientEffectIds, (slotKey, summonId) => finishEffect(summonId)),
    );
  }
}
