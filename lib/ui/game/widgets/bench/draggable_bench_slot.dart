import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/domain/models/roster/roster_slot.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';
import 'package:going_wild/ui/core/design/app_shadows.dart';
import 'package:going_wild/ui/game/view_models/roster_drag/roster_drag.dart';
import 'package:going_wild/ui/game/view_models/roster_drag/roster_drag_view_model.dart';
import 'package:going_wild/ui/game/widgets/bench/bench_slot.dart';

const _liftedScale = 1.08;
const _overCellScale = 0.5;
const _scaleDuration = Duration(milliseconds: 120);
const _liftedSize = Size(78, 72);

class DraggableBenchSlot extends StatelessWidget {
  const DraggableBenchSlot({
    required this.slotIndex,
    required this.nameOpacity,
    required this.slideOffset,
    required this.characterCopy,
    required this.onCopyDropped,
    required this.onBoardCopyDropped,
    required this.canDrag,
    super.key,
    this.onPressed,
  });

  final bool canDrag;
  final int slotIndex;
  final double nameOpacity;
  final Offset slideOffset;
  final VoidCallback? onPressed;
  final CharacterCopy? characterCopy;
  final ValueChanged<int> onCopyDropped;
  final ValueChanged<Position> onBoardCopyDropped;

  InventorySlot get _inventorySlot => InventorySlot(index: slotIndex);

  @override
  Widget build(BuildContext context) {
    final characterCopy = this.characterCopy;

    return DragTarget<RosterSlot>(
      onWillAcceptWithDetails: (details) => switch (details.data) {
        InventorySlot(:final index) => index != slotIndex,
        BoardSlot() => true,
      },

      onAcceptWithDetails: (details) => switch (details.data) {
        InventorySlot(:final index) => onCopyDropped(index),
        BoardSlot(:final position) => onBoardCopyDropped(position),
      },

      builder: (context, candidates, rejections) {
        final slot = BenchSlot(
          onPressed: onPressed,
          nameOpacity: nameOpacity,
          slotNumber: slotIndex + 1,
          characterCopy: characterCopy,
          isDropTarget: candidates.isNotEmpty,
        );

        if (characterCopy == null) {
          return Transform.translate(
            offset: slideOffset,
            child: slot,
          );
        }

        final rosterDragViewModel = context.read<RosterDragViewModel>();

        return Draggable<RosterSlot>(
          data: _inventorySlot,
          maxSimultaneousDrags: canDrag ? 1 : 0,
          dragAnchorStrategy: pointerDragAnchorStrategy,
          onDragEnd: (details) => rosterDragViewModel.stopDragging(),
          onDragStarted: () => rosterDragViewModel.startDragging(_inventorySlot),
          onDragUpdate: (details) => rosterDragViewModel.moveDragTo(details.globalPosition),
          feedback: _LiftedBenchUnit(
            characterCopy: characterCopy,
            slotNumber: slotIndex + 1,
            rosterDragViewModel: rosterDragViewModel,
          ),
          childWhenDragging: BenchSlot(nameOpacity: nameOpacity, slotNumber: slotIndex + 1, characterCopy: null),
          child: Transform.translate(offset: slideOffset, child: slot),
        );
      },
    );
  }
}

class _LiftedBenchUnit extends StatelessWidget {
  final int slotNumber;
  final CharacterCopy characterCopy;
  final RosterDragViewModel rosterDragViewModel;
  const _LiftedBenchUnit({required this.slotNumber, required this.characterCopy, required this.rosterDragViewModel});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: -_liftedSize.center(Offset.zero),
      child: BlocBuilder<RosterDragViewModel, RosterDrag?>(
        bloc: rosterDragViewModel,
        buildWhen: (previous, current) => (previous?.hoveredPosition == null) != (current?.hoveredPosition == null),
        builder: (context, drag) => AnimatedScale(
          curve: Curves.easeOut,
          duration: _scaleDuration,
          scale: drag?.hoveredPosition == null ? _liftedScale : _overCellScale,
          child: DecoratedBox(
            decoration: const BoxDecoration(borderRadius: AppRadius.small, boxShadow: AppShadows.float),
            child: SizedBox.fromSize(
              size: _liftedSize,
              child: BenchSlot(nameOpacity: 1, slotNumber: slotNumber, characterCopy: characterCopy),
            ),
          ),
        ),
      ),
    );
  }
}
