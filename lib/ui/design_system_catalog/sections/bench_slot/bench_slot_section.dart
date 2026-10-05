import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/design_system_catalog/catalog_block_title.dart';
import 'package:going_wild/ui/game/widgets/bench/bench_slot.dart';
import 'package:going_wild/ui/game/widgets/bench/preview_bench_copies.dart';

const _compactSlotSize = Size(42, 54);
const _expandedSlotSize = Size(84, 72);

class BenchSlotSection extends StatelessWidget {
  const BenchSlotSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.space4),
      children: [
        for (final (title, slotSize, nameOpacity) in [('Fechado', _compactSlotSize, 0.0), ('Aberto', _expandedSlotSize, 1.0)]) ...[
          CatalogBlockTitle(title),
          Wrap(
            spacing: AppSpacing.space2,
            runSpacing: AppSpacing.space2,
            children: [
              for (final (slotIndex, characterCopy) in previewBenchCopies.indexed)
                SizedBox.fromSize(
                  size: slotSize,
                  child: BenchSlot(nameOpacity: nameOpacity, slotNumber: slotIndex + 1, characterCopy: characterCopy),
                ),
            ],
          ),
        ],
      ],
    );
  }
}
