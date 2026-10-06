import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/domain/models/roster/roster_slot.dart';
import 'package:going_wild/ui/core/design/app_shadows.dart';
import 'package:going_wild/ui/game/view_models/roster_drag/roster_drag_view_model.dart';
import 'package:going_wild/ui/game/widgets/match_field/units/field_unit_token.dart';

const _liftedScale = 1.2;

class DraggableFieldUnit extends StatelessWidget {
  final double diameter;
  final Position position;
  final VoidCallback onPressed;
  final bool isAnotherDragActive;
  final CharacterCopy characterCopy;
  const DraggableFieldUnit({
    required this.diameter,
    required this.position,
    required this.onPressed,
    required this.characterCopy,
    required this.isAnotherDragActive,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final boardSlot = BoardSlot(position: position);
    final rosterDragViewModel = context.read<RosterDragViewModel>();
    final token = FieldUnitToken(side: FieldUnitSide.team, diameter: diameter, characterCopy: characterCopy);

    return IgnorePointer(
      ignoring: isAnotherDragActive,
      child: Draggable<RosterSlot>(
        data: boardSlot,
        dragAnchorStrategy: pointerDragAnchorStrategy,
        onDragEnd: (details) => rosterDragViewModel.stopDragging(),
        onDragStarted: () => rosterDragViewModel.startDragging(boardSlot),
        onDragUpdate: (details) => rosterDragViewModel.moveDragTo(details.globalPosition),
        childWhenDragging: SizedBox.square(dimension: diameter),
        feedback: Transform.translate(
          offset: Offset(-diameter / 2, -diameter / 2),
          child: Transform.scale(
            scale: _liftedScale,
            child: DecoratedBox(
              decoration: const BoxDecoration(shape: BoxShape.circle, boxShadow: AppShadows.float),
              child: token,
            ),
          ),
        ),
        child: GestureDetector(onTap: onPressed, child: token),
      ),
    );
  }
}
