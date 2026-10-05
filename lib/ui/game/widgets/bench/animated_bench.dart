import 'package:flutter/widgets.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/ui/game/widgets/bench/bench_layout.dart';
import 'package:going_wild/ui/game/widgets/bench/bench_shop_tile.dart';
import 'package:going_wild/ui/game/widgets/bench/bench_slot.dart';

const _expansionDuration = Duration(milliseconds: 420);

class AnimatedBench extends StatefulWidget {
  final bool isExpanded;
  final List<CharacterCopy?> benchCopies;
  const AnimatedBench({required this.isExpanded, required this.benchCopies, super.key});

  @override
  State<AnimatedBench> createState() => _AnimatedBenchState();
}

class _AnimatedBenchState extends State<AnimatedBench> with SingleTickerProviderStateMixin {
  late final _expansionController = AnimationController(
    vsync: this,
    duration: _expansionDuration,
    value: widget.isExpanded ? 1 : 0,
  );

  late final _expansion = CurvedAnimation(parent: _expansionController, curve: Curves.easeInOutCubic);

  @override
  void didUpdateWidget(AnimatedBench oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded == oldWidget.isExpanded) return;

    if (widget.isExpanded) {
      _expansionController.forward();
      return;
    }

    _expansionController.reverse();
  }

  @override
  void dispose() {
    _expansion.dispose();
    _expansionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => AnimatedBuilder(
        animation: _expansion,
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
                for (final (slotIndex, characterCopy) in widget.benchCopies.indexed)
                  Positioned.fromRect(
                    rect: layout.slotRectOf(slotIndex),
                    child: BenchSlot(
                      slotNumber: slotIndex + 1,
                      characterCopy: characterCopy,
                      nameOpacity: layout.nameOpacity,
                    ),
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
}
