import 'package:flutter/widgets.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';
import 'package:going_wild/ui/core/design/app_shadows.dart';
import 'package:going_wild/ui/game/widgets/bench/bench_slot.dart';

const _liftedScale = 1.08;

class DraggableBenchSlot extends StatelessWidget {
  const DraggableBenchSlot({
    required this.slotSize,
    required this.slotIndex,
    required this.isDraggable,
    required this.nameOpacity,
    required this.slideOffset,
    required this.characterCopy,
    required this.onCopyDropped,
    super.key,
    this.onPressed,
  });

  final int slotIndex;
  final Size slotSize;
  final bool isDraggable;
  final double nameOpacity;
  final Offset slideOffset;
  final VoidCallback? onPressed;
  final CharacterCopy? characterCopy;
  final ValueChanged<int> onCopyDropped;

  @override
  Widget build(BuildContext context) {
    final characterCopy = this.characterCopy;

    return DragTarget<int>(
      onWillAcceptWithDetails: (details) => isDraggable && details.data != slotIndex,
      onAcceptWithDetails: (details) => onCopyDropped(details.data),
      builder: (context, candidates, rejections) {
        final slot = BenchSlot(
          onPressed: onPressed,
          nameOpacity: nameOpacity,
          slotNumber: slotIndex + 1,
          characterCopy: characterCopy,
          isDropTarget: candidates.isNotEmpty,
        );

        if (!isDraggable || characterCopy == null) return Transform.translate(offset: slideOffset, child: slot);

        return Draggable<int>(
          data: slotIndex,
          feedback: _LiftedBenchUnit(size: slotSize, characterCopy: characterCopy, slotNumber: slotIndex + 1),
          childWhenDragging: BenchSlot(nameOpacity: nameOpacity, slotNumber: slotIndex + 1, characterCopy: null),
          child: Transform.translate(offset: slideOffset, child: slot),
        );
      },
    );
  }
}

class _LiftedBenchUnit extends StatelessWidget {
  final Size size;
  final int slotNumber;
  final CharacterCopy characterCopy;
  const _LiftedBenchUnit({required this.size, required this.slotNumber, required this.characterCopy});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: _liftedScale,
      child: DecoratedBox(
        decoration: const BoxDecoration(borderRadius: AppRadius.small, boxShadow: AppShadows.float),
        child: SizedBox.fromSize(
          size: size,
          child: BenchSlot(nameOpacity: 1, slotNumber: slotNumber, characterCopy: characterCopy),
        ),
      ),
    );
  }
}
