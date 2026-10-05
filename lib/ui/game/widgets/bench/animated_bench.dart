import 'package:flutter/widgets.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/ui/game/widgets/bench/bench_layout.dart';
import 'package:going_wild/ui/game/widgets/bench/bench_shop_tile.dart';
import 'package:going_wild/ui/game/widgets/bench/draggable_bench_slot.dart';

const _expansionDuration = Duration(milliseconds: 420);
const _swapDuration = Duration(milliseconds: 220);

class AnimatedBench extends StatefulWidget {
  const AnimatedBench({
    required this.isExpanded,
    required this.benchCopies,
    required this.onCopyMoved,
    required this.onSlotPressed,
    super.key,
  });

  final bool isExpanded;
  final List<CharacterCopy?> benchCopies;
  final bool Function(int fromIndex, int toIndex) onCopyMoved;
  final void Function(int slotIndex, CharacterCopy characterCopy) onSlotPressed;

  @override
  State<AnimatedBench> createState() => _AnimatedBenchState();
}

class _AnimatedBenchState extends State<AnimatedBench> with TickerProviderStateMixin {
  ({int fromIndex, int toIndex, CharacterCopy movedCopy})? _pendingMove;
  ({int fromIndex, int toIndex})? _swapSlide;
  late final _swapController = AnimationController(vsync: this, duration: _swapDuration);
  late final _swap = CurvedAnimation(parent: _swapController, curve: Curves.easeOutCubic);

  late final _expansionController = AnimationController(
    vsync: this,
    duration: _expansionDuration,
    value: widget.isExpanded ? 1 : 0,
  );

  late final _expansion = CurvedAnimation(parent: _expansionController, curve: Curves.easeInOutCubic);

  @override
  void didUpdateWidget(AnimatedBench oldWidget) {
    super.didUpdateWidget(oldWidget);
    _finishPendingMove();

    if (widget.isExpanded == oldWidget.isExpanded) return;

    if (widget.isExpanded) {
      _expansionController.forward();
      return;
    }

    _expansionController.reverse();
  }

  void _finishPendingMove() {
    final pendingMove = _pendingMove;
    if (pendingMove == null || !identical(widget.benchCopies[pendingMove.toIndex], pendingMove.movedCopy)) return;

    _pendingMove = null;
    if (widget.benchCopies[pendingMove.fromIndex] == null) return;

    _swapSlide = (fromIndex: pendingMove.toIndex, toIndex: pendingMove.fromIndex);
    _swapController.forward(from: 0);
  }

  void _moveCopy(int fromIndex, int toIndex) {
    final movedCopy = widget.benchCopies[fromIndex];
    if (movedCopy == null || !widget.onCopyMoved(fromIndex, toIndex)) return;
    setState(() => _pendingMove = (fromIndex: fromIndex, toIndex: toIndex, movedCopy: movedCopy));
  }

  CharacterCopy? _shownCopyAt(int slotIndex) {
    final pendingMove = _pendingMove;
    if (pendingMove == null) return widget.benchCopies[slotIndex];
    if (slotIndex == pendingMove.fromIndex) return null;
    if (slotIndex == pendingMove.toIndex) return widget.benchCopies[pendingMove.fromIndex];
    return widget.benchCopies[slotIndex];
  }

  List<int> _slotIndicesInPaintOrder() {
    final slidingSlotIndex = _swapSlide?.toIndex;
    final slotIndices = [for (var slotIndex = 0; slotIndex < widget.benchCopies.length; slotIndex++) slotIndex];
    if (slidingSlotIndex == null || _swapController.isCompleted) return slotIndices;

    return [...slotIndices.where((slotIndex) => slotIndex != slidingSlotIndex), slidingSlotIndex];
  }

  Offset _slideOffsetOf(int slotIndex, BenchLayout layout) {
    final swapSlide = _swapSlide;
    if (swapSlide == null || swapSlide.toIndex != slotIndex || _swapController.isCompleted) return Offset.zero;

    final startOffset = layout.slotRectOf(swapSlide.fromIndex).topLeft - layout.slotRectOf(slotIndex).topLeft;
    return startOffset * (1 - _swap.value);
  }

  @override
  void dispose() {
    _swap.dispose();
    _swapController.dispose();
    _expansion.dispose();
    _expansionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => AnimatedBuilder(
        animation: Listenable.merge([_expansion, _swap]),
        builder: (context, child) {
          final layout = BenchLayout(
            width: constraints.maxWidth,
            expansion: _expansion.value,
            slotCount: widget.benchCopies.length,
          );

          return SizedBox(
            height: layout.height,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                for (final slotIndex in _slotIndicesInPaintOrder())
                  Positioned.fromRect(
                    key: ValueKey(slotIndex),
                    rect: layout.slotRectOf(slotIndex),
                    child: _buildSlot(slotIndex, layout),
                  ),
                Positioned.fromRect(
                  rect: layout.shopRect,
                  child: BenchShopTile(size: layout.shopRect.size, radius: layout.shopRadius),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSlot(int slotIndex, BenchLayout layout) {
    final characterCopy = _shownCopyAt(slotIndex);

    return DraggableBenchSlot(
      slotIndex: slotIndex,
      characterCopy: characterCopy,
      nameOpacity: layout.nameOpacity,
      isDraggable: widget.isExpanded,
      slotSize: layout.slotRectOf(slotIndex).size,
      slideOffset: _slideOffsetOf(slotIndex, layout),
      onCopyDropped: (fromIndex) => _moveCopy(fromIndex, slotIndex),
      onPressed: widget.isExpanded && characterCopy != null ? () => widget.onSlotPressed(slotIndex, characterCopy) : null,
    );
  }
}
